module Bootstrap.Navbar
    exposing
        ( navbar
        , initialState
        , initWindowSize
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
        , brand
        , itemLink
        , customItem
        , container
        , toggleSmall
        , toggleMedium
        , toggleLarge
        , toggleExtraLarge
        , lightCustom
        , darkCustom
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


type alias Config msg =
    { options : List (Option msg)
    , toMsg : State -> msg
    , withAnimation : Bool
    , brand : Maybe (Brand msg)
    , items : List (Item msg)
    , customItems : List (CustomItem msg)
    }


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


type Item msg
    = Item (Html.Html msg)
    | NavDropdown (Dropdown msg)


type CustomItem msg
    = CustomItem (Html.Html msg)


type Brand msg
    = Brand (Html.Html msg)


type Dropdown msg
    = Dropdown
        { id : String
        , toggle : DropdownToggle msg
        , items : List (DropdownItem msg)
        }

type DropdownToggle msg
    = DropdownToggle
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }

type DropdownItem msg
    = DropdownItem (Html.Html msg)




initialState : State
initialState =
    State
        { visibility = Hidden
        , height = Nothing
        , windowSize = Nothing
        , dropdowns = Dict.empty
        }


initWindowSize : State -> (State -> msg) -> Cmd msg
initWindowSize state toMsg =
    Window.size
        |> Task.perform
            (\size ->
                toMsg <|
                    mapState (\s -> { s | windowSize = Just size }) state
            )


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




fixTop : Option msg
fixTop =
    NavbarFix Top


fixBottom : Option msg
fixBottom =
    NavbarFix Bottom


container : Option msg
container =
    Container


inverse : Option msg
inverse =
    scheme Dark Inverse


faded : Option msg
faded =
    scheme Light Faded


primary : Option msg
primary =
    scheme Dark Primary


success : Option msg
success =
    scheme Dark Success


info : Option msg
info =
    scheme Dark Info


warning : Option msg
warning =
    scheme Dark Warning


danger : Option msg
danger =
    scheme Dark Danger


darkCustom : Color.Color -> Option msg
darkCustom color =
    scheme Dark <| Custom color


lightCustom : Color.Color -> Option msg
lightCustom color =
    scheme Light <| Custom color

toggleSmall : Option msg
toggleSmall =
    ToggleAt GridInternal.Small


toggleMedium : Option msg
toggleMedium =
    ToggleAt GridInternal.Medium


toggleLarge : Option msg
toggleLarge =
    ToggleAt GridInternal.Large


toggleExtraLarge : Option msg
toggleExtraLarge =
    ToggleAt GridInternal.ExtraLarge



brand : List (Html.Attribute msg) -> List (Html.Html msg) -> Brand msg
brand attributes children =
    Brand <|
        Html.a
            ([ class "navbar-brand" ] ++ attributes)
            children


itemLink : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
itemLink attributes children =
    Item <|
        Html.li
            [ class "nav-item" ]
            [ Html.a
                ([ class "nav-link" ] ++ attributes)
                children
            ]


customItem : Html.Html msg -> CustomItem msg
customItem elem =
    CustomItem elem





toggleHandler : State -> Config msg -> Html.Attribute msg
toggleHandler ((State { height }) as state) { withAnimation, toMsg } =
    let
        updState h =
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
                        item
                    NavDropdown dropdown ->
                        renderDropdown state config dropdown
            )
            navItems
        )


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
    Html.li
        [ classList
                [ ( "nav-item", True )
                , ( "dropdown", True )
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



