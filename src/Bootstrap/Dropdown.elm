module Bootstrap.Dropdown
    exposing
        ( dropdown
        , splitDropdown
        , initialState
        , config
        , splitConfig
        , dropdownItem
        , subscriptions
        , State
        , Config
        , DropdownItem
        )

import Bootstrap.Button as Button
import Html
import Html.Attributes exposing (class, type_, id, href)
import Html.Events exposing (onClick, on)
import Mouse


type alias State =
    { open : Bool
    , ignoreSub : Bool
    , id : String
    }


type Config msg
    = Config
        { toMsg : State -> msg
        , buttonStyles : List Button.ButtonStyles
        , buttonAttributes : List (Html.Attribute msg)
        , buttonChildren : List (Html.Html msg)
        , items : List (DropdownItem msg)
        }


type DropdownItem msg
    = DropdownItem (Html.Html msg)


initialState : String -> State
initialState id =
    State False False id


config :
    { toMsg : State -> msg
    , buttonStyles : List Button.ButtonStyles
    , buttonChildren : List (Html.Html msg)
    , items : List (DropdownItem msg)
    }
    -> Config msg
config { toMsg, buttonStyles, buttonChildren, items } =
    Config
        { toMsg = toMsg
        , buttonStyles = buttonStyles
        , buttonChildren = buttonChildren
        , buttonAttributes = []
        , items = items
        }


splitConfig :
    { toMsg : State -> msg
    , buttonStyles : List Button.ButtonStyles
    , buttonAttributes : List (Html.Attribute msg)
    , buttonChildren : List (Html.Html msg)
    , items : List (DropdownItem msg)
    }
    -> Config msg
splitConfig { toMsg, buttonStyles, buttonAttributes, buttonChildren, items } =
    Config
        { toMsg = toMsg
        , buttonStyles = buttonStyles
        , buttonChildren = buttonChildren
        , buttonAttributes = buttonAttributes
        , items = items
        }


dropdown :
    Config msg
    -> State
    -> Html.Html msg
dropdown (Config { toMsg, items, buttonStyles, buttonChildren }) state =
    Html.div
        [ class <|
            "dropdown"
                ++ (if state.open then
                        " open"
                    else
                        ""
                   )
        ]
        [ Html.button
            [ class <| Button.buttonStylesClass buttonStyles ++ " dropdown-toggle"
            , type_ "button"
            , id "dropdownMenuButton"
            , onClick <| toggleOpen toMsg state
            ]
            buttonChildren
        , Html.div
            [ class "dropdown-menu" ]
            (List.map (\(DropdownItem x) -> x) items)
        ]


splitDropdown :
    Config msg
    -> State
    -> Html.Html msg
splitDropdown (Config { toMsg, items, buttonStyles, buttonAttributes, buttonChildren }) state =
    Html.div
        [ class <|
            "dropdown"
                ++ (if state.open then
                        " open"
                    else
                        ""
                   )
        ]
        [ Html.button
            ([ class <| Button.buttonStylesClass buttonStyles ] ++ buttonAttributes)
            buttonChildren
        , Html.button
            [ class <| Button.buttonStylesClass buttonStyles ++ " dropdown-toggle dropdown-toggle-split"
            , type_ "button"
            , id "dropdownMenuButton"
            , onClick <| toggleOpen toMsg state
            ]
            []
        , Html.div
            [ class "dropdown-menu" ]
            (List.map (\(DropdownItem x) -> x) items)
        ]


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
