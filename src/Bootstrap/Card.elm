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
@docs header, headerH1, headerH2, headerH2, headerH3, headerH4, headerH5, headerH6, CardHeader

## Footer
@docs CardFooter, footer


## Images
@docs imgTop, imgBottom, CardImageTop, CardImageBottom


## Options
You can customize the look and feel of your cards using the following options

@docs config, align, primary, success, info, warning, danger, outlinePrimary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger, attrs, CardOption


# Blocks
@docs block, CardBlock, BlockItem


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
import Bootstrap.Text as Text
import Bootstrap.Internal.Text as TextInternal


{-| Opaque type representing options for customizing the styling of a card
-}
type CardOption msg
    = Aligned Text.HAlign
    | Coloring RoleOption
    | Attrs (List (Html.Attribute msg))



type RoleOption
    = Roled Role
    | Outlined Role


type alias CardOptions msg =
    { aligned : Maybe Text.HAlign
    , coloring : Maybe RoleOption
    , attributes : List (Html.Attribute msg )
    }


{-| Opaque type representing options for styling a card block
-}
type BlockOption msg
    = AlignedBlock Text.HAlign
    | BlockAttrs (List (Html.Attribute msg))


type alias BlockOptions msg =
    { aligned : Maybe Text.HAlign
    , attributes : List (Html.Attribute msg)
    }


type Role
    = Primary
    | Success
    | Info
    | Warning
    | Danger



{-| Opaque type representing the view configuration of a card

You may use the following functions to expand/change a configuration:
* [`header`](#header) or headerH1, headerh2 etc
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
        , blocks : List (CardBlock msg)
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


{-| Give cards a primary background color and appropriate foreground color
-}
primary : CardOption msg
primary =
    Coloring <| Roled Primary


{-| Give cards a success background color and appropriate foreground color
-}
success : CardOption msg
success =
    Coloring <| Roled Success


{-| Give cards a info background color and appropriate foreground color
-}
info : CardOption msg
info =
    Coloring <| Roled Info


{-| Give cards a warning background color and appropriate foreground color
-}
warning : CardOption msg
warning =
    Coloring <| Roled Warning


{-| Give cards a danger background color and appropriate foreground color
-}
danger : CardOption msg
danger =
    Coloring <| Roled Danger


{-| Give cards a primary colored outline
-}
outlinePrimary : CardOption msg
outlinePrimary =
    Coloring <| Outlined Primary


{-| Give cards a success colored outline
-}
outlineSuccess : CardOption msg
outlineSuccess =
    Coloring <| Outlined Success


{-| Give cards a info colored outline
-}
outlineInfo : CardOption msg
outlineInfo =
    Coloring <| Outlined Info


{-| Give cards a warning colored outline
-}
outlineWarning : CardOption msg
outlineWarning =
    Coloring <| Outlined Warning


{-| Give cards a danger colored outline
-}
outlineDanger : CardOption msg
outlineDanger =
    Coloring <| Outlined Danger


{-| When you need to customize a card item with std Html.Attribute attributes use this function
-}
attrs : List (Html.Attribute msg) -> CardOption msg
attrs attrs =
    Attrs attrs


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


{-| Create a img element to be shown at the top of a card

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


{-| Create a img element to be shown at the bottom of a card

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

    Card.blockAlign TextXsCenter

-}
blockAlign : Text.HAlign -> BlockOption msg
blockAlign align =
    AlignedBlock align


{-| When you need to customize a block item with std Html.Attribute attributes use this function
-}
blockAttrs : List (Html.Attribute msg) -> BlockOption msg
blockAttrs attrs =
    BlockAttrs attrs


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
                    ++ [ Html.div
                            (blockAttributes options)
                            (List.map (\(BlockItem e) -> e) items)
                            |> CardBlock
                       ]
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


{-|  Add a custom HTML element to be displayed in a Card block
-}
custom : Html.Html msg -> BlockItem msg
custom element =
    BlockItem element

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

                Nothing ->
                    []
            )
        ++ ( case options.aligned of
                Just align ->
                    [ TextInternal.textAlignClass align ]

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



blockAttributes : List (BlockOption msg) -> List (Html.Attribute msg)
blockAttributes modifiers =
    let
        options =
            List.foldl applyBlockModifier defaultBlockOptions modifiers
    in
        [ class "card-block" ]
        ++ ( case options.aligned of
                Just align ->
                    [ TextInternal.textAlignClass align ]
                Nothing ->
                    []
          )
        ++ options.attributes


    --class "card-block" :: List.map blockAttribute options



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
