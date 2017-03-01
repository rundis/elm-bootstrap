module Bootstrap.Card
    exposing
        ( view
        , config
        , attrs
        , blockAttrs
        , align
        , danger
        , info
        , primary
        , success
        , warning
        , outlineDanger
        , outlineInfo
        , outlinePrimary
        , outlineSuccess
        , outlineWarning
        , inverted
        , link
        , text
        , blockQuote
        , custom
        , imgTop
        , imgBottom
        , header
        , footer
        , headerH1
        , headerH2
        , headerH3
        , headerH4
        , headerH5
        , headerH6
        , block
        , blockAlign
        , listGroup
        , titleH1
        , titleH2
        , titleH3
        , titleH4
        , titleH5
        , titleH6
        , group
        , deck
        , columns
        , Config
        , CardOption
        , BlockOption
        , CardBlock
        , CardFooter
        , CardHeader
        , CardImageBottom
        , CardImageTop
        , BlockItem
        )

{-| A card is a flexible and extensible content container. It includes options for headers and footers, a wide variety of content, contextual background colors, and powerful display options.


# Cards
@docs view, Config


## Header
@docs header, headerH1, headerH2, headerH3, headerH4, headerH5, headerH6, CardHeader

## Footer
@docs CardFooter, footer


## Images
@docs imgTop, imgBottom, CardImageTop, CardImageBottom


## Options
You can customize the look and feel of your cards using the following options

@docs config, align, primary, success, info, warning, danger, outlinePrimary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger, inverted, attrs, CardOption


# Blocks
@docs block, listGroup, CardBlock, BlockItem


## Block title
@docs titleH1, titleH2, titleH3, titleH4, titleH5, titleH6


## Misc
@docs link, text, blockQuote, custom

## Block options
@docs blockAlign, blockAttrs, BlockOption


# Composing cards
Cards can be composed into
* [`groups`](#group)
* [`decks`](#deck)
* [`columns`](#columns)

@docs group, deck, columns

-}

import Html
import Html.Attributes exposing (class)
import Color
import Bootstrap.Text as Text
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Internal.Card as CardInternal


{-| Opaque type representing options for customizing the styling of a card
-}
type alias CardOption msg = CardInternal.CardOption msg



{-| Opaque type representing options for styling a card block
-}
type alias BlockOption msg = CardInternal.BlockOption msg




{-| Opaque type representing the view configuration of a card

You may use the following functions to expand/change a configuration:
* [`header`](#header) or [`headerH1`](#headerH1), [`headerH2`](#headerH2) etc
* [`footer`](#footer)
* [`block`](#block)
* [`imgTop`](#imgTop)
* [`imgBottom`](#imgBottom)

-}
type Config msg
    = Config
        { options : List (CardOption msg)
        , header : Maybe (CardHeader msg)
        , footer : Maybe (CardFooter msg)
        , imgTop : Maybe (CardImageTop msg)
        , imgBottom : Maybe (CardImageBottom msg)
        , blocks : List (CardInternal.CardBlock msg)
        }


{-| Opaque type representing a card header element
-}
type CardHeader msg
    = CardHeader (Html.Html msg)


{-| Opaque type representing a card footer element
-}
type CardFooter msg
    = CardFooter (Html.Html msg)


{-| Opaque type representing a card image placed at the top
-}
type CardImageTop msg
    = CardImageTop (Html.Html msg)


{-| Opaque type representing a card image placed at the bottom
-}
type CardImageBottom msg
    = CardImageBottom (Html.Html msg)


{-| Opaque type representing a card block element
-}
type CardBlock msg
    = CardBlock (Html.Html msg)
    | ListGroup (Html.Html msg)


{-| Opaque type representing a legal card block child element
-}
type alias BlockItem msg = CardInternal.BlockItem msg




-- CARD


{-| Option to specify horizonal alignment of card contents
-}
align : Text.HAlign -> CardOption msg
align align =
    CardInternal.Aligned align


{-| Give cards a primary background color and appropriate foreground color
-}
primary : CardOption msg
primary =
    CardInternal.Coloring <| CardInternal.Roled CardInternal.Primary


{-| Give cards a success background color and appropriate foreground color
-}
success : CardOption msg
success =
    CardInternal.Coloring <| CardInternal.Roled CardInternal.Success


{-| Give cards a info background color and appropriate foreground color
-}
info : CardOption msg
info =
    CardInternal.Coloring <| CardInternal.Roled CardInternal.Info


{-| Give cards a warning background color and appropriate foreground color
-}
warning : CardOption msg
warning =
    CardInternal.Coloring <| CardInternal.Roled CardInternal.Warning


{-| Give cards a danger background color and appropriate foreground color
-}
danger : CardOption msg
danger =
    CardInternal.Coloring <| CardInternal.Roled CardInternal.Danger


{-| Give cards a primary colored outline
-}
outlinePrimary : CardOption msg
outlinePrimary =
    CardInternal.Coloring <| CardInternal.Outlined CardInternal.Primary


{-| Give cards a success colored outline
-}
outlineSuccess : CardOption msg
outlineSuccess =
    CardInternal.Coloring <| CardInternal.Outlined CardInternal.Success


{-| Give cards a info colored outline
-}
outlineInfo : CardOption msg
outlineInfo =
    CardInternal.Coloring <| CardInternal.Outlined CardInternal.Info


{-| Give cards a warning colored outline
-}
outlineWarning : CardOption msg
outlineWarning =
    CardInternal.Coloring <| CardInternal.Outlined CardInternal.Warning


{-| Give cards a danger colored outline
-}
outlineDanger : CardOption msg
outlineDanger =
    CardInternal.Coloring <| CardInternal.Outlined CardInternal.Danger

{-| Give cards a custom dark background color with light text -}
inverted : Color.Color -> CardOption msg
inverted color =
    CardInternal.Coloring <| CardInternal.Inverted color


{-| When you need to customize a card item with standard Html.Attribute attributes use this function
-}
attrs : List (Html.Attribute msg) -> CardOption msg
attrs attrs =
    CardInternal.Attrs attrs


{-| Template/default config which you use as a starting point to compose your cards.

* options - List of card wide styling options
-}
config : List (CardOption msg) -> Config msg
config options =
    Config
        { options = options
        , header = Nothing
        , footer = Nothing
        , imgTop = Nothing
        , imgBottom = Nothing
        , blocks = []
        }


{-| View a card standalone. To create a card you start off with a basic configuration which you can compose
of several optional elements.

    Card.config [ Card.outlineInfo ]
        |> Card.headerH1 [] [ text "My Card Info" ]
        |> Card.footer [] [ text "Some footer" ]
        |> Card.block []
            [ Card.titleH1 [] [ text "Block title" ]
            , Card.text [] [ text "Some block content" ]
            , Card.link [ href "#" ] [ text "MyLink"]
            ]
        |> Card.view

* config - See [`Config`](#Config) for what items you may compose your cards with
-}
view :
    Config msg
    -> Html.Html msg
view (Config { options, header, footer, imgTop, imgBottom, blocks }) =
    Html.div
        (CardInternal.cardAttributes options )
        (List.filterMap
            identity
            [ Maybe.map (\(CardHeader e) -> e) header
            , Maybe.map (\(CardImageTop e) -> e) imgTop
            ]
            ++ ( CardInternal.renderBlocks blocks )
            ++ List.filterMap
                identity
                [ Maybe.map (\(CardFooter e) -> e) footer
                , Maybe.map (\(CardImageBottom e) -> e) imgBottom
                ]
        )


{-| Create a <img> element to be shown at the top of a card

* `attributes` List of attributes
* `children` List of child elements
-}
imgTop :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
imgTop attributes children (Config config) =
    Config
        { config
            | imgTop =
                Html.img
                    ([ class "card-img-top" ] ++ attributes)
                    children
                    |> CardImageTop
                    |> Just
        }


{-| Create a <img> element to be shown at the bottom of a card

* `attributes` List of attributes
* `children` List of child elements
-}
imgBottom :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
imgBottom attributes children (Config config) =
    Config
        { config
            | imgBottom =
                Html.img
                    ([ class "card-img-bottom" ] ++ attributes)
                    children
                    |> CardImageBottom
                    |> Just
        }


{-| Create a card header element

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
header :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
header =
    headerPrivate Html.div


{-| Create a card footer element

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
footer :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
footer attributes children (Config config) =
    Config
        { config
            | footer =
                Html.div
                    (class "card-footer" :: attributes)
                    children
                    |> CardFooter
                    |> Just
        }


{-| Create a card h1 header

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
headerH1 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH1 =
    headerPrivate Html.h1


{-| Create a card h2 header

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
headerH2 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH2 =
    headerPrivate Html.h2


{-| Create a card h3 header

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
headerH3 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH3 =
    headerPrivate Html.h3


{-| Create a card h4 header

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
headerH4 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH4 =
    headerPrivate Html.h4


{-| Create a card h5 header

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
headerH5 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH5 =
    headerPrivate Html.h5


{-| Create a card h6 header

* `attributes` List of attributes
* `children` List of child elements
* `config` A card [`Config`](#Config) that you wish to extend/override
-}
headerH6 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH6 =
    headerPrivate Html.h6


headerPrivate :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerPrivate elemFn attributes children (Config config) =
    Config
        { config
            | header =
                elemFn (class "card-header" :: attributes) children
                    |> CardHeader
                    |> Just
        }



-- Block level stuff


{-| Option to specify horizontal alignment of a card block item

    Card.blockAlign Text.xs

-}
blockAlign : Text.HAlign -> BlockOption msg
blockAlign align =
    CardInternal.AlignedBlock align


{-| When you need to customize a block item with standard Html.Attribute attributes use this function
-}
blockAttrs : List (Html.Attribute msg) -> BlockOption msg
blockAttrs attrs =
    CardInternal.BlockAttrs attrs


{-| The building block of a card is the card block. Use it whenever you need a padded section within a card.
You may have multiple blocks in a card, this function will add blocks to your Cards.

* blockOptions - List of [`block options`](#BlockOption) to configure block level styling
* item - List of [`block items`](#BlockItem)
* `config` A card [`Config`](#Config) that you wish to add a block element to
-}
block :
    List (BlockOption msg)
    -> List (BlockItem msg)
    -> Config msg
    -> Config msg
block options items (Config config) =
    Config
        { config
            | blocks =
                config.blocks
                    ++ [ CardInternal.block options items]
        }


{-| You may add list groups, just like you can add card blocks to a Card.
Use the li function in the ListGroup module to add and configure the list items.
-}
listGroup :
    List (ListGroup.Item msg)
    -> Config msg
    -> Config msg
listGroup items (Config config) =
    Config
        { config
            | blocks =
                config.blocks
                    ++ [ CardInternal.listGroup items ]
        }





{-| Create link elements that are placed next to each other in a block using this function

* `attributes` List of attributes
* `children` List of child elements
-}
link : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
link attributes children =
    Html.a
        ([ class "card-link" ] ++ attributes)
        children
        |> CardInternal.BlockItem


{-| Create a card text element

* `attributes` List of attributes
* `children` List of child elements
-}
text : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
text attributes children =
    Html.p
        ([ class "card-text" ] ++ attributes)
        children
        |> CardInternal.BlockItem


{-|  Add a custom HTML element to be displayed in a Card block
-}
custom : Html.Html msg -> BlockItem msg
custom element =
    CardInternal.BlockItem element

{-| Create a block quote element

* `attributes` List of attributes
* `children` List of child elements
-}
blockQuote : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
blockQuote attributes children =
    Html.blockquote
        ([ class "card-blockquote" ] ++ attributes)
        children
        |> CardInternal.BlockItem


{-| Create a block h1 title

* `attributes` List of attributes
* `children` List of child elements
-}
titleH1 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH1 =
    title Html.h1


{-| Create a block h2 title

* `attributes` List of attributes
* `children` List of child elements
-}
titleH2 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH2 =
    title Html.h2


{-| Create a block h3 title

* `attributes` List of attributes
* `children` List of child elements
-}
titleH3 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH3 =
    title Html.h3


{-| Create a block h4 title

* `attributes` List of attributes
* `children` List of child elements
-}
titleH4 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH4 =
    title Html.h4


{-| Create a block h5 title

* `attributes` List of attributes
* `children` List of child elements
-}
titleH5 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH5 =
    title Html.h5


{-| Create a block h6 title

* `attributes` List of attributes
* `children` List of child elements
-}
titleH6 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH6 =
    title Html.h6


title :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> BlockItem msg
title elemFn attributes children =
    elemFn (class "card-title" :: attributes) children
        |> CardInternal.BlockItem



-- Grouping of cards


{-| Use card groups to render cards as a single, attached element with equal width and height columns. Card groups use display: flex; to achieve their uniform sizing.

* `cards` List of [`card configs`](#Config)
-}
group : List (Config msg) -> Html.Html msg
group cards =
    Html.div
        [ class "card-group" ]
        (List.map view cards)


{-| Need a set of equal width and height cards that aren’t attached to one another? Use card decks

* `cards` List of [`card configs`](#Config)
-}
deck : List (Config msg) -> Html.Html msg
deck cards =
    Html.div
        [ class "card-deck" ]
        (List.map view cards)


{-| Cards can be organized into Masonry-like columns with just CSS by wrapping them in .card-columns. Cards are built with CSS column properties instead of flexbox for easier alignment. Cards are ordered from top to bottom and left to right.


* `cards` List of [`card configs`](#Config)
-}
columns : List (Config msg) -> Html.Html msg
columns cards =
    Html.div
        [ class "card-columns" ]
        (List.map view cards)



-- PRIVATE Helpers etc


