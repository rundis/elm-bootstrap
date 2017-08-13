module Bootstrap.Card.Internal exposing (..)

import Html
import Html.Attributes exposing (class)
import Bootstrap.Internal.Text as Text
import Bootstrap.Internal.ListGroup as ListGroup
import Bootstrap.Internal.Role as Role



type CardOption msg
    = Aligned Text.HAlign
    | Coloring RoleOption
    | TextColoring Text.Color
    | Attrs (List (Html.Attribute msg))


type RoleOption
    = Roled Role.Role
    | Outlined Role.Role




type alias CardOptions msg =
    { aligned : Maybe Text.HAlign
    , coloring : Maybe RoleOption
    , textColoring : Maybe Text.Color
    , attributes : List (Html.Attribute msg)
    }


type BlockOption msg
    = AlignedBlock Text.HAlign
    | BlockColoring Role.Role
    | BlockTextColoring Text.Color
    | BlockAttrs (List (Html.Attribute msg))


type alias BlockOptions msg =
    { aligned : Maybe Text.HAlign
    , coloring : Maybe Role.Role
    , textColoring : Maybe Text.Color
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
        [ class "card-body" ]
            ++ (case options.aligned of
                    Just align ->
                        [ Text.textAlignClass align ]

                    Nothing ->
                        []
               )
            ++ (case options.coloring of
                    Just role ->
                        [ Role.toClass "bg" role ]

                    Nothing ->
                        []
               )
            ++ (case options.textColoring of
                    Just color ->
                        [ Text.textColorClass color ]

                    Nothing ->
                        []
               )
            ++ options.attributes


defaultBlockOptions : BlockOptions msg
defaultBlockOptions =
    { aligned = Nothing
    , coloring = Nothing
    , textColoring = Nothing
    , attributes = []
    }


applyBlockModifier : BlockOption msg -> BlockOptions msg -> BlockOptions msg
applyBlockModifier option options =
    case option of
        AlignedBlock align ->
            { options | aligned = Just align }

        BlockColoring role ->
            { options | coloring = Just role }

        BlockTextColoring color ->
            { options | textColoring = Just color }

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
                        [ Role.toClass "bg" role ]

                    Just (Outlined role) ->
                        [ Role.toClass "border" role ]

                    Nothing ->
                        []
               )
            ++ (case options.textColoring of
                    Just color ->
                        [ Text.textColorClass color ]

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
    , textColoring = Nothing
    , attributes = []
    }


applyModifier : CardOption msg -> CardOptions msg -> CardOptions msg
applyModifier option options =
    case option of
        Aligned align ->
            { options | aligned = Just align }

        Coloring coloring ->
            { options | coloring = Just coloring }

        TextColoring coloring ->
            { options | textColoring = Just coloring }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }
