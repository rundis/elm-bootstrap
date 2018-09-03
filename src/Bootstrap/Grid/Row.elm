module Bootstrap.Grid.Row exposing
    ( topXs, topSm, topMd, topLg, topXl, middleXs, middleSm, middleMd, middleLg, middleXl, bottomXs, bottomSm, bottomMd, bottomLg, bottomXl
    , leftXs, leftSm, leftMd, leftLg, leftXl, centerXs, centerSm, centerMd, centerLg, centerXl, rightXs, rightSm, rightMd, rightLg, rightXl, aroundXs, aroundSm, aroundMd, aroundLg, aroundXl, betweenXs, betweenSm, betweenMd, betweenLg, betweenXl
    , attrs, Option
    )

{-| Functions for creating grid row options.


# Vertical alignment

@docs topXs, topSm, topMd, topLg, topXl, middleXs, middleSm, middleMd, middleLg, middleXl, bottomXs, bottomSm, bottomMd, bottomLg, bottomXl


# Horizontal alignment

@docs leftXs, leftSm, leftMd, leftLg, leftXl, centerXs, centerSm, centerMd, centerLg, centerXl, rightXs, rightSm, rightMd, rightLg, rightXl, aroundXs, aroundSm, aroundMd, aroundLg, aroundXl, betweenXs, betweenSm, betweenMd, betweenLg, betweenXl


# Misc

@docs attrs, Option

-}

import Bootstrap.General.Internal exposing (HorizontalAlign(..), ScreenSize(..))
import Bootstrap.Grid.Internal as Internal exposing (..)
import Html


{-| Opaque type representing valid row options
-}
type alias Option msg =
    Internal.RowOption msg


{-| Use this function when you need to add custom Html attributes to the row container element.
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    RowAttrs attrs_



{- *********** Vertical Aligns ******************* -}


{-| -}
topXs : Option msg
topXs =
    rowVAlign XS Top


{-| -}
topSm : Option msg
topSm =
    rowVAlign SM Top


{-| -}
topMd : Option msg
topMd =
    rowVAlign MD Top


{-| -}
topLg : Option msg
topLg =
    rowVAlign LG Top


{-| -}
topXl : Option msg
topXl =
    rowVAlign XL Top


{-| -}
middleXs : Option msg
middleXs =
    rowVAlign XS Middle


{-| -}
middleSm : Option msg
middleSm =
    rowVAlign SM Middle


{-| -}
middleMd : Option msg
middleMd =
    rowVAlign MD Middle


{-| -}
middleLg : Option msg
middleLg =
    rowVAlign LG Middle


{-| -}
middleXl : Option msg
middleXl =
    rowVAlign XL Middle


{-| -}
bottomXs : Option msg
bottomXs =
    rowVAlign XS Bottom


{-| -}
bottomSm : Option msg
bottomSm =
    rowVAlign SM Bottom


{-| -}
bottomMd : Option msg
bottomMd =
    rowVAlign MD Bottom


{-| -}
bottomLg : Option msg
bottomLg =
    rowVAlign LG Bottom


{-| -}
bottomXl : Option msg
bottomXl =
    rowVAlign XL Bottom



{- ****************** Horizontal aligns ***************** -}


{-| -}
leftXs : Option msg
leftXs =
    rowHAlign XS Left


{-| -}
leftSm : Option msg
leftSm =
    rowHAlign SM Left


{-| -}
leftMd : Option msg
leftMd =
    rowHAlign MD Left


{-| -}
leftLg : Option msg
leftLg =
    rowHAlign LG Left


{-| -}
leftXl : Option msg
leftXl =
    rowHAlign XL Left


{-| -}
centerXs : Option msg
centerXs =
    rowHAlign XS Center


{-| -}
centerSm : Option msg
centerSm =
    rowHAlign SM Center


{-| -}
centerMd : Option msg
centerMd =
    rowHAlign MD Center


{-| -}
centerLg : Option msg
centerLg =
    rowHAlign LG Center


{-| -}
centerXl : Option msg
centerXl =
    rowHAlign XL Center


{-| -}
rightXs : Option msg
rightXs =
    rowHAlign XS Right


{-| -}
rightSm : Option msg
rightSm =
    rowHAlign SM Right


{-| -}
rightMd : Option msg
rightMd =
    rowHAlign MD Right


{-| -}
rightLg : Option msg
rightLg =
    rowHAlign LG Right


{-| -}
rightXl : Option msg
rightXl =
    rowHAlign XL Right


{-| -}
aroundXs : Option msg
aroundXs =
    rowHAlign XS Around


{-| -}
aroundSm : Option msg
aroundSm =
    rowHAlign SM Around


{-| -}
aroundMd : Option msg
aroundMd =
    rowHAlign MD Around


{-| -}
aroundLg : Option msg
aroundLg =
    rowHAlign LG Around


{-| -}
aroundXl : Option msg
aroundXl =
    rowHAlign XL Around


{-| -}
betweenXs : Option msg
betweenXs =
    rowHAlign XS Between


{-| -}
betweenSm : Option msg
betweenSm =
    rowHAlign SM Between


{-| -}
betweenMd : Option msg
betweenMd =
    rowHAlign MD Between


{-| -}
betweenLg : Option msg
betweenLg =
    rowHAlign LG Between


{-| -}
betweenXl : Option msg
betweenXl =
    rowHAlign XL Between
