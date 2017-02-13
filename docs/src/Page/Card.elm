module Page.Card exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Card as Card
import Bootstrap.Button as Button
import Util


view : List (Html msg)
view =
    [ Util.simplePageHeader
        "Card"
        """A card is a flexible and extensible content container.
        It includes options for headers and footers, a wide variety of content, contextual background colors, and powerful display options."""
    , Util.pageContent
        (example ++ backgrounds ++ outlines ++ groups ++ decks ++ columns)
    ]


example : List (Html msg)
example =
    [ h2 [] [ text "Example" ]
    , p [] [ text """Cards are built with as little markup and styles as possible, but still manage to deliver a ton of control and customization.
                    Built with flexbox, they offer easy alignment and mix well with other Bootstrap components.""" ]
    , Util.example
        [ Card.config [ Card.attrs [ style [ ( "width", "20rem" ) ] ] ]
            |> Card.header [ class "text-center" ]
                [ img [ src "assets/images/elm-bootstrap.svg" ] []
                , h3 [ class "mt-2" ] [ text "Custom Card Header" ]
                ]
            |> Card.block []
                [ Card.titleH4 [] [ text "Card title" ]
                , Card.text [] [ text "Some quick example text to build on the card title and make up the bulk of the card's content." ]
                , Card.custom <|
                    Button.button [ Button.primary ] [ text "Go somewhere" ]
                ]
            |> Card.view
        ]
    , Util.example [ exampleCode ]
    ]


exampleCode =
    Util.toMarkdownElm """
Card.config [ Card.attrs [ style [ ( "width", "20rem" ) ] ] ]
    |> Card.header [ class "text-center" ]
        [ img [ src "assets/images/elm-bootstrap.svg" ] []
        , h3 [ class "mt-2" ] [ text "Custom Card Header" ]
        ]
    |> Card.block []
        [ Card.titleH4 [] [ text "Card title" ]
        , Card.text [] [ text "Some quick example text to build on the card title and make up the bulk of the card's content." ]
        , Card.custom <|
            Button.button [ Button.primary ] [ text "Go somewhere" ]
        ]
    |> Card.view
"""




backgrounds : List (Html msg)
backgrounds =
    [ h2 [] [ text "Background variants" ]
    , p [] [ text "You can quickly add a background color and border using appropriate helper functions." ]
    , Util.example
        [ Card.config [ Card.primary, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.success, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.info, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.warning, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.danger ]
            |> Card.block []
                [ quote ]
            |> Card.view
        ]
    ]


outlines : List (Html msg)
outlines =
    [ h2 [] [ text "Outline cards" ]
    , p [] [ text "in need of a colored card, but not the hefty background colors they bring? Use the outline* functions to give cards a colored border" ]
    , Util.example
        [ Card.config [ Card.outlinePrimary, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.outlineSuccess, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.outlineInfo, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.outlineWarning, Card.attrs [ class "mb-3" ] ]
            |> Card.block []
                [ quote ]
            |> Card.view
        , Card.config [ Card.outlineDanger ]
            |> Card.block []
                [ quote ]
            |> Card.view
        ]
    ]


quote : Card.BlockItem msg
quote =
    Card.blockQuote []
        [ p [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante." ]
        , footer []
            [ text "Someone famous in "
            , Html.cite [ title "Source Title" ] [ text "Source Title" ]
            ]
        ]


groups : List (Html msg)
groups =
    [ h2 [] [ text "Card groups" ]
    , p [] [ text "Use card groups to render cards as a single, attached element with equal width and height columns." ]
    , Util.example
        [ Card.group cardList ]
    ]


decks : List (Html msg)
decks =
    [ h2 [] [ text "Card decks" ]
    , p [] [ text "Need a set of equal width and height cards that aren’t attached to one another? Use card decks." ]
    , Util.example
        [ Card.deck cardList ]
    ]

columns : List (Html msg)
columns =
    [ h2 [] [ text "Card columns" ]
    , p [] [ text "Cards can be organized into Masonry-like columns by using cardColumns. Cards are built with CSS column properties instead of flexbox for easier alignment. Cards are ordered from top to bottom and left to right." ]
    , Util.example
        [ Card.columns (cardList ++ cardList) ]

    , Util.calloutWarning
        [ p [] [ text "Heads up! Your mileage with card columns may vary. To prevent cards breaking across columns, we must set them to display: inline-block as column-break-inside: avoid isn’t a bulletproof solution yet." ] ]
    ]


cardList : List (Card.Config msg)
cardList =
    [ Card.config []
        |> Card.headerH3 [] [ text "Card header" ]
        |> Card.block []
            [ Card.text [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante." ] ]
        |> Card.footer []
            [ small [ class "text-muted" ] [ text "Last updated 3 mins ago" ] ]
    , Card.config []
        |> Card.headerH3 [] [ text "Card2 header" ]
        |> Card.block []
            [ Card.text [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit." ] ]
        |> Card.footer []
            [ small [ class "text-muted" ] [ text "Last updated 3 mins ago" ] ]
    , Card.config []
        |> Card.headerH3 [] [ text "Card3 header" ]
        |> Card.block []
            [ Card.text [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit." ] ]
        |> Card.footer []
            [ small [ class "text-muted" ] [ text "Last updated 3 mins ago" ] ]
    ]
