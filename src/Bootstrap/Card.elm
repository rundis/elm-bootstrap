module Bootstrap.Card
    exposing
        ( card
        , simpleCard
        , render
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
        , Role
        , CardOption
        , BlockOption
        , Card
        , CardBlock
        , CardFooter
        , CardHeader
        , CardImageBottom
        , CardImageTop
        )

import Html
import Html.Attributes exposing (class)
import Bootstrap.Text as Text
import Bootstrap.Internal.Text as TextInternal


type CardOption
    = Aligned Text.HAlign
    | Roled Role
    | Outlined Role


type BlockOption
    = AlignedBlock Text.HAlign


type Role
    = Primary
    | Success
    | Info
    | Warning
    | Danger


type Card msg
    = Card (Html.Html msg)


type CardHeader msg
    = CardHeader (Html.Html msg)


type CardFooter msg
    = CardFooter (Html.Html msg)


type CardImageTop msg
    = CardImageTop (Html.Html msg)


type CardImageBottom msg
    = CardImageBottom (Html.Html msg)


type CardBlock msg
    = CardBlock (Html.Html msg)


type BlockItem msg
    = BlockItem (Html.Html msg)



-- CARD


align : Text.HAlign -> CardOption
align align =
    Aligned align


rolePrimary : CardOption
rolePrimary =
    Roled Primary


roleSuccess : CardOption
roleSuccess =
    Roled Success


roleInfo : CardOption
roleInfo =
    Roled Info


roleWarning : CardOption
roleWarning =
    Roled Warning


roleDanger : CardOption
roleDanger =
    Roled Danger


outlinePrimary : CardOption
outlinePrimary =
    Outlined Primary


outlineSuccess : CardOption
outlineSuccess =
    Outlined Success


outlineInfo : CardOption
outlineInfo =
    Outlined Info


outlineWarning : CardOption
outlineWarning =
    Outlined Warning


outlineDanger : CardOption
outlineDanger =
    Outlined Danger


card :
    { options : List CardOption
    , header : Maybe (CardHeader msg)
    , footer : Maybe (CardFooter msg)
    , imgTop : Maybe (CardImageTop msg)
    , imgBottom : Maybe (CardImageBottom msg)
    , blocks : List (CardBlock msg)
    }
    -> Card msg
card { options, header, footer, imgTop, imgBottom, blocks } =
    Html.div
        [ class <| cardOptions options ]
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


simpleCard :
    { options : List CardOption
    , items : List (BlockItem msg)
    }
    -> Card msg
simpleCard { options, items } =
    Html.div
        [ class <| cardOptions options ++ " card-block" ]
        (List.map (\(BlockItem e) -> e) items)
        |> Card


render : Card msg -> Html.Html msg
render (Card element) =
    element


imgTop : List (Html.Attribute msg) -> List (Html.Html msg) -> CardImageTop msg
imgTop attributes children =
    Html.img
        ([ class "card-img-top" ] ++ attributes)
        children
        |> CardImageTop


imgBottom : List (Html.Attribute msg) -> List (Html.Html msg) -> CardImageBottom msg
imgBottom attributes children =
    Html.img
        ([ class "card-img-bottom" ] ++ attributes)
        children
        |> CardImageBottom


header : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
header =
    headerPrivate Html.div


footer : List (Html.Attribute msg) -> List (Html.Html msg) -> CardFooter msg
footer attributes children =
    Html.div
        (class "card-footer" :: attributes)
        children
        |> CardFooter


headerH1 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH1 =
    headerPrivate Html.h1


headerH2 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH2 =
    headerPrivate Html.h2


headerH3 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH3 =
    headerPrivate Html.h3


headerH4 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH4 =
    headerPrivate Html.h4


headerH5 : List (Html.Attribute msg) -> List (Html.Html msg) -> CardHeader msg
headerH5 =
    headerPrivate Html.h5


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


blockAlign : Text.HAlign -> BlockOption
blockAlign align =
    AlignedBlock align


block :
    { options : List BlockOption
    , items : List (BlockItem msg)
    }
    -> CardBlock msg
block { options, items } =
    Html.div
        [ class <| blockOptions options ]
        (List.map (\(BlockItem e) -> e) items)
        |> CardBlock


link : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
link attributes children =
    Html.a
        ([ class "card-link" ] ++ attributes)
        children
        |> BlockItem


text : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
text attributes children =
    Html.p
        ([ class "card-text" ] ++ attributes)
        children
        |> BlockItem


blockQuote : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
blockQuote attributes children =
    Html.blockquote
        ([ class "card-blockquote" ] ++ attributes)
        children
        |> BlockItem


titleH1 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH1 =
    title Html.h1


titleH2 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH2 =
    title Html.h2


titleH3 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH3 =
    title Html.h3


titleH4 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH4 =
    title Html.h4


titleH5 : List (Html.Attribute msg) -> List (Html.Html msg) -> BlockItem msg
titleH5 =
    title Html.h5


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


group : List (Card msg) -> Html.Html msg
group cards =
    Html.div
        [ class "card-group" ]
        (List.map render cards)


deck : List (Card msg) -> Html.Html msg
deck cards =
    Html.div
        [ class "card-deck" ]
        (List.map render cards)


columns : List (Card msg) -> Html.Html msg
columns cards =
    Html.div
        [ class "card-columns" ]
        (List.map render cards)



-- PRIVATE Helpers etc


cardOptions : List CardOption -> String
cardOptions options =
    List.foldl
        (\option optionString ->
            String.join " " [ optionString, cardOption option ]
        )
        "card"
        options


cardOption : CardOption -> String
cardOption option =
    case option of
        Aligned align ->
            TextInternal.textAlignOption align

        Roled role ->
            "card-inverse card-" ++ roleOption role

        Outlined role ->
            "card-outline-" ++ roleOption role


blockOptions : List BlockOption -> String
blockOptions options =
    List.foldl
        (\option optionString ->
            String.join " " [ optionString, blockOption option ]
        )
        "card-block"
        options


blockOption : BlockOption -> String
blockOption option =
    case option of
        AlignedBlock align ->
            TextInternal.textAlignOption align


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
