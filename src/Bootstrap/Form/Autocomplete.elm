module Bootstrap.Form.Autocomplete exposing
    ( view
    , initialState
    , State
    , Config
    )


import Html exposing (..)
import Html.Attributes as Attributes exposing (style, class, classList, type_)
import Html.Keyed as Keyed
import Html.Events as Events
import Json.Decode as Json
import Bootstrap.Form.Input as Input




type alias MenuItem msg =
    { attributes : List (Html.Attribute msg)
    , children : List (Html msg)
    }

type alias Config data msg =
    { toMsg : State -> msg
    , idFn : data -> String
    , itemFn : data -> MenuItem msg
    }



type State =
    State
        { showMenu : Bool
        , activeId : Maybe String
        }


initialState : State
initialState =
    State
        { showMenu = False
        , activeId = Nothing
        }


view : State -> Config data msg -> List data -> Html msg
view (State state as viewState) ({toMsg} as config) items =
    div
        [ style
            [ ("position", "relative") ]
        ]
        ([ div
            [ class "input-group" ]
            [ Input.text
                [ Input.attrs
                    [ style
                        [("border-bottom-left-radius", "0")]
                    , Events.on "focus" <|
                        Json.succeed <| toMsg <| State {state | showMenu = True}

                    , Events.on "blur" <|
                        Json.succeed <| toMsg <| State {state | showMenu = False}

                    ]
                ]
            , span
                [ class "input-group-addon"]
                [ Html.text "x" ]
            ]
        ] ++
            if state.showMenu then
                [ menu viewState config items]
            else
                []
        )

menu : State -> Config data msg -> List data -> Html msg
menu state config items =
    Keyed.ul
        [ style
            [ ( "position", "absolute" )
            , ( "width", "100%" )
            ]
        , classList
            [("list-group", True)
            --,("hidden", not state.showMenu)
            ]
        ]
        (List.map (menuItem state config) items)


menuItem : State -> Config data msg -> data -> (String, Html msg)
menuItem (State state) {toMsg, itemFn, idFn} item =
    let
        itemDetails =
            itemFn item
        itemId =
            idFn item

        isActive =
            case state.activeId of
                Just activeId ->
                    activeId == itemId
                Nothing ->
                    False
    in
        ( itemId
        , li
            (itemDetails.attributes
                ++ [ classList
                    [ ("list-group-item", True)
                    , ("active", isActive)
                    ]
                   , style
                        [ ( "border-top", "0" )
                        , ( "border-top-left-radius", "0" )
                        ]
                   , Events.on "mouseenter" <|
                       Json.succeed <| toMsg <| State { state | activeId = Just itemId }
                   , Events.on "mouseleave" <|
                       Json.succeed <| toMsg <| State { state | activeId = Nothing }
                   ]
            )
            itemDetails.children
        )



