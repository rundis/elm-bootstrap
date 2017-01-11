module Bootstrap.Dropdown
    exposing
        ( dropdown
        , splitDropdown
        , navDropdown
        , initialState
        , toggle
        , splitToggle
        , navToggle
        , anchorItem
        , buttonItem
        , divider
        , header
        , subscriptions
        , State
        , DropdownItem
        , DropdownToggle
        , SplitDropdownToggle
        , NavDropdownToggle
        , SplitToggleConfig
        , DropdownOption(..)
        )

{-|
-}

import Bootstrap.Button as Button
import Bootstrap.Internal.Button as ButtonInternal
import Html
import Html.Attributes exposing (class, classList, type_, id, href)
import Html.Events exposing (onClick, on, onWithOptions)
import Mouse
import AnimationFrame
import Json.Decode as Json


type State
    = State DropDownStatus


type DropDownStatus
    = Open
    | ListenClicks
    | Closed


type alias SplitToggleConfig msg =
    { options : List (Button.ButtonOption msg)
    , togglerOptions : List (Button.ButtonOption msg)
    , children : List (Html.Html msg)
    }


type DropdownOption
    = Dropup
    | AlignMenuRight


type DropdownItem msg
    = DropdownItem (Html.Html msg)


type DropdownToggle msg
    = DropdownToggle ((State -> msg) -> State -> Html.Html msg)


type SplitDropdownToggle msg
    = SplitDropdownToggle ((State -> msg) -> State -> List (Html.Html msg))


type NavDropdownToggle msg
    = NavDropdownToggle ((State -> msg) -> State -> Html.Html msg)


initialState : State
initialState =
    State Closed


dropdown :
    State
    -> { toggleMsg : State -> msg
       , toggleButton : DropdownToggle msg
       , options : List DropdownOption
       , items : List (DropdownItem msg)
       }
    -> Html.Html msg
dropdown ((State status) as state) { toggleMsg, toggleButton, items, options } =
    let
        (DropdownToggle buttonFn) =
            toggleButton
    in
        Html.div
            [ classList
                [ ( "btn-group", True )
                , ( "show", status /= Closed )
                , ( "dropup", isDropUp options )
                ]
            ]
            [ buttonFn toggleMsg state
            , Html.div
                [ classList
                    [ ( "dropdown-menu", True )
                    , ( "dropdown-menu-right", hasMenuRight options )
                    ]
                ]
                (List.map (\(DropdownItem x) -> x) items)
            ]


toggle :
    List (Button.ButtonOption msg)
    -> List (Html.Html msg)
    -> DropdownToggle msg
toggle buttonOptions children =
    DropdownToggle <|
        togglePrivate buttonOptions children


togglePrivate :
    List (Button.ButtonOption msg)
    -> List (Html.Html msg)
    -> (State -> msg)
    -> State
    -> Html.Html msg
togglePrivate buttonOptions children toggleMsg state =
    Html.button
        (ButtonInternal.buttonAttributes buttonOptions
            ++ [ class "dropdown-toggle"
               , type_ "button"
               , onClick <| toggleOpen toggleMsg state
               ]
        )
        children


splitDropdown :
    State
    -> { toggleMsg : State -> msg
       , toggleButton : SplitDropdownToggle msg
       , options : List DropdownOption
       , items : List (DropdownItem msg)
       }
    -> Html.Html msg
splitDropdown ((State status) as state) { toggleMsg, toggleButton, items, options } =
    let
        (SplitDropdownToggle buttonsFn) =
            toggleButton
    in
        Html.div
            [ classList
                [ ( "btn-group", True )
                , ( "show", status /= Closed )
                , ( "dropup", isDropUp options )
                ]
            ]
            (buttonsFn toggleMsg state
                ++ [ Html.div
                        [ classList
                            [ ( "dropdown-menu", True )
                            , ( "dropdown-menu-right", hasMenuRight options )
                            ]
                        ]
                        (List.map (\(DropdownItem x) -> x) items)
                   ]
            )


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
               , onClick <| toggleOpen toggleMsg state
               ]
        )
        []
    ]


hasMenuRight : List DropdownOption -> Bool
hasMenuRight options =
    List.any (\opt -> opt == AlignMenuRight) options


isDropUp : List DropdownOption -> Bool
isDropUp options =
    List.any (\opt -> opt == Dropup) options


navDropdown :
    State
    -> { toggleMsg : State -> msg
       , toggleButton : NavDropdownToggle msg
       , items : List (DropdownItem msg)
       }
    -> Html.Html msg
navDropdown ((State status) as state) { toggleMsg, toggleButton, items } =
    let
        (NavDropdownToggle buttonFn) =
            toggleButton
    in
        Html.li
            [ classList
                [ ( "nav-item", True )
                , ( "dropdown", True )
                , ( "show", status /= Closed )
                ]
            ]
            [ buttonFn toggleMsg state
            , Html.div
                [ class "dropdown-menu" ]
                (List.map (\(DropdownItem x) -> x) items)
            ]


navToggle :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> NavDropdownToggle msg
navToggle attributes children =
    NavDropdownToggle <|
        navTogglePrivate attributes children


navTogglePrivate :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> (State -> msg)
    -> State
    -> Html.Html msg
navTogglePrivate attributes children toggleMsg state =
    Html.a
        ([ class "nav-link dropdown-toggle"
         , href "#"
         , onWithOptions
             "click"
             { stopPropagation = False
             , preventDefault = True
             }
             <| Json.succeed (toggleOpen toggleMsg state)
         --, onClick <| toggleOpen toggleMsg state
         ]
            ++ attributes
        )
        children


anchorItem : List (Html.Attribute msg) -> List (Html.Html msg) -> DropdownItem msg
anchorItem attributes children =
    Html.a ([ class "dropdown-item" ] ++ attributes) children
        |> DropdownItem


buttonItem : List (Html.Attribute msg) -> List (Html.Html msg) -> DropdownItem msg
buttonItem attributes children =
    Html.button ([ type_ "button", class "dropdown-item" ] ++ attributes) children
        |> DropdownItem


divider : DropdownItem msg
divider =
    Html.div [ class "dropdown-divider" ] []
        |> DropdownItem


header : List (Html.Html msg) -> DropdownItem msg
header children =
    Html.h6
        [ class "dropdown-header" ]
        children
        |> DropdownItem



subscriptions : State -> (State -> msg) -> Sub msg
subscriptions (State status) toMsg =
    case status of
        Open ->
            AnimationFrame.times
                (\_ -> toMsg <| State ListenClicks)

        ListenClicks ->
            Mouse.clicks
                (\_ -> toMsg <| State Closed)

        Closed ->
            Sub.none


toggleOpen : (State -> msg) -> State -> msg
toggleOpen toMsg (State status) =
    toMsg <|
        State <|
            case status of
                Open ->
                    Closed

                ListenClicks ->
                    Closed

                Closed ->
                    Open
