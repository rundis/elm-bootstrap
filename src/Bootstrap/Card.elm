module Bootstrap.Card exposing
    ( view, Config
    , header, headerH1, headerH2, headerH3, headerH4, headerH5, headerH6, Header
    , Footer, footer
    , imgTop, imgBottom, ImageTop, ImageBottom
    , config, align, primary, secondary, success, info, warning, danger, light, dark, outlinePrimary, outlineSecondary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger, outlineLight, outlineDark, textColor, attrs, Option
    , block, listGroup, customListGroup
    , group, deck, columns, keyedGroup, keyedDeck, keyedColumns
    )

{-| A card is a flexible and extensible content container. It includes options for headers and footers, a wide variety of content, contextual background colors, and powerful display options.


# Cards

@docs view, Config


## Header

@docs header, headerH1, headerH2, headerH3, headerH4, headerH5, headerH6, Header


## Footer

@docs Footer, footer


## Images

@docs imgTop, imgBottom, ImageTop, ImageBottom


## Options

You can customize the look and feel of your cards using the following options

@docs config, align, primary, secondary, success, info, warning, danger, light, dark, outlinePrimary, outlineSecondary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger, outlineLight, outlineDark, textColor, attrs, Option


# Blocks

@docs block, listGroup, customListGroup


# Composing cards

Cards can be composed into

  - [`groups`](#group)
  - [`decks`](#deck)
  - [`columns`](#columns)

@docs group, deck, columns, keyedGroup, keyedDeck, keyedColumns

-}

import Bootstrap.Card.Block as Block
import Bootstrap.Card.Internal as Internal
import Bootstrap.Internal.Role as Role
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Text as Text
import Html
import Html.Attributes exposing (class)
import Html.Keyed as Keyed


{-| Opaque type representing options for customizing the styling of a card
-}
type alias Option msg =
    Internal.CardOption msg


{-| Opaque type representing the view configuration of a card

You may use the following functions to expand/change a configuration:

  - [`header`](#header) or [`headerH1`](#headerH1), [`headerH2`](#headerH2) etc
  - [`footer`](#footer)
  - [`block`](#block)
  - [`imgTop`](#imgTop)
  - [`imgBottom`](#imgBottom)

-}
type Config msg
    = Config
        { options : List (Option msg)
        , header : Maybe (Header msg)
        , footer : Maybe (Footer msg)
        , imgTop : Maybe (ImageTop msg)
        , imgBottom : Maybe (ImageBottom msg)
        , blocks : List (Internal.CardBlock msg)
        }


{-| Opaque type representing a card header element
-}
type Header msg
    = Header (Html.Html msg)


{-| Opaque type representing a card footer element
-}
type Footer msg
    = Footer (Html.Html msg)


{-| Opaque type representing a card image placed at the top
-}
type ImageTop msg
    = ImageTop (Html.Html msg)


{-| Opaque type representing a card image placed at the bottom
-}
type ImageBottom msg
    = ImageBottom (Html.Html msg)



-- CARD


{-| Option to specify horizonal alignment of card contents
-}
align : Text.HAlign -> Option msg
align hAlign =
    Internal.Aligned hAlign


{-| Give cards a primary background color
-}
primary : Option msg
primary =
    Internal.Coloring <| Internal.Roled Role.Primary


{-| Give cards a secondary background color
-}
secondary : Option msg
secondary =
    Internal.Coloring <| Internal.Roled Role.Secondary


{-| Give cards a success background color
-}
success : Option msg
success =
    Internal.Coloring <| Internal.Roled Role.Success


{-| Give cards a info background color
-}
info : Option msg
info =
    Internal.Coloring <| Internal.Roled Role.Info


{-| Give cards a warning background color
-}
warning : Option msg
warning =
    Internal.Coloring <| Internal.Roled Role.Warning


{-| Give cards a danger background color
-}
danger : Option msg
danger =
    Internal.Coloring <| Internal.Roled Role.Danger


{-| Give cards a light background color
-}
light : Option msg
light =
    Internal.Coloring <| Internal.Roled Role.Light


{-| Give cards a dark background color
-}
dark : Option msg
dark =
    Internal.Coloring <| Internal.Roled Role.Dark


{-| Give cards a primary colored outline
-}
outlinePrimary : Option msg
outlinePrimary =
    Internal.Coloring <| Internal.Outlined Role.Primary


{-| Give cards a secondary colored outline
-}
outlineSecondary : Option msg
outlineSecondary =
    Internal.Coloring <| Internal.Outlined Role.Secondary


{-| Give cards a success colored outline
-}
outlineSuccess : Option msg
outlineSuccess =
    Internal.Coloring <| Internal.Outlined Role.Success


{-| Give cards a info colored outline
-}
outlineInfo : Option msg
outlineInfo =
    Internal.Coloring <| Internal.Outlined Role.Info


{-| Give cards a warning colored outline
-}
outlineWarning : Option msg
outlineWarning =
    Internal.Coloring <| Internal.Outlined Role.Warning


{-| Give cards a danger colored outline
-}
outlineDanger : Option msg
outlineDanger =
    Internal.Coloring <| Internal.Outlined Role.Danger


{-| Give cards a light colored outline
-}
outlineLight : Option msg
outlineLight =
    Internal.Coloring <| Internal.Outlined Role.Light


{-| Give cards a dark colored outline
-}
outlineDark : Option msg
outlineDark =
    Internal.Coloring <| Internal.Outlined Role.Dark


{-| Set the text color used within a card. |
-}
textColor : Text.Color -> Option msg
textColor color =
    Internal.TextColoring color


{-| When you need to customize a card item with standard Html.Attribute attributes use this function
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    Internal.Attrs attrs_


{-| Template/default config which you use as a starting point to compose your cards.

  - options - List of card wide styling options

-}
config : List (Option msg) -> Config msg
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
            [ Block.titleH1 [] [ text "Block title" ]
            , Block.text [] [ text "Some block content" ]
            , Block.link [ href "#" ] [ text "MyLink" ]
            ]
        |> Card.view

  - config - See [`Config`](#Config) for what items you may compose your cards with

-}
view :
    Config msg
    -> Html.Html msg
view (Config conf) =
    Html.div
        (Internal.cardAttributes conf.options)
        (List.filterMap
            identity
            [ Maybe.map (\(Header e) -> e) conf.header
            , Maybe.map (\(ImageTop e) -> e) conf.imgTop
            ]
            ++ Internal.renderBlocks conf.blocks
            ++ List.filterMap
                identity
                [ Maybe.map (\(Footer e) -> e) conf.footer
                , Maybe.map (\(ImageBottom e) -> e) conf.imgBottom
                ]
        )


{-| Create a <img> element to be shown at the top of a card

  - `attributes` List of attributes
  - `children` List of child elements

-}
imgTop :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
imgTop attributes children (Config conf) =
    Config
        { conf
            | imgTop =
                Html.img
                    ([ class "card-img-top" ] ++ attributes)
                    children
                    |> ImageTop
                    |> Just
        }


{-| Create a <img> element to be shown at the bottom of a card

  - `attributes` List of attributes
  - `children` List of child elements

-}
imgBottom :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
imgBottom attributes children (Config conf) =
    Config
        { conf
            | imgBottom =
                Html.img
                    ([ class "card-img-bottom" ] ++ attributes)
                    children
                    |> ImageBottom
                    |> Just
        }


{-| Create a card header element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

-}
header :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
header =
    headerPrivate Html.div


{-| Create a card footer element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

-}
footer :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
footer attributes children (Config conf) =
    Config
        { conf
            | footer =
                Html.div
                    (class "card-footer" :: attributes)
                    children
                    |> Footer
                    |> Just
        }


{-| Create a card h1 header

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

-}
headerH1 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH1 =
    headerPrivate Html.h1


{-| Create a card h2 header

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

-}
headerH2 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH2 =
    headerPrivate Html.h2


{-| Create a card h3 header

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

-}
headerH3 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH3 =
    headerPrivate Html.h3


{-| Create a card h4 header

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

-}
headerH4 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH4 =
    headerPrivate Html.h4


{-| Create a card h5 header

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

-}
headerH5 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
headerH5 =
    headerPrivate Html.h5


{-| Create a card h6 header

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` A card [`Config`](#Config) that you wish to extend/override

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
headerPrivate elemFn attributes children (Config conf) =
    Config
        { conf
            | header =
                elemFn (class "card-header" :: attributes) children
                    |> Header
                    |> Just
        }


{-| You may add list groups, just like you can add card blocks to a Card.
Use the li function in the ListGroup module to add and configure the list items.
-}
listGroup :
    List (ListGroup.Item msg)
    -> Config msg
    -> Config msg
listGroup items (Config conf) =
    Config
        { conf
            | blocks =
                conf.blocks
                    ++ [ Internal.listGroup items ]
        }


{-| Use this function if you want to use ListGroup.custom
-}
customListGroup :
    List (ListGroup.CustomItem msg)
    -> Config msg
    -> Config msg
customListGroup items (Config conf) =
    Config
        { conf
            | blocks =
                conf.blocks
                    ++ [ Internal.customListGroup items ]
        }


{-| The building block of a card is the card block. Use it whenever you need a padded section within a card.
You may have multiple blocks in a card, this function will add blocks to your Cards.

  - blockOptions - List of Block options to configure block level styling
  - item - List of Block Items
  - `config` A card [`Config`](#Config) that you wish to add a block element to

-}
block :
    List (Block.Option msg)
    -> List (Block.Item msg)
    -> Config msg
    -> Config msg
block options items (Config conf) =
    Config
        { conf
            | blocks =
                conf.blocks
                    ++ [ Internal.block options items ]
        }



-- Grouping of cards


{-| Use card groups to render cards as a single, attached element with equal width and height columns. Card groups use display: flex; to achieve their uniform sizing.

  - `cards` List of [`card configs`](#Config)

-}
group : List (Config msg) -> Html.Html msg
group cards =
    Html.div
        [ class "card-group" ]
        (List.map view cards)


{-| Need a set of equal width and height cards that aren’t attached to one another? Use card decks

  - `cards` List of [`card configs`](#Config)

-}
deck : List (Config msg) -> Html.Html msg
deck cards =
    Html.div
        [ class "card-deck" ]
        (List.map view cards)


{-| Cards can be organized into Masonry-like columns with just CSS by wrapping them in .card-columns. Cards are built with CSS column properties instead of flexbox for easier alignment. Cards are ordered from top to bottom and left to right.

  - `cards` List of [`card configs`](#Config)

-}
columns : List (Config msg) -> Html.Html msg
columns cards =
    Html.div
        [ class "card-columns" ]
        (List.map view cards)


{-| Create a card group with keyed cards.
-}
keyedGroup : List ( String, Config msg ) -> Html.Html msg
keyedGroup =
    keyedMulti "card-group"


{-| Create a card deck with keyed cards.
-}
keyedDeck : List ( String, Config msg ) -> Html.Html msg
keyedDeck =
    keyedMulti "card-deck"


{-| Create card columns with keyed cards.
-}
keyedColumns : List ( String, Config msg ) -> Html.Html msg
keyedColumns =
    keyedMulti "card-columns"


keyedMulti : String -> List ( String, Config msg ) -> Html.Html msg
keyedMulti clazz keyedCards =
    Keyed.node "div"
        [ class clazz ]
        (List.map (\( key, card ) -> ( key, view card )) keyedCards)
