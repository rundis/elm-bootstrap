module Bootstrap.Card
    exposing
        ( card
        , cardItem
        , simpleCard
        , simpleCardItem
        , attr
        , blockAttr
        , align
        , roleDanger
        , roleInfo
        , rolePrimary
        , roleSuccess
        , roleWarning
        , outlineDanger
        , outlineInfo
        , outlinePrimary
        , outlineSuccess
        , outlineWarning
        , link
        , text
        , blockQuote
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
        , titleH1
        , titleH2
        , titleH3
        , titleH4
        , titleH5
        , titleH6
        , group
        , deck
        , columns
        , CardOption
        , BlockOption
        , Card
        , CardBlock
        , CardFooter
        , CardHeader
        , CardImageBottom
        , CardImageTop
        , BlockItem
        )

{-| A card is a flexible and extensible content container. It includes options for headers and footers, a wide variety of content, contextual background colors, and powerful display options.


# Cards

@docs Card, simpleCard, card


## Header
@docs CardHeader, header, headerH1, headerH2, headerH2, headerH3, headerH4, headerH5, headerH6

## Footer
@docs CardFooter, footer


## Images
@docs CardImageTop, imgTop, CardImageBottom, imgBottom


## Card options
You can customize the look and feel of your cards using the following options

@docs CardOption, align, rolePrimary, roleSuccess, roleInfo, roleWarning, roleDanger, outlinePrimary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger, attr


# Blocks

@docs CardBlock, BlockItem, block


## Block title
@docs titleH1, titleH2, titleH3, titleH4, titleH5, titleH6


## Misc
@docs link, text, blockQuote, blockAttr

## Block options
@docs BlockOption, blockAlign


# Composing cards
Cards can be composed into
* [`groups`](#group)
* [`decks`](#deck)
* [`columns`](#columns)

@docs group, deck, columns

## Composable card items
@docs cardItem, simpleCardItem



-}

import Html
import Html.Attributes exposing (class)
import Bootstrap.Text as Text
import Bootstrap.Internal.Text as TextInternal


{-| Opaque type representing options for customizing the styling of a card
-}
type CardOption msg
    = Aligned Text.HAlign
    | Roled Role
    | Outlined Role
    | CardAttr (Html.Attribute msg)


{-| Opaque type representing options for styling a card block
-}
type BlockOption msg
    = AlignedBlock Text.HAlign
    | BlockAttr (Html.Attribute msg)


type Role
    = Primary
    | Success
    | Info
    | Warning
    | Danger


{-| Opaque type representing a card that can be composed in

* [`deck`](#deck)
* [`group`](#group)
* [`columns`](#columns)

-}
type Card msg
    = Card (Html.Html msg)


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


{-| Opaque type representing a legal card block child element
-}
type BlockItem msg
    = BlockItem (Html.Html msg)



-- CARD

{-| Option to specify horizonal alignment of card contents
-}
align : Text.HAlign -> CardOption msg
align align =
    Aligned align

{-| Give cards a primary background color and appropriate foreground color -}
rolePrimary : CardOption msg
rolePrimary =
    Roled Primary


{-| Give cards a success background color and appropriate foreground color -}
roleSuccess : CardOption msg
roleSuccess =
    Roled Success


{-| Give cards a info background color and appropriate foreground color -}
roleInfo : CardOption msg
roleInfo =
    Roled Info


{-| Give cards a warning background color and appropriate foreground color -}
roleWarning : CardOption msg
roleWarning =
    Roled Warning


{-| Give cards a danger background color and appropriate foreground color -}
roleDanger : CardOption msg
roleDanger =
    Roled Danger


{-| Give cards a primary colored outline -}
outlinePrimary : CardOption msg
outlinePrimary =
    Outlined Primary


{-| Give cards a success colored outline -}
outlineSuccess : CardOption msg
outlineSuccess =
    Outlined Success


{-| Give cards a info colored outline -}
outlineInfo : CardOption msg
outlineInfo =
    Outlined Info


{-| Give cards a warning colored outline -}
outlineWarning : CardOption msg
outlineWarning =
    Outlined Warning


{-| Give cards a danger colored outline -}
outlineDanger : CardOption msg
outlineDanger =
    Outlined Danger

{-| When you need to customize a card item with std Html.Attribute attributes use this function
-}
attr : Html.Attribute msg -> CardOption msg
attr attr =
    CardAttr attr

{-| Create a card

    Card.card
        { options = [ Card.outlineInfo ]
        , header = Just <| Card.headerH1 [] [ text "My Card Info" ]
        , footer = Just <| Card.footer [] [ text "Some footer" ]
        , imgTop = Nothing
        , imgBottom = Nothing
        , blocks =
            [ Card.block
                { options = []
                , items =
                    [ Card.titleH1 [] [ text "Block title" ]
                    , Card.text [] [ text "Some block content" ]
                    , Card.link [ href "#" ] [ text "MyLink"]
                    ]
                }
            ]
        }
-}
card :
    { options : List (CardOption msg)
    , header : Maybe (CardHeader msg)
    , footer : Maybe (CardFooter msg)
    , imgTop : Maybe (CardImageTop msg)
    , imgBottom : Maybe (CardImageBottom msg)
    , blocks : List (CardBlock msg)
    }
    -> Html.Html msg
card config =
    cardItem config
        |> render

{-| When you just need a simple card use this function that creates a card with a single card block

    Card.simpleCard
        [ Card.roleInfo ]
        [ Card.text [] [ text "An info colored card" ] ]


-}
simpleCard :
    List (CardOption msg)
    -> List (BlockItem msg)
    -> Html.Html msg
simpleCard options items =
    simpleCardItem options items
        |> render


{-| Same as [`simpleCard`](#simpleCard) but used for composing cards in

* [`deck`](#deck)
* [`group`](#group)
* [`columns`](#columns)

-}
simpleCardItem :
    List (CardOption msg)
    -> List (BlockItem msg)
    -> Card msg
simpleCardItem options items =
    Html.div
        (class "card-block" :: cardAttributes options)
        (List.map (\(BlockItem e) -> e) items)
        |> Card



{-| Same as [`card`](#card) but used for composing cards in

* [`deck`](#deck)
* [`group`](#group)
* [`columns`](#columns)

-}
cardItem :
    { options : List (CardOption msg)
    , header : Maybe (CardHeader msg)
    , footer : Maybe (CardFooter msg)
    , imgTop : Maybe (CardImageTop msg)
    , imgBottom : Maybe (CardImageBottom msg)
    , blocks : List (CardBlock msg)
    }
    -> Card msg
cardItem { options, header, footer, imgTop, imgBottom, blocks } =
    Html.div
        (cardAttributes options)
        (List.filterMap
            identity
            [ Maybe.map (\(CardHeader e) -> e) header
            , Maybe.map (\(CardImageTop e) -> e) imgTop
            ]
            ++ (List.map (\(CardBlock e) -> e) blocks)
            ++ List.filterMap
                identity
                [ Maybe.map (\(CardFooter e) -> e) footer
                , Maybe.map (\(CardImageBottom e) -> e) imgBottom
                ]
        )
        |> Card


render : Card msg -> Html.Html msg
render (Card element) =
    element

{-| Create a img element to be shown at the top of a card

* `attributes` List of attributes
* `children` List of child elements
-}
imgTop : List (Html.Attribute msg) -> List (Html.Html msg) -> CardImageTop msg
imgTop attributes children =
    Html.img
        ([ class "card-img-top" ] ++ attributes)
        children
        |> CardImageTop


{-| Create a img element to be shown at the bottom of a card

* `attributes` List of attributes
* `children` List of child elements
-}
imgBottom : List (Html.Attribute msg) -> List (Html.Html msg) -> CardImageBottom msg
imgBottom attributes children =
    Html.img
        ([ class "card-img-bottom" ] ++ attributes)
        children
        |> CardImageBottom



{-| Create a card header element

* `attributes` List of attributes
* `children` List of child elements
-}
header : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
header =
    headerPrivate Html.div


{-| Create a card footer element

* `attributes` List of attributes
* `children` List of child elements
-}
footer : List (Html.Attribute msg) -> List (Html.Html msg) -> CardFooter msg
footer attributes children =
    Html.div
        (class "card-footer" :: attributes)
        children
        |> CardFooter


{-| Create a card h1 header

* `attributes` List of attributes
* `children` List of child elements
-}
headerH1 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH1 =
    headerPrivate Html.h1

{-| Create a card h2 header

* `attributes` List of attributes
* `children` List of child elements
-}
headerH2 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH2 =
    headerPrivate Html.h2


{-| Create a card h3 header

* `attributes` List of attributes
* `children` List of child elements
-}
headerH3 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH3 =
    headerPrivate Html.h3


{-| Create a card h4 header

* `attributes` List of attributes
* `children` List of child elements
-}
headerH4 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH4 =
    headerPrivate Html.h4


{-| Create a card h5 header

* `attributes` List of attributes
* `children` List of child elements
-}
headerH5 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH5 =
    headerPrivate Html.h5


{-| Create a card h6 header

* `attributes` List of attributes
* `children` List of child elements
-}
headerH6 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH6 =
    headerPrivate Html.h6


headerPrivate :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> CardHeader msg
headerPrivate elemFn attributes children =
    elemFn (class "card-header" :: attributes) children
        |> CardHeader



-- Block level stuff

{-| Option to specify horizontal alignment of a card block item

    Card.blockAlign TextXsCenter

-}
blockAlign : Text.HAlign -> BlockOption msg
blockAlign align =
    AlignedBlock align


{-| When you need to customize a block item with std Html.Attribute attributes use this function
-}
blockAttr : Html.Attribute msg -> BlockOption msg
blockAttr attr =
    BlockAttr attr


{-| The building block of a card is the card block. Use it whenever you need a padded section within a card.

    Card.block
        { options = [ Card.blockAlign Text.alignXsRight ]
        , children = [ Card.text [] [ text "Hello inside block" ] ]
        }
-}
block :
    List (BlockOption msg)
    -> List (BlockItem msg)
    -> CardBlock msg
block options items =
    Html.div
        (blockAttributes options)
        (List.map (\(BlockItem e) -> e) items)
        |> CardBlock


{-| Create link elements that are placed next to each other in a block using this function

* `attributes` List of attributes
* `children` List of child elements
-}
link : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
link attributes children =
    Html.a
        ([ class "card-link" ] ++ attributes)
        children
        |> BlockItem


{-| Create a card text element

* `attributes` List of attributes
* `children` List of child elements
-}
text : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
text attributes children =
    Html.p
        ([ class "card-text" ] ++ attributes)
        children
        |> BlockItem


{-| Create a block quote element

* `attributes` List of attributes
* `children` List of child elements
-}
blockQuote : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
blockQuote attributes children =
    Html.blockquote
        ([ class "card-blockquote" ] ++ attributes)
        children
        |> BlockItem


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
        |> BlockItem



-- Grouping of cards

{-| Use card groups to render cards as a single, attached element with equal width and height columns. Card groups use display: flex; to achieve their uniform sizing.

* `cards` List of [`cards`](#cardItem)
-}
group : List (Card msg) -> Html.Html msg
group cards =
    Html.div
        [ class "card-group" ]
        (List.map render cards)


{-| Need a set of equal width and height cards that aren’t attached to one another? Use card decks

* `cards` List of [`cards`](#cardItem)
-}
deck : List (Card msg) -> Html.Html msg
deck cards =
    Html.div
        [ class "card-deck" ]
        (List.map render cards)


{-| Cards can be organized into Masonry-like columns with just CSS by wrapping them in .card-columns. Cards are built with CSS column properties instead of flexbox for easier alignment. Cards are ordered from top to bottom and left to right.


* `cards` List of [`cards`](#cardItem)
-}
columns : List (Card msg) -> Html.Html msg
columns cards =
    Html.div
        [ class "card-columns" ]
        (List.map render cards)



-- PRIVATE Helpers etc


cardAttributes : List (CardOption msg) -> List (Html.Attribute msg)
cardAttributes options =
    class "card" :: List.map cardAttribute options


cardAttribute : CardOption msg -> Html.Attribute msg
cardAttribute option =
    case option of
        Aligned align ->
            TextInternal.textAlignClass align

        Roled role ->
            class <| "card-inverse card-" ++ roleOption role

        Outlined role ->
            class <| "card-outline-" ++ roleOption role


        CardAttr attr ->
            attr


blockAttributes : List (BlockOption msg) -> List (Html.Attribute msg)
blockAttributes options =
    class "card-block" :: List.map blockAttribute options



blockAttribute : BlockOption msg -> Html.Attribute msg
blockAttribute option =
    case option of
        AlignedBlock align ->
            TextInternal.textAlignClass align

        BlockAttr attr ->
            attr


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
