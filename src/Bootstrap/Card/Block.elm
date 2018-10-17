module Bootstrap.Card.Block exposing
    ( titleH1, titleH2, titleH3, titleH4, titleH5, titleH6
    , link, text, quote, custom, Item
    , align, primary, secondary, success, info, warning, danger, light, dark, textColor, attrs, Option
    )

{-| Blocks are the main content elements withing a Card.


# Title

@docs titleH1, titleH2, titleH3, titleH4, titleH5, titleH6


# Items

@docs link, text, quote, custom, Item


# Options

@docs align, primary, secondary, success, info, warning, danger, light, dark, textColor, attrs, Option

-}

import Bootstrap.Card.Internal as Internal
import Bootstrap.Internal.Role as Role
import Bootstrap.Text as Text
import Html
import Html.Attributes exposing (class)


{-| Opaque type representing options for styling a card block
-}
type alias Option msg =
    Internal.BlockOption msg


{-| Opaque type representing a legal card block child element
-}
type alias Item msg =
    Internal.BlockItem msg


{-| Create link elements that are placed next to each other in a block using this function

  - `attributes` List of attributes
  - `children` List of child elements

-}
link : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
link attributes children =
    Html.a
        ([ class "card-link" ] ++ attributes)
        children
        |> Internal.BlockItem


{-| Create a card text element

  - `attributes` List of attributes
  - `children` List of child elements

-}
text : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
text attributes children =
    Html.p
        ([ class "card-text" ] ++ attributes)
        children
        |> Internal.BlockItem


{-| Add a custom HTML element to be displayed in a Card block
-}
custom : Html.Html msg -> Item msg
custom element =
    Internal.BlockItem element


{-| Create a block quote element

  - `attributes` List of attributes
  - `children` List of child elements

-}
quote : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
quote attributes children =
    Html.blockquote
        ([ class "card-blockquote" ] ++ attributes)
        children
        |> Internal.BlockItem


{-| Create a block h1 title

  - `attributes` List of attributes
  - `children` List of child elements

-}
titleH1 : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
titleH1 =
    title Html.h1


{-| Create a block h2 title

  - `attributes` List of attributes
  - `children` List of child elements

-}
titleH2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
titleH2 =
    title Html.h2


{-| Create a block h3 title

  - `attributes` List of attributes
  - `children` List of child elements

-}
titleH3 : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
titleH3 =
    title Html.h3


{-| Create a block h4 title

  - `attributes` List of attributes
  - `children` List of child elements

-}
titleH4 : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
titleH4 =
    title Html.h4


{-| Create a block h5 title

  - `attributes` List of attributes
  - `children` List of child elements

-}
titleH5 : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
titleH5 =
    title Html.h5


{-| Create a block h6 title

  - `attributes` List of attributes
  - `children` List of child elements

-}
titleH6 : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
titleH6 =
    title Html.h6


title :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Item msg
title elemFn attributes children =
    elemFn (class "card-title" :: attributes) children
        |> Internal.BlockItem


{-| Option to specify horizontal alignment of a card block item

    Block.align Text.xs

-}
align : Text.HAlign -> Option msg
align halign =
    Internal.AlignedBlock halign


{-| Give blocks a primary background color
-}
primary : Option msg
primary =
    Internal.BlockColoring Role.Primary


{-| Give blocks a secondary background color
-}
secondary : Option msg
secondary =
    Internal.BlockColoring Role.Secondary


{-| Give blocks a success background color
-}
success : Option msg
success =
    Internal.BlockColoring Role.Success


{-| Give blocks a info background color
-}
info : Option msg
info =
    Internal.BlockColoring Role.Info


{-| Give blocks a warning background color
-}
warning : Option msg
warning =
    Internal.BlockColoring Role.Warning


{-| Give blocks a danger background color
-}
danger : Option msg
danger =
    Internal.BlockColoring Role.Danger


{-| Give blocks a light background color
-}
light : Option msg
light =
    Internal.BlockColoring Role.Light


{-| Give blocks a dark background color
-}
dark : Option msg
dark =
    Internal.BlockColoring Role.Dark


{-| Set the text color used within a block. |
-}
textColor : Text.Color -> Option msg
textColor color =
    Internal.BlockTextColoring color


{-| When you need to customize a block item with standard Html.Attribute attributes use this function
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    Internal.BlockAttrs attrs_
