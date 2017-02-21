module Bootstrap.Grid.Row exposing (..)


import Html
import Bootstrap.Grid.Internal as Internal exposing (..)



type alias RowOption msg = Internal.RowOption msg
type alias VAlign = Internal.VAlign
type alias HAlign = Internal.HAlign



attrs : List (Html.Attribute msg) -> RowOption msg
attrs attrs =
    RowAttrs attrs


verticalAlign : VAlign -> RowOption msg
verticalAlign vAlign =
    RowVAligns [ vAlign ]


verticalAligns : List VAlign -> RowOption msg
verticalAligns vAligns =
    RowVAligns vAligns


horisontalAlign : HAlign -> RowOption msg
horisontalAlign hAlign =
    RowHAligns [ hAlign ]


horisontalAligns : List HAlign -> RowOption msg
horisontalAligns hAligns =
    RowHAligns hAligns



{- *********** Vertical Aligns ******************* -}

{-| -}
topXs : VAlign
topXs =
    VAlign XS Top

{-| -}
topSm : VAlign
topSm =
    VAlign SM Top

{-| -}
topMd : VAlign
topMd =
    VAlign MD Top

{-| -}
topLg : VAlign
topLg =
    VAlign LG Top

{-| -}
topXl : VAlign
topXl =
    VAlign XL Top

{-| -}
middleXs : VAlign
middleXs =
    VAlign XS Middle

{-| -}
middleSm : VAlign
middleSm =
    VAlign SM Middle

{-| -}
middleMd : VAlign
middleMd =
    VAlign MD Middle

{-| -}
middleLg : VAlign
middleLg =
    VAlign LG Middle

{-| -}
middleXl : VAlign
middleXl =
    VAlign XL Middle

{-| -}
bottomXs : VAlign
bottomXs =
    VAlign XS Bottom

{-| -}
bottomSm : VAlign
bottomSm =
    VAlign SM Bottom

{-| -}
bottomMd : VAlign
bottomMd =
    VAlign MD Bottom

{-| -}
bottomLg : VAlign
bottomLg =
    VAlign LG Bottom

{-| -}
bottomXl : VAlign
bottomXl =
    VAlign XL Bottom



{- ****************** Horizontal aligns ***************** -}
{-| -}
leftXs : HAlign
leftXs =
    HAlign XS Left

{-| -}
leftSm : HAlign
leftSm =
    HAlign SM Left

{-| -}
leftMd : HAlign
leftMd =
    HAlign MD Left

{-| -}
leftLg : HAlign
leftLg =
    HAlign LG Left

{-| -}
leftXl : HAlign
leftXl =
    HAlign XL Left

{-| -}
centerXs : HAlign
centerXs =
    HAlign XS Center

{-| -}
centerSm : HAlign
centerSm =
    HAlign SM Center

{-| -}
centerMd : HAlign
centerMd =
    HAlign MD Center

{-| -}
centerLg : HAlign
centerLg =
    HAlign LG Center

{-| -}
centerXl : HAlign
centerXl =
    HAlign XL Center

{-| -}
rightXs : HAlign
rightXs =
    HAlign XS Right

{-| -}
rightSm : HAlign
rightSm =
    HAlign SM Right

{-| -}
rightMd : HAlign
rightMd =
    HAlign MD Right

{-| -}
rightLg : HAlign
rightLg =
    HAlign LG Right

{-| -}
rightXl : HAlign
rightXl =
    HAlign XL Right

{-| -}
aroundXs : HAlign
aroundXs =
    HAlign XS Around

{-| -}
aroundSm : HAlign
aroundSm =
    HAlign SM Around

{-| -}
aroundMd : HAlign
aroundMd =
    HAlign MD Around

{-| -}
aroundLg : HAlign
aroundLg =
    HAlign LG Around

{-| -}
aroundXl : HAlign
aroundXl =
    HAlign XL Around

{-| -}
betweenXs : HAlign
betweenXs =
    HAlign XS Between

{-| -}
betweenSm : HAlign
betweenSm =
    HAlign SM Between

{-| -}
betweenMd : HAlign
betweenMd =
    HAlign MD Between

{-| -}
betweenLg : HAlign
betweenLg =
    HAlign LG Between

{-| -}
betweenXl : HAlign
betweenXl =
    HAlign XL Between
