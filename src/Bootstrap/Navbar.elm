module Bootstrap.Navbar
    exposing
        ( navbar
        , initialState
        , subscriptions
        , fixTop
        , fixBottom
        , faded
        , primary
        , success
        , info
        , warning
        , danger
        , inverse
        , lightCustom
        , darkCustom
        , brand
        , itemLink
        , itemLinkActive
        , textItem
        , formItem
        , customItem
        , container
        , collapseSmall
        , collapseMedium
        , collapseLarge
        , collapseExtraLarge
        , dropdown
        , dropdownItem
        , dropdownDivider
        , dropdownHeader
        , dropdownToggle
        , Option
        , Item
        , CustomItem
        , Brand
        , State
        , Config
        , DropdownToggle
        , DropdownItem
        )

{-| The navbar is a wrapper that positions branding, navigation, and other elements in a concise header.
The navbar is designed to be responsive by default and made interactive with a tiny sprinkle of Elm.


# Navbar
@docs navbar, Config


## Options
@docs primary, success, info, warning, danger, inverse, faded, fixTop, fixBottom, lightCustom, darkCustom, collapseSmall, collapseMedium, collapseLarge, collapseExtraLarge, container, Option


## Brand
@docs brand, Brand

## Menu items
@docs itemLink, itemLinkActive, Item

## Dropdown menu
@docs dropdown, dropdownToggle, dropdownItem, dropdownDivider, dropdownHeader, DropdownToggle, DropdownItem


## Custom items
@docs textItem, formItem, customItem, CustomItem



# State
@docs initialState, State


# Interactive elements and subscriptions
@docs subscriptions


-}

import Html
import Html.Attributes exposing (class, classList, style, type_, id, href)
import Html.Events exposing (onClick, on, onWithOptions)
import Bootstrap.Internal.Grid as GridInternal
import Color
import Dict
import Json.Decode as Json
import DOM
import AnimationFrame
import Window
import Task
import Mouse


{-| Opaque type representing the view state of the navbar and any navbar dropdown menus
-}
type State
    = State VisibilityState


type alias VisibilityState =
    { visibility : Visibility
    , height : Maybe Float
    , windowSize : Maybe Window.Size
    , dropdowns : Dict.Dict String DropdownStatus
    }


type Visibility
    = Hidden
    | StartDown
    | AnimatingDown
    | StartUp
    | AnimatingUp
    | Shown

type DropdownStatus
    = Open
    | ListenClicks
    | Closed

{-| Configuration information for describing the view of the Navbar

* `options` List of [`configuration options`](#options)
* `toMsg` Message function used for stepping the viewstate of the navbar forward
* `withAnimation` Set to True if you wish the menu to slide up/down with an animation effect
* `brand` Optional [`brand`](#brand) element (typically a logo)
* `items` List of menu items that the user can select from
* `customItems` List of custom (inline) items that you may place to the right of the std. navigation items
-}
type alias Config msg =
    { options : List (Option msg)
    , toMsg : State -> msg
    , withAnimation : Bool
    , brand : Maybe (Brand msg)
    , items : List (Item msg)
    , customItems : List (CustomItem msg)
    }


{-| Opaque type represeting available configuration options for the navbar
-}
type Option msg
    = NavbarFix Fix
    | NavbarScheme Scheme
    | Container
    | ToggleAt GridInternal.ScreenSize
    | NavbarAttr (Html.Attribute msg)


type Fix
    = Top
    | Bottom


type alias Scheme =
    { modifier : LinkModifier
    , bgColor : BackgroundColor
    }


type LinkModifier
    = Dark
    | Light


type BackgroundColor
    = Faded
    | Primary
    | Success
    | Info
    | Warning
    | Danger
    | Inverse
    | Custom Color.Color

{-| Opaque type representing a selectable menu item
-}
type Item msg
    = Item
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }
    | NavDropdown (Dropdown msg)


{-| Opaque type representing a custom (inline) navbar item
-}
type CustomItem msg
    = CustomItem (Html.Html msg)


{-| Opaque type representing a brand element
-}
type Brand msg
    = Brand (Html.Html msg)


type Dropdown msg
    = Dropdown
        { id : String
        , toggle : DropdownToggle msg
        , items : List (DropdownItem msg)
        }

{-| Opaque type representing the toggle element for a dropdown menu
-}
type DropdownToggle msg
    = DropdownToggle
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }

{-| Opaque type representing an item in a dropdown menu
-}
type DropdownItem msg
    = DropdownItem (Html.Html msg)



{-| You need to call this function to initialize the view state for the navbar
and store the state in your main model.

    init : ( Model, Cmd Msg )
    init =
        let
            (navbarState, navCmd) =
                Navbar.initializeState NavbarMsg
        in
            ( { navbarState = navbarState }
            , navCmd
            )

The Cmd part is needed, because the navbar as implemented currently needs the window size.
Hopefully a smoother solution can be devised in the future.


-}
initialState : (State -> msg) -> (State, Cmd msg)
initialState toMsg =
    let
        state =
            State
                { visibility = Hidden
                , height = Nothing
                , windowSize = Nothing
                , dropdowns = Dict.empty
                }
    in
        ( state, initWindowSize toMsg state)


initWindowSize : (State -> msg) -> State  -> Cmd msg
initWindowSize toMsg state  =
    Window.size
        |> Task.perform
            (\size ->
                toMsg <|
                    mapState (\s -> { s | windowSize = Just size }) state
            )


{-| To support animations and managing the state of dropdown you need to wire up this
function in your main subscriptions function.

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Navbar.subscriptions model.navbarState NavbarMsg


**Note: ** If you ar NOT using dropdowns in your navbar AND you are using a navbar without animation
you can skip this. But it's not that much work, so maybe you are better off doing it anyway.
-}
subscriptions : State -> (State -> msg) -> Sub msg
subscriptions (State { visibility } as state) toMsg =
    let
        updState v =
            mapState
                (\s -> { s | visibility = v })
                state
    in
        Sub.batch
            [ case visibility of
                StartDown ->
                    AnimationFrame.times
                        (\_ -> toMsg <| updState AnimatingDown)

                StartUp ->
                    AnimationFrame.times
                        (\_ -> toMsg <| updState AnimatingUp)

                _ ->
                    Sub.none
            , Window.resizes
                (\size ->
                    mapState (\s -> { s | windowSize = Just size }) state
                        |> toMsg
                )
            , dropdownSubscriptions state toMsg
            ]

dropdownSubscriptions : State -> (State -> msg) -> Sub msg
dropdownSubscriptions (State {dropdowns} as state) toMsg =
    let
        updDropdowns =
            Dict.map
                (\_ status ->
                    case status of
                        Open -> ListenClicks
                        ListenClicks -> Closed
                        Closed -> Closed
                )
                dropdowns

        updState =
            mapState (\s -> {s | dropdowns = updDropdowns}) state

        needsSub s =
            Dict.toList dropdowns
                |> List.any (\(_, status) -> status == s )
    in
        Sub.batch
            [ if needsSub Open then
                  AnimationFrame.times
                      (\_ ->  toMsg updState)
              else
                  Sub.none

            , if needsSub ListenClicks then
                  Mouse.clicks
                      (\_ ->  toMsg updState)
              else
                  Sub.none
            ]


{-| The main view function for displaying a navbar.

    Navbar.navbar
        model.navbarState
        { toMsg = NavbarMsg
        , withAnimation = True
        , options =
            [ Navbar.container
            , Navbar.collapsMedium
            ]
        , brand = Just <| Navbar.brand [ href "#" ] [ text "Logo" ]
        , items =
            [ Navbar.itemLink [ href "#" ] [ text "Page" ]
            , Navbar.itemLinkActive [ href "#" ] [ text "Another" ]
            , Navbar.itemLink [ href "#" ] [ text "More" ]
            , Navbar.dropdown
                { id = "navdropdown1"
                , toggle = Navbar.dropdownToggle [] [ text "Navdrop" ]
                , items =
                    [ Navbar.dropdownItem [ href "#" ] [ text "Menuitem1" ]
                    , Navbar.dropdownItem [ href "#" ] [ text "Menuitem2" ]
                    ]
                }
            ]
        , customItems =
            [ Navbar.textItem [] [ text "Some text" ]
            , Navbar.formItem [ class "ml-xl-2" ]
                [ Input.text
                    [Input.small]
                , Button.button
                    [ Button.roleSuccess, Button.small]
                    [ text "Submit"]]
            ]
        }


* `state` Required view state the navbar uses to support interactive behavior
* `config` The view [`configuration`](#Configuration) that determines to look and feel of the navbar

-}
navbar :
    State
    -> Config msg
    -> Html.Html msg
navbar state ({ options, brand, items, customItems } as config) =
    let
        updConfig =
            { config | options = ensureToggleable options }
    in
        Html.nav
            (navbarAttributes updConfig.options)
            (maybeBrand brand
                ++ [ Html.button
                        [ class "navbar-toggler navbar-toggler-right"
                        , type_ "button"
                        , toggleHandler state updConfig
                        ]
                        [ Html.span [ class "navbar-toggler-icon" ] [] ]
                   , Html.div
                        (menuAttributes state updConfig)
                        [ Html.div (menuWrapperAttributes state updConfig)
                            ([ renderNav state updConfig items ] ++ renderCustom customItems)
                        ]
                   ]
            )



{-| Option to fix the menu to the top of the viewport

**Note: You probably need to add some margin-top to the content element following the navbar when using this option **
-}
fixTop : Option msg
fixTop =
    NavbarFix Top


{-| Option to fix the menu to the bottom of the viewport
-}
fixBottom : Option msg
fixBottom =
    NavbarFix Bottom


{-| Use this option when you want a fixed width menu (typically because you're main content is also confgirued to be fixed width)
-}
container : Option msg
container =
    Container


{-| Inverse the colors of your menu. Dark background and light text
-}
inverse : Option msg
inverse =
    scheme Dark Inverse


{-| Give your menu a light faded gray look
-}
faded : Option msg
faded =
    scheme Light Faded


{-| Option to color menu using the primary color
-}
primary : Option msg
primary =
    scheme Dark Primary


{-| Option to color menu using the success color
-}
success : Option msg
success =
    scheme Dark Success


{-| Option to color menu using the info color
-}
info : Option msg
info =
    scheme Dark Info

{-| Option to color menu using the warning color
-}
warning : Option msg
warning =
    scheme Dark Warning


{-| Option to color menu using the danger color
-}
danger : Option msg
danger =
    scheme Dark Danger


{-| Option to color menu using a dark custom background color
-}
darkCustom : Color.Color -> Option msg
darkCustom color =
    scheme Dark <| Custom color


{-| Option to color menu using a light custom background color
-}
lightCustom : Color.Color -> Option msg
lightCustom color =
    scheme Light <| Custom color


{-| Collapse the menu at the small media breakpoint
-}
collapseSmall : Option msg
collapseSmall =
    ToggleAt GridInternal.Small


{-| Collapse the menu at the medium media breakpoint
-}
collapseMedium : Option msg
collapseMedium =
    ToggleAt GridInternal.Medium


{-| Collapse the menu at the large media breakpoint
-}
collapseLarge : Option msg
collapseLarge =
    ToggleAt GridInternal.Large


{-| Collapse the menu at the extra large media breakpoint
-}
collapseExtraLarge : Option msg
collapseExtraLarge =
    ToggleAt GridInternal.ExtraLarge


{-| Create a brand element for your navbar

    Navbar.brand
        [ href "#" ] -- (and perhaps use onWithOptions for custom handling of clicks !)
        [ img [src "assets/logo.svg" ] [ text "MyCompany" ] ]

* `attributes` List of attributes
* `children` List of children
-}
brand : List (Html.Attribute msg) -> List (Html.Html msg) -> Brand msg
brand attributes children =
    Brand <|
        Html.a
            ([ class "navbar-brand" ] ++ attributes)
            children



{-| Create a menu item (as an `a` element)

* `attributes` List of attributes
* `children` List of children

-}
itemLink : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
itemLink attributes children =
    Item
        { attributes = attributes
        , children = children
        }


{-| Create a menu item that is styled as active (as an `a` element)

* `attributes` List of attributes
* `children` List of children

-}
itemLinkActive : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
itemLinkActive attributes =
    itemLink (class "active" :: attributes)


{-| Create a custom inline text element, which will float to the right when the menu isn't collapsed

* `attributes` List of attributes
* `children` List of children


**Note: If you have multiple custom items you will need to provide spacing between them yourself **
-}
textItem : List (Html.Attribute msg) -> List (Html.Html msg) -> CustomItem msg
textItem attributes children =
    Html.span
        (class "navbar-text" :: attributes)
        children
        |> CustomItem


{-| Create a custom inline form element, which will float to the right when the menu isn't collapsed

    Navbar.formItem []
        [ TextInput.text
            [ TextInput.small ]
        , Button.button
            [ Button.roleSuccess, Button.small]
            [ text "Submit"]]
        ]

* `attributes` List of attributes
* `children` List of children


**Note: If you have multiple custom items you will need to provide spacing between them yourself **
-}
formItem : List (Html.Attribute msg) -> List (Html.Html msg) -> CustomItem msg
formItem attributes children =
    Html.form
        (class "form-inline" :: attributes)
        children
        |> CustomItem


{-| Create a completely custom, which will float to the right when the menu isn't collapsed. You should ensure that you create inline elements or else your menu will break in unfortunate ways !

* `attributes` List of attributes
* `children` List of children


**Note: If you have multiple custom items you will need to provide spacing between them yourself **
-}
customItem : Html.Html msg -> CustomItem msg
customItem elem =
    CustomItem elem




toggleHandler : State -> Config msg -> Html.Attribute msg
toggleHandler ((State { height }) as state) { withAnimation, toMsg } =
    let
        updState h  =
            mapState
                (\s ->
                    { s
                        | height = Just h
                        , visibility =
                            visibilityTransition withAnimation s.visibility
                    }
                )
                state
    in
        heightDecoder
            |> Json.andThen
                (\v ->
                    Json.succeed <|
                        toMsg <|
                            (if v > 0 then
                                updState v
                             else
                                updState <| Maybe.withDefault 0 height
                            )
                )
            |> on "click"


heightDecoder : Json.Decoder Float
heightDecoder =
    DOM.target <|
        DOM.parentElement <|
            DOM.nextSibling <|
                DOM.childNode 0 <|
                    DOM.offsetHeight


menuAttributes : State -> Config msg -> List (Html.Attribute msg)
menuAttributes ((State { visibility, height }) as state) ({ withAnimation, toMsg, options } as config) =
    let
        defaults =
            [ class "collapse navbar-collapse" ]
    in
        case visibility of
            Hidden ->
                case height of
                    Nothing ->
                        if not withAnimation || shouldHideMenu state config then
                            defaults
                        else
                            [ style
                                [ ( "display", "block" )
                                , ( "height", "0" )
                                , ( "overflow", "hidden" )
                                ]
                            ]

                    Just _ ->
                        defaults

            StartDown ->
                [ transitionStyle Nothing ]

            AnimatingDown ->
                [ transitionStyle height
                , on "transitionend" <|
                    transitionHandler state config
                ]

            AnimatingUp ->
                [ transitionStyle Nothing
                , on "transitionend" <|
                    transitionHandler state config
                ]

            StartUp ->
                [ transitionStyle height ]

            Shown ->
                defaults ++ [ class "show" ]


menuWrapperAttributes : State -> Config msg -> List (Html.Attribute msg)
menuWrapperAttributes ((State { visibility, height }) as state) config =
    let
        styleBlock
            = [ style [ ( "display", "block" ) ] ]

        display =
            case height of
                Nothing ->
                    if not config.withAnimation || shouldHideMenu state config then
                        "flex"
                    else
                        "block"

                Just _ ->
                    "flex"
    in
        case visibility of
            Hidden ->
                [ style [ ( "display", display ), ( "width", "100%" ) ] ]

            StartDown ->
                styleBlock

            AnimatingDown ->
                styleBlock

            AnimatingUp ->
                styleBlock

            StartUp ->
                styleBlock

            Shown ->
                if not config.withAnimation || shouldHideMenu state config then
                    [ class "collapse navbar-collapse show" ]
                else
                    [ style [ ( "display", "block" ) ] ]


shouldHideMenu : State -> Config msg -> Bool
shouldHideMenu (State { windowSize }) { options } =
    let
        winMedia =
            case windowSize of
                Just s ->
                    toScreenSize s

                Nothing ->
                    GridInternal.ExtraSmall

        toggleMedia =
            getToggleAtOption options
    in
        sizeToComparable winMedia > sizeToComparable toggleMedia


sizeToComparable : GridInternal.ScreenSize -> number
sizeToComparable size =
    case size of
        GridInternal.ExtraSmall ->
            1

        GridInternal.Small ->
            2

        GridInternal.Medium ->
            3

        GridInternal.Large ->
            4

        GridInternal.ExtraLarge ->
            5


getToggleAtOption : List (Option msg) -> GridInternal.ScreenSize
getToggleAtOption options =
    let
        maybeSize =
            List.filterMap
                (\opt ->
                    case opt of
                        ToggleAt size ->
                            Just size

                        _ ->
                            Nothing
                )
                options
                |> List.head
    in
        Maybe.withDefault GridInternal.ExtraSmall maybeSize


toScreenSize : Window.Size -> GridInternal.ScreenSize
toScreenSize { width } =
    if width <= 576 then
        GridInternal.ExtraSmall
    else if width <= 768 then
        GridInternal.Small
    else if width <= 992 then
        GridInternal.Medium
    else if width <= 1200 then
        GridInternal.Large
    else
        GridInternal.ExtraLarge


transitionHandler : State -> Config msg -> Json.Decoder msg
transitionHandler state { toMsg, withAnimation } =
    mapState
        (\s ->
            { s
                | visibility =
                    visibilityTransition withAnimation s.visibility
            }
        )
        state
        |> toMsg
        |> Json.succeed


transitionStyle : Maybe Float -> Html.Attribute msg
transitionStyle maybeHeight =
    let
        pixelHeight =
            Maybe.map (\v -> (toString v) ++ "px") maybeHeight
                |> Maybe.withDefault "0"
    in
        style
            [ ( "position", "relative" )
            , ( "height", pixelHeight )
            , ( "overflow", "hidden" )
            , ( "-webkit-transition-timing-function", "ease" )
            , ( "-o-transition-timing-function", "ease" )
            , ( "transition-timing-function", "ease" )
            , ( "-webkit-transition-duration", "0.35s" )
            , ( "-o-transition-duration", "0.35s" )
            , ( "transition-duration", "0.35s" )
            , ( "-webkit-transition-property", "height" )
            , ( "-o-transition-property", "height" )
            , ( "transition-property", "height" )
            ]


mapState : (VisibilityState -> VisibilityState) -> State -> State
mapState mapper (State state) =
    State <| mapper state


ensureToggleable : List (Option msg) -> List (Option msg)
ensureToggleable options =
    let
        hasToggle =
            List.any
                (\opt ->
                    case opt of
                        ToggleAt _ ->
                            True

                        _ ->
                            False
                )
                options
    in
        if hasToggle then
            options
        else
            (ToggleAt GridInternal.ExtraSmall) :: options


maybeBrand : Maybe (Brand msg) -> List (Html.Html msg)
maybeBrand brand =
    case brand of
        Just (Brand b) ->
            [ b ]

        Nothing ->
            []


renderNav :
    State
    -> Config msg
    -> List (Item msg)
    -> Html.Html msg
renderNav state config navItems =
    Html.ul
        [ class "navbar-nav mr-auto" ]
        (List.map
            (\item ->
                case item of
                    Item item ->
                        renderItemLink item
                    NavDropdown dropdown ->
                        renderDropdown state config dropdown
            )
            navItems
        )

renderItemLink :
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }
    -> Html.Html msg
renderItemLink { attributes, children } =
    Html.li
        [ class "nav-item" ]
        [ Html.a
            ([ class "nav-link" ] ++ attributes)
            children
        ]



renderCustom : List (CustomItem msg) -> List (Html.Html msg)
renderCustom items =
    List.map (\(CustomItem item) -> item) items




scheme : LinkModifier -> BackgroundColor -> Option msg
scheme modifier bgColor =
    { modifier = modifier
    , bgColor = bgColor
    }
        |> NavbarScheme




navbarAttributes : List (Option msg) -> List (Html.Attribute msg)
navbarAttributes options =
    class "navbar" :: List.concatMap navbarAttribute options


navbarAttribute : Option msg -> List (Html.Attribute msg)
navbarAttribute option =
    case option of
        NavbarFix fix ->
            [ class <| fixOption fix ]

        NavbarScheme scheme ->
            schemeAttributes scheme

        Container ->
            [ class "container" ]

        NavbarAttr attr ->
            [ attr ]

        ToggleAt size ->
            [ class <|
                "navbar-toggleable"
                    ++ (Maybe.map (\s -> "-" ++ s) (GridInternal.screenSizeOption size)
                            |> Maybe.withDefault ""
                       )
            ]


fixOption : Fix -> String
fixOption fix =
    case fix of
        Top ->
            "fixed-top"

        Bottom ->
            "fixed-bottom"


schemeAttributes : Scheme -> List (Html.Attribute msg)
schemeAttributes { modifier, bgColor } =
    [ linkModifierClass modifier
    , backgroundColorOption bgColor
    ]


linkModifierClass : LinkModifier -> Html.Attribute msg
linkModifierClass modifier =
    class <|
        case modifier of
            Dark ->
                "navbar-inverse"

            Light ->
                "navbar-light"


backgroundColorOption : BackgroundColor -> Html.Attribute msg
backgroundColorOption bgClass =
    case bgClass of
        Faded ->
            class "bg-faded"

        Primary ->
            class "bg-primary"

        Success ->
            class "bg-success"

        Info ->
            class "bg-info"

        Warning ->
            class "bg-warning"

        Danger ->
            class "bg-danger"

        Inverse ->
            class "bg-inverse"

        Custom color ->
            style [ ( "background-color", toRGBString color ) ]


toRGBString : Color.Color -> String
toRGBString color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        "RGB(" ++ toString red ++ "," ++ toString green ++ "," ++ toString blue ++ ")"


visibilityTransition : Bool -> Visibility -> Visibility
visibilityTransition withAnimation visibility =
    case ( withAnimation, visibility ) of
        ( True, Hidden ) ->
            StartDown

        ( True, StartDown ) ->
            AnimatingDown

        ( True, AnimatingDown ) ->
            Shown

        ( True, Shown ) ->
            StartUp

        ( True, StartUp ) ->
            AnimatingUp

        ( True, AnimatingUp ) ->
            Hidden

        ( False, Hidden ) ->
            Shown

        ( False, Shown ) ->
            Hidden

        _ ->
            Hidden


--- NAV DROPDOWNS


{-| Create a dropdown menu for use in a navbar

* `config` A record with the following properties
    * `id` A unique id for your dropdown. It's important, because it's used to keep track of the state of the dropdown !
    * `toggle` The main item/[`toggle`](#dropdownToggle) that toggles the dropdown menu up or down
-}
dropdown :
    { id : String
    , toggle : DropdownToggle msg
    , items : List (DropdownItem msg)
    }
    -> Item msg
dropdown config =
    Dropdown config |> NavDropdown


{-| Function to construct a toggle for a [`dropdown`](#dropdown)

* attributes List of attributes
* children List of child elements
-}
dropdownToggle :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> DropdownToggle msg
dropdownToggle attributes children =
    DropdownToggle
        { attributes = attributes
        , children = children
        }


{-| Creates an `a` element appropriate for use in a nav dropdown

* `attributes` List of attributes
* `children` List of child elements
-}
dropdownItem : List (Html.Attribute msg) -> List (Html.Html msg) -> DropdownItem msg
dropdownItem attributes children =
    Html.a ([ class "dropdown-item" ] ++ attributes) children
        |> DropdownItem


{-| Creates divider element appropriate for use in dropdowns.
Handy when you want to visually separate groups of menu items in a dropdown menu

* `attributes` List of attributes
* `children` List of child elements
-}
dropdownDivider : DropdownItem msg
dropdownDivider =
    Html.div [ class "dropdown-divider" ] []
        |> DropdownItem

{-| Creates an header element appropriate for use in dropdowns
Handy when you want to provide a heading for a group of menu items in a dropdown menu

* `attributes` List of attributes
* `children` List of child elements
-}
dropdownHeader : List (Html.Html msg) -> DropdownItem msg
dropdownHeader children =
    Html.h6
        [ class "dropdown-header" ]
        children
        |> DropdownItem


renderDropdown :
    State
    -> Config msg
    -> Dropdown msg
    -> Html.Html msg
renderDropdown state config (Dropdown {id, toggle, items}) =
    let
        needsDropup =
            List.any
                (\opt ->
                    case opt of
                        NavbarFix Bottom ->
                            True
                        _ ->
                            False
                )
                config.options
    in
        Html.li
            [ classList
                    [ ( "nav-item", True )
                    , ( "dropdown", True )
                    , ( "dropup", needsDropup)
                    , ( "show", getOrInitDropdownStatus id state /= Closed )
                    ]
            ]
            [ renderDropdownToggle state id config toggle
            , Html.div
                [ class "dropdown-menu" ]
                ( List.map (\(DropdownItem item) -> item) items)
            ]




renderDropdownToggle :
    State
    -> String
    -> Config msg
    -> DropdownToggle msg
    -> Html.Html msg
renderDropdownToggle state id config (DropdownToggle {attributes, children} ) =
    Html.a
        ([ class "nav-link dropdown-toggle"
         , href "#"
         , onWithOptions
             "click"
             { stopPropagation = False
             , preventDefault = True
             }
             <| Json.succeed (toggleOpen state id config)
         ]
            ++ attributes
        )
        children


toggleOpen :
    State
    -> String
    -> Config msg
    -> msg
toggleOpen state id {toMsg} =
    let
        currStatus = getOrInitDropdownStatus id state
        newStatus =
            case currStatus of
                Open ->
                    Closed

                ListenClicks ->
                    Closed

                Closed ->
                    Open
    in
        mapState
            (\s ->
                {s | dropdowns = Dict.insert id newStatus s.dropdowns }
            )
            state
            |> toMsg



getOrInitDropdownStatus : String -> State -> DropdownStatus
getOrInitDropdownStatus id (State {dropdowns}) =
    Dict.get id dropdowns
        |> Maybe.withDefault Closed



