module Bootstrap.Dropdown
    exposing
        ( dropdown
        , splitDropdown
        , navDropdown
        , initialState
        , dropdownConfig
        , splitDropdownConfig
        , navDropdownConfig
        , dropdownToggle
        , splitDropdownToggle
        , navDropdownToggle
        , dropdownItem
        , subscriptions
        , State
        , DropdownConfig
        , SplitDropdownConfig
        , NavDropdownConfig
        , DropdownItem
        , DropdownToggle
        , SplitDropdownToggle
        , NavDropdownToggle
        )

import Bootstrap.Button as Button
import Html
import Html.Attributes exposing (class, classList, type_, id, href)
import Html.Events exposing (onClick, on)
import Mouse


type alias State =
    { open : Bool
    , ignoreSub : Bool
    , id : String
    }


type DropdownConfig msg
    = DropdownConfig
        { toggleMsg : State -> msg
        , toggleButton : DropdownToggle msg
        , items : List (DropdownItem msg)
        }


type SplitDropdownConfig msg
    = SplitDropdownConfig
        { toggleMsg : State -> msg
        , toggleButton : SplitDropdownToggle msg
        , items : List (DropdownItem msg)
        }

type NavDropdownConfig msg
    = NavDropdownConfig
        { toggleMsg : State -> msg
        , toggleButton : NavDropdownToggle msg
        , items : List (DropdownItem msg)
        }



type DropdownItem msg
    = DropdownItem (Html.Html msg)


type DropdownToggle msg
    = DropdownToggle ((State -> msg) -> State -> Html.Html msg)


type SplitDropdownToggle msg
    = SplitDropdownToggle ((State -> msg) -> State -> List (Html.Html msg))


type NavDropdownToggle msg
    = NavDropdownToggle ((State -> msg) -> State -> Html.Html msg)



initialState : String -> State
initialState id =
    State False False id


dropdownConfig :
    { toggleMsg : State -> msg
    , toggleButton : DropdownToggle msg
    , items : List (DropdownItem msg)
    }
    -> DropdownConfig msg
dropdownConfig { toggleMsg, toggleButton, items } =
    DropdownConfig
        { toggleMsg = toggleMsg
        , toggleButton = toggleButton
        , items = items
        }


splitDropdownConfig :
    { toggleMsg : State -> msg
    , toggleButton : SplitDropdownToggle msg
    , items : List (DropdownItem msg)
    }
    -> SplitDropdownConfig msg
splitDropdownConfig { toggleMsg, toggleButton, items } =
    SplitDropdownConfig
        { toggleMsg = toggleMsg
        , toggleButton = toggleButton
        , items = items
        }


navDropdownConfig :
    { toggleMsg : State -> msg
    , toggleButton : NavDropdownToggle msg
    , items : List (DropdownItem msg)
    }
    -> NavDropdownConfig msg
navDropdownConfig { toggleMsg, toggleButton, items } =
    NavDropdownConfig
        { toggleMsg = toggleMsg
        , toggleButton = toggleButton
        , items = items
        }




dropdown :
    DropdownConfig msg
    -> State
    -> Html.Html msg
dropdown (DropdownConfig { toggleMsg, toggleButton, items }) state =
    let
        (DropdownToggle buttonFn) =
            toggleButton
    in
        Html.div
            [ classList
                [ ( "dropdown", True )
                , ( "open", state.open )
                ]
            ]
            [ buttonFn toggleMsg state
            , Html.div
                [ class "dropdown-menu" ]
                (List.map (\(DropdownItem x) -> x) items)
            ]

dropdownToggle :
    List Button.ButtonStyles
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> DropdownToggle msg
dropdownToggle styles attributes children =
    DropdownToggle <|
        dropdownTogglePrivate styles attributes children


dropdownTogglePrivate :
    List Button.ButtonStyles
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> (State -> msg)
    -> State
    -> Html.Html msg
dropdownTogglePrivate styles attributes children toggleMsg state =
    Html.button
        ([ class <| Button.buttonStylesClass styles ++ " dropdown-toggle"
         , type_ "button"
         , onClick <| toggleOpen toggleMsg state
         ]
            ++ attributes
        )
        children


splitDropdown :
    SplitDropdownConfig msg
    -> State
    -> Html.Html msg
splitDropdown (SplitDropdownConfig { toggleMsg, toggleButton, items }) state =
    let
        (SplitDropdownToggle buttonsFn) =
            toggleButton
    in
        Html.div
            [ class <|
                "dropdown"
                    ++ (if state.open then
                            " open"
                        else
                            ""
                       )
            ]
            (buttonsFn toggleMsg state
                ++ [ Html.div
                        [ class "dropdown-menu" ]
                        (List.map (\(DropdownItem x) -> x) items)
                   ]
            )

splitDropdownToggle :
    List Button.ButtonStyles
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> SplitDropdownToggle msg
splitDropdownToggle styles attributes children =
    SplitDropdownToggle <|
        splitDropdownToggleButtonPrivate styles attributes children


splitDropdownToggleButtonPrivate :
    List Button.ButtonStyles
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> (State -> msg)
    -> State
    -> List (Html.Html msg)
splitDropdownToggleButtonPrivate styles attributes children toggleMsg state =
    [ Html.button
        ([ class <| Button.buttonStylesClass styles ] ++ attributes)
        children
    , Html.button
        [ class <| Button.buttonStylesClass styles ++ " dropdown-toggle dropdown-toggle-split"
        , type_ "button"
        , onClick <| toggleOpen toggleMsg state
        ]
        []
    ]



navDropdown :
    NavDropdownConfig msg
    -> State
    -> Html.Html msg
navDropdown (NavDropdownConfig { toggleMsg, toggleButton, items }) state =
    let
        (NavDropdownToggle buttonFn) =
            toggleButton
    in
        Html.li
            [ classList
                [ ( "nav-item", True )
                , ( "dropdown", True )
                , ( "open", state.open )
                ]
            ]
            [ buttonFn toggleMsg state
            , Html.div
                [ class "dropdown-menu" ]
                (List.map (\(DropdownItem x) -> x) items)
            ]


navDropdownToggle :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> NavDropdownToggle msg
navDropdownToggle attributes children =
    NavDropdownToggle <|
        navDropdownTogglePrivate attributes children


navDropdownTogglePrivate :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> (State -> msg)
    -> State
    -> Html.Html msg
navDropdownTogglePrivate attributes children toggleMsg state =
    Html.a
        ([ class "nav-link dropdown-toggle"
         , href "#"
         , onClick <| toggleOpen toggleMsg state
         ]
            ++ attributes
        )
        children




dropdownItem : List (Html.Attribute msg) -> List (Html.Html msg) -> DropdownItem msg
dropdownItem attributes children =
    Html.a ([ class "dropdown-item" ] ++ attributes) children
        |> DropdownItem


subscriptions : State -> (State -> msg) -> Sub msg
subscriptions state msg =
    if state.open || not state.ignoreSub then
        Mouse.clicks
            (\_ ->
                msg
                    { state
                        | open = state.ignoreSub
                        , ignoreSub = False
                    }
            )
    else
        Sub.none


toggleOpen : (State -> msg) -> State -> msg
toggleOpen toMsg state =
    toMsg { state | open = not state.open, ignoreSub = True }
