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
        , DropdownToggleConfig
        , DropdownOption(..)
        )

import Bootstrap.Button as Button
import Bootstrap.Internal.Button as ButtonInternal
import Html
import Html.Attributes exposing (class, classList, type_, id, href)
import Html.Events exposing (onClick, on)
import Mouse


type State
    = State
        { open : Bool
        , ignoreSub : Bool
        }


type alias DropdownToggleConfig msg =
    { options : List (Button.ButtonOption msg)
    , attributes : List (Html.Attribute msg)
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
    State
        { open = False
        , ignoreSub = False
        }


dropdown :
    { toggleMsg : State -> msg
    , toggleButton : DropdownToggle msg
    , options : List DropdownOption
    , items : List (DropdownItem msg)
    }
    -> State
    -> Html.Html msg
dropdown { toggleMsg, toggleButton, items, options } ((State { open }) as state) =
    let
        (DropdownToggle buttonFn) =
            toggleButton
    in
        Html.div
            [ classList
                [ ( "btn-group", True )
                , ( "open", open )
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


toggle : DropdownToggleConfig msg -> DropdownToggle msg
toggle config =
    DropdownToggle <|
        togglePrivate config


togglePrivate :
    DropdownToggleConfig msg
    -> (State -> msg)
    -> State
    -> Html.Html msg
togglePrivate { options, attributes, children } toggleMsg state =
    Html.button
        (ButtonInternal.buttonAttributes options
            ++ [ class "dropdown-toggle"
               , type_ "button"
               , onClick <| toggleOpen toggleMsg state
               ]
            ++ attributes
        )
        children


splitDropdown :
    { toggleMsg : State -> msg
    , toggleButton : SplitDropdownToggle msg
    , options : List DropdownOption
    , items : List (DropdownItem msg)
    }
    -> State
    -> Html.Html msg
splitDropdown { toggleMsg, toggleButton, items, options } ((State { open }) as state) =
    let
        (SplitDropdownToggle buttonsFn) =
            toggleButton
    in
        Html.div
            [ classList
                [ ( "btn-group", True )
                , ( "open", open )
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


splitToggle : DropdownToggleConfig msg -> SplitDropdownToggle msg
splitToggle config =
    SplitDropdownToggle <|
        splitToggleButtonPrivate config


splitToggleButtonPrivate :
    DropdownToggleConfig msg
    -> (State -> msg)
    -> State
    -> List (Html.Html msg)
splitToggleButtonPrivate { options, attributes, children } toggleMsg state =
    [ Html.button
        (ButtonInternal.buttonAttributes options ++ attributes)
        children
    , Html.button
        (ButtonInternal.buttonAttributes options
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
    { toggleMsg : State -> msg
    , toggleButton : NavDropdownToggle msg
    , items : List (DropdownItem msg)
    }
    -> State
    -> Html.Html msg
navDropdown { toggleMsg, toggleButton, items } ((State { open }) as state) =
    let
        (NavDropdownToggle buttonFn) =
            toggleButton
    in
        Html.li
            [ classList
                [ ( "nav-item", True )
                , ( "dropdown", True )
                , ( "open", open )
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
         , onClick <| toggleOpen toggleMsg state
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
subscriptions (State state) msg =
    if state.open || not state.ignoreSub then
        Mouse.clicks
            (\_ ->
                msg <|
                    State
                        { state
                            | open = state.ignoreSub
                            , ignoreSub = False
                        }
            )
    else
        Sub.none


toggleOpen : (State -> msg) -> State -> msg
toggleOpen toMsg (State state) =
    toMsg <| State { state | open = not state.open, ignoreSub = True }
