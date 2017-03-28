module Bootstrap.Internal.Card exposing (..)

import Html
import Html.Attributes exposing (class)
import Color
import Bootstrap.Internal.Text as Text
import Bootstrap.Internal.ListGroup as ListGroup


type CardOption msg
    = Aligned Text.HAlign
    | Coloring RoleOption
    | Attrs (List (Html.Attribute msg))


type RoleOption
    = Roled Role
    | Outlined Role
    | Inverted Color.Color


type Role
    = Primary
    | Success
    | Info
    | Warning
    | Danger


type alias CardOptions msg =
    { aligned : Maybe Text.HAlign
    , coloring : Maybe RoleOption
    , attributes : List (Html.Attribute msg)
    }


type BlockOption msg
    = AlignedBlock Text.HAlign
    | BlockAttrs (List (Html.Attribute msg))


type alias BlockOptions msg =
    { aligned : Maybe Text.HAlign
    , attributes : List (Html.Attribute msg)
    }


type CardBlock msg
    = CardBlock (Html.Html msg)
    | ListGroup (Html.Html msg)


type BlockItem msg
    = BlockItem (Html.Html msg)


renderBlocks : List (CardBlock msg) -> List (Html.Html msg)
renderBlocks blocks =
    List.map
        (\block ->
            case block of
                CardBlock e ->
                    e

                ListGroup e ->
                    e
        )
        blocks


renderBlock : CardBlock msg -> Html.Html msg
renderBlock block =
    case block of
        CardBlock e ->
            e

        ListGroup e ->
            e


block :
    List (BlockOption msg)
    -> List (BlockItem msg)
    -> CardBlock msg
block options items =
    Html.div
        (blockAttributes options)
        (List.map (\(BlockItem e) -> e) items)
        |> CardBlock


listGroup : List (ListGroup.Item msg) -> CardBlock msg
listGroup items =
    Html.ul
        [ class "list-group list-group-flush" ]
        (List.map ListGroup.renderItem items)
        |> ListGroup


blockAttributes : List (BlockOption msg) -> List (Html.Attribute msg)
blockAttributes modifiers =
    let
        options =
            List.foldl applyBlockModifier defaultBlockOptions modifiers
    in
        [ class "card-block" ]
            ++ (case options.aligned of
                    Just align ->
                        [ Text.textAlignClass align ]

                    Nothing ->
                        []
               )
            ++ options.attributes


defaultBlockOptions : BlockOptions msg
defaultBlockOptions =
    { aligned = Nothing
    , attributes = []
    }


applyBlockModifier : BlockOption msg -> BlockOptions msg -> BlockOptions msg
applyBlockModifier option options =
    case option of
        AlignedBlock align ->
            { options | aligned = Just align }

        BlockAttrs attrs ->
            { options | attributes = options.attributes ++ attrs }


cardAttributes : List (CardOption msg) -> List (Html.Attribute msg)
cardAttributes modifiers =
    let
        options =
            List.foldl applyModifier defaultOptions modifiers
    in
        [ class "card" ]
            ++ (case options.coloring of
                    Just (Roled role) ->
                        [ class <| "card-inverse card-" ++ roleOption role ]

                    Just (Outlined role) ->
                        [ class <| "card-outline-" ++ roleOption role ]

                    Just (Inverted color) ->
                        [ class "card-inverse"
                        , Html.Attributes.style [ ( "background-color", toRGBString color ), ( "border-color", toRGBString color ) ]
                        ]

                    Nothing ->
                        []
               )
            ++ (case options.aligned of
                    Just align ->
                        [ Text.textAlignClass align ]

                    Nothing ->
                        []
               )
            ++ options.attributes


defaultOptions : CardOptions msg
defaultOptions =
    { aligned = Nothing
    , coloring = Nothing
    , attributes = []
    }


applyModifier : CardOption msg -> CardOptions msg -> CardOptions msg
applyModifier option options =
    case option of
        Aligned align ->
            { options | aligned = Just align }

        Coloring coloring ->
            { options | coloring = Just coloring }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }


roleOption : Role -> String
roleOption role =
    case role of
        Primary ->
            "primary"

        Success ->
            "success"

        Info ->
            "info"

        Warning ->
            "warning"

        Danger ->
            "danger"


toRGBString : Color.Color -> String
toRGBString color =
    let
        { red, green, blue } =
            Color.toRgb color
    in
        "RGB(" ++ toString red ++ "," ++ toString green ++ "," ++ toString blue ++ ")"
