module Page.Card exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Card as Card
import Bootstrap.Button as Button
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Text as Text
import Util
import Color


view : List (Html msg)
view =
    [ Util.simplePageHeader
        "Card"
        """A card is a flexible and extensible content container.
        It includes options for headers and footers, a wide variety of content, contextual background colors, and powerful display options."""
    , Util.pageContent
        (example
            ++ blocks
            ++ blockContents
            ++ listGroups
            ++ headerAndFooter
            ++ alignment
            ++ inverted
            ++ backgrounds
            ++ outlines
            ++ groups
            ++ decks
            ++ columns
        )
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


exampleCode : Html msg
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


blocks : List (Html msg)
blocks =
    [ h2 [] [ text "Blocks" ]
    , p [] [ text "The building block of a card is the block. Use it whenever you need a padded section within a card." ]
    , Util.example
        [ Card.config []
            |> Card.block []
                [ Card.text [] [ text "This is some text within a card block." ] ]
            |> Card.view
        ]
    , Util.code blocksCode
    ]


blocksCode : Html msg
blocksCode =
    Util.toMarkdownElm """
Card.config []
    |> Card.block []
        [ Card.text [] [ text "This is some text within a card block." ] ]
    |> Card.view
"""


blockContents : List (Html msg)
blockContents =
    [ h2 [] [ text "Titles, text, and links" ]
    , p []
        [ text """You can create card titles within a card block using the titleH* functions.
                    To add text paragraphs just use the text function and if you want links placed next to each other use the link function."""
        ]
    , Util.example
        [ Card.config []
            |> Card.block []
                [ Card.titleH4 [] [ text "Card title" ]
                , Card.text [] [ text "This is some text within a card block." ]
                , Card.link [ href "javascript:void()" ] [ text "Card link" ]
                , Card.link [ href "javascript:void()" ] [ text "Another link" ]
                ]
            |> Card.view
        ]
    , Util.code blockContentsCode
    ]


blockContentsCode : Html msg
blockContentsCode =
    Util.toMarkdownElm """
Card.config []
    |> Card.block []
        [ Card.titleH4 [] [ text "Card title" ]
        , Card.text [] [ text "This is some text within a card block." ]
        , Card.link [ href "#"] [ text "Card link" ]
        , Card.link [ href "#"] [ text "Another link" ]
        ]
    |> Card.view
"""


headerAndFooter : List (Html msg)
headerAndFooter =
    [ h2 [] [ text "Header and footer" ]
    , p [] [ text "Add an optional header and/or footer within a card." ]
    , Util.example
        [ Card.config []
            |> Card.header [] [ text "Featured" ]
            |> Card.block []
                [ Card.titleH3 [] [ text "Special title treatment" ]
                , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
                , Card.custom <|
                    Button.button [ Button.primary ] [ text "Go somewhere" ]
                ]
            |> Card.view
        ]
    , Util.code headerSimpleCode
    , p [] [ text "For your convenience you may alternatively one of the shorthand headerH* functions" ]
    , Util.example
        [ Card.config []
            |> Card.headerH3 [] [ text "Featured" ]
            |> Card.block []
                [ Card.titleH3 [] [ text "Special title treatment" ]
                , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
                , Card.custom <|
                    Button.button [ Button.primary ] [ text "Go somewhere" ]
                ]
            |> Card.view
        ]
    , Util.code headerCode
    , p [] [ text "Adding a footer is done using the footer function." ]
    , Util.example
        [ Card.config []
            |> Card.headerH3 [] [ text "Featured" ]
            |> Card.block []
                [ Card.titleH3 [] [ text "Special title treatment" ]
                , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
                , Card.custom <|
                    Button.button [ Button.primary ] [ text "Go somewhere" ]
                ]
            |> Card.footer [] [ text "2 days ago" ]
            |> Card.view
        ]
    , Util.code footerCode
    ]


headerSimpleCode : Html msg
headerSimpleCode =
    Util.toMarkdownElm """
Card.config []
    |> Card.header [] [ text "Featured" ]
    |> Card.block []
        [ Card.titleH3 [] [ text "Special title treatment" ]
        , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
        , Card.custom <|
            Button.button [ Button.primary ] [ text "Go somewhere" ]
        ]
    |> Card.view
"""


headerCode : Html msg
headerCode =
    Util.toMarkdownElm """
Card.config []
    |> Card.headerH3 [] [ text "Featured" ]
    |> Card.block []
        [ Card.titleH3 [] [ text "Special title treatment" ]
        , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
        , Card.custom <|
            Button.button [ Button.primary ] [ text "Go somewhere" ]
        ]
    |> Card.view
"""


footerCode : Html msg
footerCode =
    Util.toMarkdownElm """
Card.config []
    |> Card.headerH3 [] [ text "Featured"]
    |> Card.block []
        [ Card.titleH3 [] [ text "Special title treatment" ]
        , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
        , Card.custom <|
            Button.button [ Button.primary ] [ text "Go somewhere" ]
        ]
    |> Card.footer [] [ text "2 days ago" ]
    |> Card.view
"""


alignment : List (Html msg)
alignment =
    [ h2 [] [ text "Text alignment" ]
    , p [] [ text "You can quickly change the text alignment of any card. Either in its entirety or specific parts using the align or blockAlign functions." ]
    , Util.example
        [ Card.config [ Card.align Text.alignXsCenter ]
            |> Card.block [] sampleBlockContents
            |> Card.view
        , Card.config [ Card.align Text.alignXsRight ]
            |> Card.block [] sampleBlockContents
            |> Card.view
        , Card.config [ Card.align Text.alignXsCenter, Card.attrs [ class "mt-4" ] ]
            |> Card.headerH3 [] [ text "Centered header" ]
            |> Card.block [ Card.blockAlign Text.alignXsLeft ] sampleBlockContents
            |> Card.block [ Card.blockAlign Text.alignXsRight ] sampleBlockContents
            |> Card.footer [] [ text "Centered footer" ]
            |> Card.view
        ]
    , Util.code alignmentCode
    ]


sampleBlockContents : List (Card.BlockItem msg)
sampleBlockContents =
    [ Card.titleH3 [] [ text "Special title treatment" ]
    , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
    , Card.custom <|
        Button.button [ Button.primary ] [ text "Go somewhere" ]
    ]


alignmentCode : Html msg
alignmentCode =
    Util.toMarkdownElm """
div []
    [ Card.config [ Card.align Text.alignXsCenter ]
        |> Card.block [] sampleBlockContents
        |> Card.view
    , Card.config [ Card.align Text.alignXsRight ]
        |> Card.block [] sampleBlockContents
        |> Card.view

    , Card.config [ Card.align Text.alignXsCenter, Card.attrs [class "mt-4"] ]
        |> Card.headerH3 [] [ text "Centered header" ]
        |> Card.block [ Card.blockAlign Text.alignXsLeft ] sampleBlockContents
        |> Card.block [ Card.blockAlign Text.alignXsRight ] sampleBlockContents
        |> Card.footer [] [ text "Centered footer" ]
        |> Card.view
    ]

sampleBlockContents : List (Card.BlockItem msg)
sampleBlockContents =
    [ Card.titleH3 [] [ text "Special title treatment" ]
    , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
    , Card.custom <|
        Button.button [ Button.primary ] [ text "Go somewhere" ]
    ]
"""


listGroups : List (Html msg)
listGroups =
    [ h2 [] [ text "List groups" ]
    , p [] [ text "Add a list group to a card" ]
    , Util.example
        [ Card.config []
            |> Card.listGroup
                [ ListGroup.li [ ListGroup.success ] [ text "Cras justo odio" ]
                , ListGroup.li [ ListGroup.info ] [ text "Dapibus ac facilisis in" ]
                , ListGroup.li [ ListGroup.warning ] [ text "Vestibulum at eros" ]
                ]
            |> Card.view
        ]
    , Util.code listGroupsCode
    ]


listGroupsCode : Html msg
listGroupsCode =
    Util.toMarkdownElm """
Card.config []
    |> Card.listGroup
        [ ListGroup.li [ ListGroup.success ] [ text "Cras justo odio" ]
        , ListGroup.li [ ListGroup.info ] [ text "Dapibus ac facilisis in" ]
        , ListGroup.li [ ListGroup.warning ] [ text "Vestibulum at eros" ]
        ]
    |> Card.view
"""


inverted : List (Html msg)
inverted =
    [ h2 [] [ text "Inverted text" ]
    , p [] [ text """By default, cards use dark text and assume a light background.
                    You can reverse that by toggling the color of text within, as well as that of the card’s subcomponents, using the inverted function.
                    This will change the background color and border color of your card to the specified color.

You can also use .card-inverse with the contextual backgrounds variants.""" ]
    , Util.example
        [ Card.config [ Card.inverted Color.brown ]
            |> Card.block []
                [ Card.titleH3 [] [ text "Special title treatment" ]
                , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
                , Card.custom <|
                    Button.button [ Button.primary ] [ text "Go somewhere" ]
                ]
            |> Card.view
        ]
    , Util.example [ invertedCode ]
    ]


invertedCode : Html msg
invertedCode =
    Util.toMarkdownElm """
Card.config [ Card.inverted Color.brown ]
    |> Card.block []
        [ Card.titleH3 [] [ text "Special title treatment" ]
        , Card.text [] [ text "With supporting text below as a natural lead-in to additional content." ]
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
    , Util.code backgroundsCode
    ]


backgroundsCode : Html msg
backgroundsCode =
    Util.toMarkdownElm """
div []
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


quote : Card.BlockItem msg
quote =
    Card.blockQuote []
        [ p [] [ text "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer posuere erat a ante." ]
        , footer []
            [ text "Someone famous in "
            , Html.cite [ title "Source Title" ] [ text "Source Title" ]
            ]
        ]

"""


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
    , Util.code outlinesCode
    ]


outlinesCode : Html msg
outlinesCode =
    Util.toMarkdownElm """
Util.example
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
"""


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
    , Util.code groupsCode
    ]


groupsCode : Html msg
groupsCode =
    Util.toMarkdownElm """

Card.group cardList


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

"""


decks : List (Html msg)
decks =
    [ h2 [] [ text "Card decks" ]
    , p [] [ text "Need a set of equal width and height cards that aren’t attached to one another? Use card decks." ]
    , Util.example
        [ Card.deck cardList ]
    , Util.code decksCode
    ]


decksCode : Html msg
decksCode =
    Util.toMarkdownElm """
Card.deck cardList"""


columns : List (Html msg)
columns =
    [ h2 [] [ text "Card columns" ]
    , p [] [ text "Cards can be organized into Masonry-like columns by using cardColumns. Cards are built with CSS column properties instead of flexbox for easier alignment. Cards are ordered from top to bottom and left to right." ]
    , Util.example
        [ Card.columns (cardList ++ cardList) ]
    , Util.code columnsCode
    , Util.calloutWarning
        [ p [] [ text "Heads up! Your mileage with card columns may vary. To prevent cards breaking across columns, we must set them to display: inline-block as column-break-inside: avoid isn’t a bulletproof solution yet." ] ]
    ]


columnsCode : Html msg
columnsCode =
    Util.toMarkdownElm """
Card.columns (cardList ++ cardList)"""


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
