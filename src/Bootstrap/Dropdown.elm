module Bootstrap.Dropdown
    exposing
        ( dropdown
        , splitDropdown
        , initialState
        , toggle
        , splitToggle
        , dropUp
        , dropRight
        , dropLeft
        , alignMenuRight
        , anchorItem
        , buttonItem
        , divider
        , header
        , attrs
        , menuAttrs
        , subscriptions
        , State
        , DropdownItem
        , DropdownToggle
        , SplitDropdownToggle
        , SplitToggleConfig
        , DropdownOption
        )

{-| Dropdowns are toggleable, contextual overlays for displaying lists of links and more. They’re toggled by clicking, not by hovering; this is an intentional design decision.

**Wiring needed**

    import Bootstrap.Dropdown as Dropdown
    import Bootstrap.Button as Button


    -- .. etc
    -- Model

    type alias Model =
        { myDrop1State : Dropdown.State
        , myDrop1State : Dropdown.State
        }


    -- Msg

    type Msg
        = MyDrop1Msg Dropdown.State
        | MyDrop2Msg Dropdown.State


    -- init

    init : ( Model, Cmd Msg )
    init =
        ( { myDrop1State = Dropdown.initialState
          , myDrop2State = Dropdown.initialState
          }
        , Cmd.none
        )


    -- update

    update : Msg -> Model -> ( Model, Cmd msg )
    update msg model =
        case msg of
            MyDrop1Msg state ->
                ( { model | myDrop1State = state }
                , Cmd.none
                )

            MyDrop2Msg state ->
                ( { model | myDrop2State = state }
                , Cmd.none
                )


    -- ... and cases for the drop down actions

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Sub.batch
            [ Dropdown.subscriptions model.myDrop1State MyDrop1Msg
            , Dropdown.subscriptions model.myDrop2State MyDrop2Msg
            ]

    view : Model -> Html Msg
    view model =
        div []
            [ Dropdown.dropdown
                model.myDrop1State
                { options = [ Dropdown.alignMenuRight ]
                , toggleMsg = MyDrop1Msg
                , toggleButton =
                    Dropdown.toggle [ Button.roleWarning ] [ text "MyDropdown1" ]
                , items =
                    [ Dropdown.buttonItem [ onClick Item1Msg ] [ text "Item 1" ]
                    , Dropdown.buttonItem [ onClick Item2Msg ] [ text "Item 2" ]
                    , Dropdown.divider
                    , Dropdown.header [ text "Silly items" ]
                    , Dropdown.buttonItem [ class "disabled" ] [ text "DoNothing1" ]
                    , Dropdown.buttonItem [] [ text "DoNothing2" ]
                    ]
                }

            -- etc
            ]

Bootstrap dropdowns are made interactive in Elm by using state and subscription, so there is a little
bit of wiring involved when using them in your Elm Application.


# Dropdown

@docs dropdown, toggle, DropdownToggle


## Options

@docs dropUp, dropLeft, dropRight, alignMenuRight, attrs, menuAttrs, DropdownOption


# Dropdown items

@docs anchorItem, buttonItem, divider, header, DropdownItem


# Split dropdown

@docs splitDropdown, splitToggle, SplitToggleConfig, SplitDropdownToggle


# Required wiring

@docs subscriptions, initialState, State

-}

import Bootstrap.Button as Button
import Bootstrap.Internal.Button as ButtonInternal
import Html
import Html.Attributes exposing (class, classList, type_, id, href, style)
import Html.Events exposing (onClick, on, onWithOptions)
import Mouse
import AnimationFrame
import Json.Decode as Json
import DOM


{-| Opaque type representing the view state of a Dropdown. You need to store this state
in your model and it's initialized by [`initialState`](#initialState)
-}
type State
    = State StateRec

type alias StateRec =
    { status : DropdownStatus
    , toggleSize : DOM.Rectangle
    , menuSize : DOM.Rectangle
    }


type DropdownStatus
    = Open
    | ListenClicks
    | Closed


{-| The configuration options available for the toggle in a Split Dropdown.

  - `options` List of Button options for the main button
  - `togglerOptions` List of Button options for the menu toogle
  - `children` List of child elements for the main button

**Important**
You mustn't define an onClick handler as an option in `options`. That will mess up the toggle feature !

-}
type alias SplitToggleConfig msg =
    { options : List (Button.Option msg)
    , togglerOptions : List (Button.Option msg)
    , children : List (Html.Html msg)
    }


{-| Opaque type representing configuration options for a Dropdown
-}
type DropdownOption msg
    = Dropup
    | AlignMenuRight
    | DropToDir DropDirection
    | MenuAttrs (List (Html.Attribute msg))
    | Attrs (List (Html.Attribute msg))


type DropDirection
    = Dropleft
    | Dropright


type alias Options msg =
    { isDropUp : Bool
    , hasMenuRight : Bool
    , dropDirection : Maybe DropDirection
    , attributes : List (Html.Attribute msg)
    , menuAttrs : List (Html.Attribute msg)
    }


{-| Opaque type representing an item in the menu of a Dropdown
-}
type DropdownItem msg
    = DropdownItem (Html.Html msg)


{-| Opaque type representing a toggle button item for a Dropdown
-}
type DropdownToggle msg
    = DropdownToggle ((State -> msg) -> State -> Html.Html msg)


{-| Opaque type representing a split toggle button item for a Split Dropdown
-}
type SplitDropdownToggle msg
    = SplitDropdownToggle ((State -> msg) -> State -> List (Html.Html msg))


{-| Initializes the view state for a dropdown. Typically you would call this from
your main init function
-}
initialState : State
initialState =
    State
        { status = Closed
        , toggleSize = DOM.Rectangle 0 0 0 0
        , menuSize = DOM.Rectangle 0 0 0 0
        }


{-| Option to show the dropdown menu above the dropdown rather than the default which is below
-}
dropUp : DropdownOption msg
dropUp =
    Dropup


{-| Option to align the dropdown menu to the right of the dropdown button.

**NOTE!** Dropdowns are positioned only with CSS and may need some additional styles for exact alignment.

-}
alignMenuRight : DropdownOption msg
alignMenuRight =
    AlignMenuRight

{-| Show menu to the right of the button.
-}
dropRight : DropdownOption msg
dropRight =
    DropToDir <| Dropright

{-| Show menu to the left of the button.
-}
dropLeft : DropdownOption msg
dropLeft =
    DropToDir <| Dropleft


{-| Use this function when you need the customize the Dropdown root div with additional Html.Attribute (s).
-}
attrs : List (Html.Attribute msg) -> DropdownOption msg
attrs attrs =
    Attrs attrs


{-| Use this function when you need the customize the Dropdown menu with additional Html.Attribute (s).
-}
menuAttrs : List (Html.Attribute msg) -> DropdownOption msg
menuAttrs attrs =
    MenuAttrs attrs


{-| Creates a Dropdown button. You can think of this as the view function.
It takes the current (view) state and a configuration record as parameters.

    Dropdown.dropdown
        model.myDropdownState
        { toggleMsg = MyDropdownMsg
        , toggleButton = Dropdown.toggle [ Button.primary ] [ text "MyDropdown" ]
        , options = [ Dropdown.alignMenuRight ]
        , items =
            [ Dropdown.buttonItem [ onClick Item1Msg ] [ text "Item1" ]
            , Dropdown.buttonItem [ onClick Item2Msg ] [ text "Item1" ]
            ]
        }

  - `state` The current view state of the dropdown
  - Configuration
      - `toggleMsg` A `msg` function that takes a state and returns a msg
      - `toggleButton` The actual button for the dropdown
      - `options` General display [`options`](#options) for Dropdown widget
      - `items` List of menu items for the dropdown

-}
dropdown :
    State
    ->
        { toggleMsg : State -> msg
        , toggleButton : DropdownToggle msg
        , options : List (DropdownOption msg)
        , items : List (DropdownItem msg)
        }
    -> Html.Html msg
dropdown ((State {status}) as state) { toggleMsg, toggleButton, items, options } =
    let
        (DropdownToggle buttonFn) =
            toggleButton

        config =
            toConfig options
    in
        Html.div
            (dropdownAttributes status config)
            [ buttonFn toggleMsg state
            , dropdownMenu state config items
            ]


dropdownAttributes : DropdownStatus -> Options msg -> List (Html.Attribute msg)
dropdownAttributes status config =
    [ classList
        [ ( "btn-group", True )
        , ( "show", status /= Closed )
        , ( "dropup", config.isDropUp )
        ]
    ]
        ++ dropDir config.dropDirection
        ++ config.attributes


dropDir : Maybe DropDirection -> List (Html.Attribute msg)
dropDir maybeDir =
    let
        toAttrs dir =
            [ class <|
                "drop"
                    ++ case dir of
                        Dropleft ->
                            "left"

                        Dropright ->
                            "right"
            ]
    in
        Maybe.map toAttrs maybeDir
            |> Maybe.withDefault []



dropdownMenu :
    State
    -> Options msg
    -> List (DropdownItem msg)
    -> Html.Html msg
dropdownMenu (State {status, menuSize} as state) config items =
    let
        wrapperStyle =
            if status == Closed then
                [ ( "height", "0" )
                , ( "overflow", "hidden" )
                , ( "position", "relative" )
                ]
            else
                [ ( "position", "relative" ) ]
    in
        Html.div
            [ style wrapperStyle ]
            [ Html.div
                ([ classList
                    [ ( "dropdown-menu", True )
                    , ( "dropdown-menu-right", config.hasMenuRight )
                    , ( "show", True )
                    ]
                 , menuStyle state config
                 ]
                    ++ config.menuAttrs
                )
                (List.map (\(DropdownItem x) -> x) items)
            ]


menuStyle : State -> Options msg -> Html.Attribute msg
menuStyle (State {status, toggleSize, menuSize}) config =
    let
        default
            = [ ( "top", "0" ), ( "left", "0" ) ]
        px n =
            toString n ++ "px"

        translate x y z =
            "translate3d("
                ++ px x ++ ","
                ++ px y ++ ","
                ++ px z ++ ")"
    in
        style <|
         case (config.isDropUp, config.dropDirection) of
            (True, _) ->
                default ++ [("transform", translate -toggleSize.width -menuSize.height 0)]

            (_, Just Dropright) ->
                default

            (_, Just Dropleft) ->
                default ++ [("transform", translate (-toggleSize.width - menuSize.width) 0 0)]

            _ ->
                default ++ [("transform", translate -toggleSize.width toggleSize.height 0)]



{-| Function to construct a toggle for a [`dropdown`](#dropdown)

  - buttonOptions List of button options for styling the button
  - children List of child elements

-}
toggle :
    List (Button.Option msg)
    -> List (Html.Html msg)
    -> DropdownToggle msg
toggle buttonOptions children =
    DropdownToggle <|
        togglePrivate buttonOptions children


togglePrivate :
    List (Button.Option msg)
    -> List (Html.Html msg)
    -> (State -> msg)
    -> State
    -> Html.Html msg
togglePrivate buttonOptions children toggleMsg state =
    Html.button
        (ButtonInternal.buttonAttributes buttonOptions
            ++ [ class "dropdown-toggle"
               , type_ "button"
               , on "click" (clickHandler toggleMsg state)
               ]
        )
        children


{-| Creates a split dropdown. Contains a normal button and a toggle button that are placed next to each other.

  - `state` The current view state of the split dropdown
  - Configuration
      - `toggleMsg` A `msg` function that takes a state and returns a msg
      - `toggleButton` The actual split button for the dropdown
      - `options` General display [`options`](#options) for Split dropdown widget
      - `items` List of menu items for the dropdown

-}
splitDropdown :
    State
    ->
        { toggleMsg : State -> msg
        , toggleButton : SplitDropdownToggle msg
        , options : List (DropdownOption msg)
        , items : List (DropdownItem msg)
        }
    -> Html.Html msg
splitDropdown ((State {status}) as state) { toggleMsg, toggleButton, items, options } =
    let
        (SplitDropdownToggle buttonsFn) =
            toggleButton

        config =
            toConfig options
    in
        Html.div
            (dropdownAttributes status config)
            (buttonsFn toggleMsg state
                ++ [ dropdownMenu state config items ]
            )


{-| Function to construct a split button toggle for a [`splitDropdown`](#splitDropdown)

    Dropdown.splitToggle
        { options =
            [ Button.primary
            , Button.small
            , Button.attr <| onClick SplitMainMsg
            ]
        -- It makes sense to keep the styling related options in sync for the two buttons !
        , togglerOptions =
            [ Button.primary
            , Button.small
            ]
        , [ text "My Dropdown"]
        }

  - `config` Configuration for the split toggle as described in [`SplitToggleConfig`](#SplitToggleConfig)

-}
splitToggle : SplitToggleConfig msg -> SplitDropdownToggle msg
splitToggle config =
    SplitDropdownToggle <|
        splitToggleButtonPrivate config


splitToggleButtonPrivate :
    SplitToggleConfig msg
    -> (State -> msg)
    -> State
    -> List (Html.Html msg)
splitToggleButtonPrivate { options, togglerOptions, children } toggleMsg state =
    [ Html.button
        (ButtonInternal.buttonAttributes options)
        children
    , Html.button
        (ButtonInternal.buttonAttributes togglerOptions
            ++ [ class "dropdown-toggle"
               , class "dropdown-toggle-split"
               , type_ "button"
               , on "click" (clickHandler toggleMsg state)
               ]
        )
        []
    ]


toConfig : List (DropdownOption msg) -> Options msg
toConfig options =
    List.foldl applyModifier defaultOptions options


defaultOptions : Options msg
defaultOptions =
    { hasMenuRight = False
    , isDropUp = False
    , attributes = []
    , dropDirection = Nothing
    , menuAttrs = []
    }


applyModifier : DropdownOption msg -> Options msg -> Options msg
applyModifier option options =
    case option of
        AlignMenuRight ->
            { options | hasMenuRight = True }

        Dropup ->
            { options | isDropUp = True }

        Attrs attrs ->
            { options | attributes = attrs }

        DropToDir dir ->
            { options | dropDirection = Just dir }

        MenuAttrs attrs ->
            { options | menuAttrs = attrs }


{-| Creates an `a` element appropriate for use in dropdowns

  - `attributes` List of attributes
  - `children` List of child elements

-}
anchorItem : List (Html.Attribute msg) -> List (Html.Html msg) -> DropdownItem msg
anchorItem attributes children =
    Html.a ([ class "dropdown-item" ] ++ attributes) children
        |> DropdownItem


{-| Creates a `button` element appropriate for use in dropdowns

  - `attributes` List of attributes
  - `children` List of child elements

-}
buttonItem : List (Html.Attribute msg) -> List (Html.Html msg) -> DropdownItem msg
buttonItem attributes children =
    Html.button ([ type_ "button", class "dropdown-item" ] ++ attributes) children
        |> DropdownItem


{-| Creates divider element appropriate for use in dropdowns.
Handy when you want to visually separate groups of menu items in a dropdown menu

  - `attributes` List of attributes
  - `children` List of child elements

-}
divider : DropdownItem msg
divider =
    Html.div [ class "dropdown-divider" ] []
        |> DropdownItem


{-| Creates an header element appropriate for use in dropdowns.
Handy when you want to provide a heading for a group of menu items in a dropdown menu

  - `attributes` List of attributes
  - `children` List of child elements

-}
header : List (Html.Html msg) -> DropdownItem msg
header children =
    Html.h6
        [ class "dropdown-header" ]
        children
        |> DropdownItem


{-| The dropdowns makes use of subscriptions to ensure that opened dropdowns are
automatically closed when you click outside them.

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Sub.batch
            [ Dropdown.subscriptions model.myDrop1State MyDrop1Msg
            , Dropdown.subscriptions model.myDrop2State MyDrop2Msg

            -- etc one for each dropdown (dropdown, navDropdown or splitDropdown)
            ]

-}
subscriptions : State -> (State -> msg) -> Sub msg
subscriptions (State {status} as state) toMsg =
    case status of
        Open ->
            AnimationFrame.times
                (\_ -> toMsg <| updateStatus ListenClicks state)

        ListenClicks ->
            Mouse.clicks
                (\_ -> toMsg <| updateStatus Closed state)

        Closed ->
            Sub.none



clickHandler : (State -> msg) -> State -> Json.Decoder msg
clickHandler toMsg (State {status} as state) =
    sizeDecoder
        |> Json.andThen
            (\(b,m) ->
                Json.succeed <|
                    toMsg <|
                        State
                            { status = nextStatus status
                            , toggleSize = b
                            , menuSize = m
                            }
            )


sizeDecoder : Json.Decoder (DOM.Rectangle, DOM.Rectangle)
sizeDecoder =
    Json.map2 (,)
      (DOM.target <| DOM.boundingClientRect)
      (DOM.target <|
        DOM.nextSibling <|
            DOM.childNode 0 <|
                DOM.boundingClientRect)


toggleOpen : (State -> msg) -> State -> msg
toggleOpen toMsg ((State { status }) as state) =
    toMsg <|
        updateStatus
            (nextStatus status)
            state

nextStatus : DropdownStatus -> DropdownStatus
nextStatus status =
    case status of
        Open ->
            Closed

        ListenClicks ->
            Closed

        Closed ->
            Open


updateStatus : DropdownStatus -> State -> State
updateStatus status (State stateRec) =
    State {stateRec | status = status }
