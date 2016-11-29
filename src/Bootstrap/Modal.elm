module Bootstrap.Modal
    exposing
        ( modal
        , config
        , hiddenState
        , visibleState
        , Config
        , State
        , Size (..)
        )

import Html
import Html.Attributes as Attr
import Html.Events as Events


type State
    = State Bool


type Config msg
    = Config
        { closeMsg : State -> msg
        , header : Maybe (Html.Html msg)
        , body : Maybe (Html.Html msg)
        , footer : Maybe (Html.Html msg)
        , size : Maybe Size
        }

type Size
    = ExtraSmall
    | Small
    | Medium
    | Large


hiddenState : State
hiddenState =
    State False


visibleState : State
visibleState =
    State True


config :
    { closeMsg : State -> msg
    , header : Maybe (Html.Html msg)
    , body : Maybe (Html.Html msg)
    , footer : Maybe (Html.Html msg)
    , size : Maybe Size
    }
    -> Config msg
config { closeMsg, header, body, footer, size } =
    Config
        { closeMsg = closeMsg
        , header = header
        , body = body
        , footer = footer
        , size = size
        }


modal :
    Config msg
    -> State
    -> Html.Html msg
modal (Config { closeMsg, header, body, footer, size }) state =
    Html.div
        []
        [ Html.div
            ([ Attr.tabindex -1 ] ++ display state)
            [ Html.div
                [ modalClass size
                , Attr.attribute "role" "document"
                ]
                [ Html.div
                    [ Attr.class "modal-content" ]
                    (modalHeader closeMsg header
                        :: List.filterMap
                            modalItem
                            [ ( "modal-body", body ), ( "modal-footer", footer ) ]
                    )
                ]
            ]
        , backdrop state
        ]


display : State -> List (Html.Attribute msg)
display (State open) =
    [ Attr.style
        [ ( "display", ifElse open "block" "none" ) ]
    , Attr.class <| "modal " ++ ifElse open "in" ""
    ]


modalClass : Maybe Size -> Html.Attribute msg
modalClass maybeSize =
    Attr.class <|
        "modal-dialog " ++
        (Maybe.map sizeClass maybeSize
            |> Maybe.withDefault "")



modalHeader : (State -> msg) -> Maybe (Html.Html msg) -> Html.Html msg
modalHeader closeMsg maybeHeader =
    Html.div
        [ Attr.class "modal-header" ]
        ([ closeButton closeMsg ]
            ++ case maybeHeader of
                Just header ->
                    [ header ]

                Nothing ->
                    []
        )


modalItem : ( String, Maybe (Html.Html msg) ) -> Maybe (Html.Html msg)
modalItem ( itemClass, maybeItem ) =
    case maybeItem of
        Just item ->
            Just <| Html.div [ Attr.class itemClass ] [ item ]

        Nothing ->
            Nothing


closeButton : (State -> msg) -> Html.Html msg
closeButton closeMsg =
    Html.button
        [ Attr.class "close", Events.onClick (closeMsg hiddenState) ]
        [ Html.text "x" ]


backdrop : State -> Html.Html msg
backdrop ((State open) as state) =
    Html.div
        [ Attr.classList [ ( "modal-backdrop in", open ) ] ]
        []


ifElse : Bool -> a -> a -> a
ifElse pred true false =
    if pred then
        true
    else
        false


sizeClass : Size -> String
sizeClass size =
    case size of
        ExtraSmall ->
            "modal-xs"

        Small ->
            "modal-sm"

        Medium ->
            "modal-md"

        Large ->
            "modal-lg"
