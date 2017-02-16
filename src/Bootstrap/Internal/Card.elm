module Bootstrap.Internal.Card
    exposing
        ( block
        , listGroup
        , renderBlocks
        , renderBlock
        , BlockOption(..)
        , BlockOptions
        , CardBlock(..)
        , BlockItem(..)
        )

import Html
import Html.Attributes exposing (class)
import Bootstrap.Internal.Text as Text
import Bootstrap.Internal.ListGroup as ListGroup


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
