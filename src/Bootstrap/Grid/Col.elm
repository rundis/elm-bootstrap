module Bootstrap.Grid.Col exposing (..)

{-| Functions for creating grid column options.

# Vertical alignment
@docs topXs, topSm, topMd, topLg, topXl, middleXs, middleSm, middleMd, middleLg, middleXl, bottomXs, bottomSm, bottomMd, bottomLg, bottomXl

# Sizing

## Extra Small
@docs xs, xs1, xs2, xs3, xs4, xs5, xs6, xs7, xs8, xs9, xs10, xs11, xs12, xsAuto


## Small
@docs sm, sm1, sm2, sm3, sm4, sm5, sm6, sm7, sm8, sm9, sm10, sm11, sm12, smAuto


## Medium
@docs md, md1, md2, md3, md4, md5, md6, md7, md8, md9, md10, md11, md12, mdAuto


## Large
@docs lg, lg1, lg2, lg3, lg4, lg5, lg6, lg7, lg8, lg9, lg10, lg11, lg12, lgAuto


## Extra Large
@docs xl, xl1, xl2, xl3, xl4, xl5, xl6, xl7, xl8, xl9, xl10, xl11, xl12, xlAuto


# Offsets

## Extra Small
@docs offsetXs1, offsetXs2, offsetXs3, offsetXs4, offsetXs5, offsetXs6, offsetXs7, offsetXs8, offsetXs9, offsetXs10, offsetXs11

## Small
@docs offsetSm0, offsetSm1, offsetSm2, offsetSm3, offsetSm4, offsetSm5, offsetSm6, offsetSm7, offsetSm8, offsetSm9, offsetSm10, offsetSm11


## Medium
@docs offsetMd0, offsetMd1, offsetMd2, offsetMd3, offsetMd4, offsetMd5, offsetMd6, offsetMd7, offsetMd8, offsetMd9, offsetMd10, offsetMd11


## Large
@docs offsetLg0, offsetLg1, offsetLg2, offsetLg3, offsetLg4, offsetLg5, offsetLg6, offsetLg7, offsetLg8, offsetLg9, offsetLg10, offsetLg11


## Extra Large
@docs offsetXl0, offsetXl1, offsetXl2, offsetXl3, offsetXl4, offsetXl5, offsetXl6, offsetXl7, offsetXl8, offsetXl9, offsetXl10, offsetXl11


# Pulls

## Extra Small
@docs pullXs0, pullXs1, pullXs2, pullXs3, pullXs4, pullXs5, pullXs6, pullXs7, pullXs8, pullXs9, pullXs10, pullXs11, pullXs12


## Small
@docs pullSm0, pullSm1, pullSm2, pullSm3, pullSm4, pullSm5, pullSm6, pullSm7, pullSm8, pullSm9, pullSm10, pullSm11, pullSm12

## Medium
@docs pullMd0, pullMd1, pullMd2, pullMd3, pullMd4, pullMd5, pullMd6, pullMd7, pullMd8, pullMd9, pullMd10, pullMd11, pullMd12

## Large
@docs pullLg0, pullLg1, pullLg2, pullLg3, pullLg4, pullLg5, pullLg6, pullLg7, pullLg8, pullLg9, pullLg10, pullLg11, pullLg12


## Extra Large
@docs pullXl0, pullXl1, pullXl2, pullXl3, pullXl4, pullXl5, pullXl6, pullXl7, pullXl8, pullXl9, pullXl10, pullXl11, pullXl12


# Pushes

## Extra Small
@docs pushXs0, pushXs1, pushXs2, pushXs3, pushXs4, pushXs5, pushXs6, pushXs7, pushXs8, pushXs9, pushXs10, pushXs11, pushXs12


## Small
@docs pushSm0, pushSm1, pushSm2, pushSm3, pushSm4, pushSm5, pushSm6, pushSm7, pushSm8, pushSm9, pushSm10, pushSm11, pushSm12

## Medium
@docs pushMd0, pushMd1, pushMd2, pushMd3, pushMd4, pushMd5, pushMd6, pushMd7, pushMd8, pushMd9, pushMd10, pushMd11, pushMd12

## Large
@docs pushLg0, pushLg1, pushLg2, pushLg3, pushLg4, pushLg5, pushLg6, pushLg7, pushLg8, pushLg9, pushLg10, pushLg11, pushLg12


## Extra Large
@docs pushXl0, pushXl1, pushXl2, pushXl3, pushXl4, pushXl5, pushXl6, pushXl7, pushXl8, pushXl9, pushXl10, pushXl11, pushXl12





# Misc
@docs attrs, Option

-}

import Html
import Bootstrap.Grid.Internal as Internal exposing (..)


{-| Opaque type representing valid Column options
-}
type alias Option msg =
    Internal.ColOption msg


{-| Use this function when you need to provide custom Html attributes to the column container element.
-}
attrs : List (Html.Attribute msg) -> ColOption msg
attrs attrs =
    ColAttrs attrs



{- *********** Aligns ******************* -}


{-| -}
topXs : Option msg
topXs =
    colVAlign XS Top


{-| -}
topSm : Option msg
topSm =
    colVAlign SM Top


{-| -}
topMd : Option msg
topMd =
    colVAlign MD Top


{-| -}
topLg : Option msg
topLg =
    colVAlign LG Top


{-| -}
topXl : Option msg
topXl =
    colVAlign XL Top


{-| -}
middleXs : Option msg
middleXs =
    colVAlign XS Middle


{-| -}
middleSm : Option msg
middleSm =
    colVAlign SM Middle


{-| -}
middleMd : Option msg
middleMd =
    colVAlign MD Middle


{-| -}
middleLg : Option msg
middleLg =
    colVAlign LG Middle


{-| -}
middleXl : Option msg
middleXl =
    colVAlign XL Middle


{-| -}
bottomXs : Option msg
bottomXs =
    colVAlign XS Bottom


{-| -}
bottomSm : Option msg
bottomSm =
    colVAlign SM Bottom


{-| -}
bottomMd : Option msg
bottomMd =
    colVAlign MD Bottom


{-| -}
bottomLg : Option msg
bottomLg =
    colVAlign LG Bottom


{-| -}
bottomXl : Option msg
bottomXl =
    colVAlign XL Bottom



{- *********** widths ******************** -}
-- XS widths


{-| -}
xs : Option msg
xs =
    width XS Col


{-| -}
xs1 : Option msg
xs1 =
    width XS Col1


{-| -}
xs2 : Option msg
xs2 =
    width XS Col2


{-| -}
xs3 : Option msg
xs3 =
    width XS Col3


{-| -}
xs4 : Option msg
xs4 =
    width XS Col4


{-| -}
xs5 : Option msg
xs5 =
    width XS Col5


{-| -}
xs6 : Option msg
xs6 =
    width XS Col6


{-| -}
xs7 : Option msg
xs7 =
    width XS Col7


{-| -}
xs8 : Option msg
xs8 =
    width XS Col8


{-| -}
xs9 : Option msg
xs9 =
    width XS Col9


{-| -}
xs10 : Option msg
xs10 =
    width XS Col10


{-| -}
xs11 : Option msg
xs11 =
    width XS Col11


{-| -}
xs12 : Option msg
xs12 =
    width XS Col12


{-| -}
xsAuto : Option msg
xsAuto =
    width XS ColAuto



-- SM widths


{-| -}
sm : Option msg
sm =
    width SM Col


{-| -}
sm1 : Option msg
sm1 =
    width SM Col1


{-| -}
sm2 : Option msg
sm2 =
    width SM Col2


{-| -}
sm3 : Option msg
sm3 =
    width SM Col3


{-| -}
sm4 : Option msg
sm4 =
    width SM Col4


{-| -}
sm5 : Option msg
sm5 =
    width SM Col5


{-| -}
sm6 : Option msg
sm6 =
    width SM Col6


{-| -}
sm7 : Option msg
sm7 =
    width SM Col7


{-| -}
sm8 : Option msg
sm8 =
    width SM Col8


{-| -}
sm9 : Option msg
sm9 =
    width SM Col9


{-| -}
sm10 : Option msg
sm10 =
    width SM Col10


{-| -}
sm11 : Option msg
sm11 =
    width SM Col11


{-| -}
sm12 : Option msg
sm12 =
    width SM Col12


{-| -}
smAuto : Option msg
smAuto =
    width XS ColAuto



-- MD widths


{-| -}
md : Option msg
md =
    width MD Col


{-| -}
md1 : Option msg
md1 =
    width MD Col1


{-| -}
md2 : Option msg
md2 =
    width MD Col2


{-| -}
md3 : Option msg
md3 =
    width MD Col3


{-| -}
md4 : Option msg
md4 =
    width MD Col4


{-| -}
md5 : Option msg
md5 =
    width MD Col5


{-| -}
md6 : Option msg
md6 =
    width MD Col6


{-| -}
md7 : Option msg
md7 =
    width MD Col7


{-| -}
md8 : Option msg
md8 =
    width MD Col8


{-| -}
md9 : Option msg
md9 =
    width MD Col9


{-| -}
md10 : Option msg
md10 =
    width MD Col10


{-| -}
md11 : Option msg
md11 =
    width MD Col11


{-| -}
md12 : Option msg
md12 =
    width MD Col12


{-| -}
mdAuto : Option msg
mdAuto =
    width MD ColAuto



-- LG widths


{-| -}
lg : Option msg
lg =
    width LG Col


{-| -}
lg1 : Option msg
lg1 =
    width LG Col1


{-| -}
lg2 : Option msg
lg2 =
    width LG Col2


{-| -}
lg3 : Option msg
lg3 =
    width LG Col3


{-| -}
lg4 : Option msg
lg4 =
    width LG Col4


{-| -}
lg5 : Option msg
lg5 =
    width LG Col5


{-| -}
lg6 : Option msg
lg6 =
    width LG Col6


{-| -}
lg7 : Option msg
lg7 =
    width LG Col7


{-| -}
lg8 : Option msg
lg8 =
    width LG Col8


{-| -}
lg9 : Option msg
lg9 =
    width LG Col9


{-| -}
lg10 : Option msg
lg10 =
    width LG Col10


{-| -}
lg11 : Option msg
lg11 =
    width LG Col11


{-| -}
lg12 : Option msg
lg12 =
    width LG Col12


{-| -}
lgAuto : Option msg
lgAuto =
    width LG ColAuto



-- XL widths


{-| -}
xl : Option msg
xl =
    width XL Col


{-| -}
xl1 : Option msg
xl1 =
    width XL Col1


{-| -}
xl2 : Option msg
xl2 =
    width XL Col2


{-| -}
xl3 : Option msg
xl3 =
    width XL Col3


{-| -}
xl4 : Option msg
xl4 =
    width XL Col4


{-| -}
xl5 : Option msg
xl5 =
    width XL Col5


{-| -}
xl6 : Option msg
xl6 =
    width XL Col6


{-| -}
xl7 : Option msg
xl7 =
    width XL Col7


{-| -}
xl8 : Option msg
xl8 =
    width XL Col8


{-| -}
xl9 : Option msg
xl9 =
    width XL Col9


{-| -}
xl10 : Option msg
xl10 =
    width XL Col10


{-| -}
xl11 : Option msg
xl11 =
    width XL Col11


{-| -}
xl12 : Option msg
xl12 =
    width XL Col12


{-| -}
xlAuto : Option msg
xlAuto =
    width XL ColAuto



{- *************** OFFSETS ******************** -}
-- XS Offsets


{-| -}
offsetXs1 : Option msg
offsetXs1 =
    offset XS Offset1


{-| -}
offsetXs2 : Option msg
offsetXs2 =
    offset XS Offset2


{-| -}
offsetXs3 : Option msg
offsetXs3 =
    offset XS Offset3


{-| -}
offsetXs4 : Option msg
offsetXs4 =
    offset XS Offset4


{-| -}
offsetXs5 : Option msg
offsetXs5 =
    offset XS Offset5


{-| -}
offsetXs6 : Option msg
offsetXs6 =
    offset XS Offset6


{-| -}
offsetXs7 : Option msg
offsetXs7 =
    offset XS Offset7


{-| -}
offsetXs8 : Option msg
offsetXs8 =
    offset XS Offset8


{-| -}
offsetXs9 : Option msg
offsetXs9 =
    offset XS Offset9


{-| -}
offsetXs10 : Option msg
offsetXs10 =
    offset XS Offset10


{-| -}
offsetXs11 : Option msg
offsetXs11 =
    offset XS Offset11



-- SM Offsets


{-| -}
offsetSm0 : Option msg
offsetSm0 =
    offset SM Offset0


{-| -}
offsetSm1 : Option msg
offsetSm1 =
    offset SM Offset1


{-| -}
offsetSm2 : Option msg
offsetSm2 =
    offset SM Offset2


{-| -}
offsetSm3 : Option msg
offsetSm3 =
    offset SM Offset3


{-| -}
offsetSm4 : Option msg
offsetSm4 =
    offset SM Offset4


{-| -}
offsetSm5 : Option msg
offsetSm5 =
    offset SM Offset5


{-| -}
offsetSm6 : Option msg
offsetSm6 =
    offset SM Offset6


{-| -}
offsetSm7 : Option msg
offsetSm7 =
    offset SM Offset7


{-| -}
offsetSm8 : Option msg
offsetSm8 =
    offset SM Offset8


{-| -}
offsetSm9 : Option msg
offsetSm9 =
    offset SM Offset9


{-| -}
offsetSm10 : Option msg
offsetSm10 =
    offset SM Offset10


{-| -}
offsetSm11 : Option msg
offsetSm11 =
    offset SM Offset11



-- MD Offsets


{-| -}
offsetMd0 : Option msg
offsetMd0 =
    offset MD Offset0


{-| -}
offsetMd1 : Option msg
offsetMd1 =
    offset MD Offset1


{-| -}
offsetMd2 : Option msg
offsetMd2 =
    offset MD Offset2


{-| -}
offsetMd3 : Option msg
offsetMd3 =
    offset MD Offset3


{-| -}
offsetMd4 : Option msg
offsetMd4 =
    offset MD Offset4


{-| -}
offsetMd5 : Option msg
offsetMd5 =
    offset MD Offset5


{-| -}
offsetMd6 : Option msg
offsetMd6 =
    offset MD Offset6


{-| -}
offsetMd7 : Option msg
offsetMd7 =
    offset MD Offset7


{-| -}
offsetMd8 : Option msg
offsetMd8 =
    offset MD Offset8


{-| -}
offsetMd9 : Option msg
offsetMd9 =
    offset MD Offset9


{-| -}
offsetMd10 : Option msg
offsetMd10 =
    offset MD Offset10


{-| -}
offsetMd11 : Option msg
offsetMd11 =
    offset MD Offset11



-- LG Offsets


{-| -}
offsetLg0 : Option msg
offsetLg0 =
    offset LG Offset0


{-| -}
offsetLg1 : Option msg
offsetLg1 =
    offset LG Offset1


{-| -}
offsetLg2 : Option msg
offsetLg2 =
    offset LG Offset2


{-| -}
offsetLg3 : Option msg
offsetLg3 =
    offset LG Offset3


{-| -}
offsetLg4 : Option msg
offsetLg4 =
    offset LG Offset4


{-| -}
offsetLg5 : Option msg
offsetLg5 =
    offset LG Offset5


{-| -}
offsetLg6 : Option msg
offsetLg6 =
    offset LG Offset6


{-| -}
offsetLg7 : Option msg
offsetLg7 =
    offset LG Offset7


{-| -}
offsetLg8 : Option msg
offsetLg8 =
    offset LG Offset8


{-| -}
offsetLg9 : Option msg
offsetLg9 =
    offset LG Offset9


{-| -}
offsetLg10 : Option msg
offsetLg10 =
    offset LG Offset10


{-| -}
offsetLg11 : Option msg
offsetLg11 =
    offset LG Offset11



-- XL Offsets


{-| -}
offsetXl0 : Option msg
offsetXl0 =
    offset LG Offset0


{-| -}
offsetXl1 : Option msg
offsetXl1 =
    offset XL Offset1


{-| -}
offsetXl2 : Option msg
offsetXl2 =
    offset XL Offset2


{-| -}
offsetXl3 : Option msg
offsetXl3 =
    offset XL Offset3


{-| -}
offsetXl4 : Option msg
offsetXl4 =
    offset XL Offset4


{-| -}
offsetXl5 : Option msg
offsetXl5 =
    offset XL Offset5


{-| -}
offsetXl6 : Option msg
offsetXl6 =
    offset XL Offset6


{-| -}
offsetXl7 : Option msg
offsetXl7 =
    offset XL Offset7


{-| -}
offsetXl8 : Option msg
offsetXl8 =
    offset XL Offset8


{-| -}
offsetXl9 : Option msg
offsetXl9 =
    offset XL Offset9


{-| -}
offsetXl10 : Option msg
offsetXl10 =
    offset XL Offset10


{-| -}
offsetXl11 : Option msg
offsetXl11 =
    offset XL Offset11



{- *********** Pulls ******************** -}
-- XS Pulls


{-| -}
pullXs0 : Option msg
pullXs0 =
    pull XS Move0


{-| -}
pullXs1 : Option msg
pullXs1 =
    pull XS Move1


{-| -}
pullXs2 : Option msg
pullXs2 =
    pull XS Move2


{-| -}
pullXs3 : Option msg
pullXs3 =
    pull XS Move3


{-| -}
pullXs4 : Option msg
pullXs4 =
    pull XS Move4


{-| -}
pullXs5 : Option msg
pullXs5 =
    pull XS Move5


{-| -}
pullXs6 : Option msg
pullXs6 =
    pull XS Move6


{-| -}
pullXs7 : Option msg
pullXs7 =
    pull XS Move7


{-| -}
pullXs8 : Option msg
pullXs8 =
    pull XS Move8


{-| -}
pullXs9 : Option msg
pullXs9 =
    pull XS Move9


{-| -}
pullXs10 : Option msg
pullXs10 =
    pull XS Move10


{-| -}
pullXs11 : Option msg
pullXs11 =
    pull XS Move11


{-| -}
pullXs12 : Option msg
pullXs12 =
    pull XS Move12



-- SM Pulls


{-| -}
pullSm0 : Option msg
pullSm0 =
    pull SM Move0


{-| -}
pullSm1 : Option msg
pullSm1 =
    pull SM Move1


{-| -}
pullSm2 : Option msg
pullSm2 =
    pull SM Move2


{-| -}
pullSm3 : Option msg
pullSm3 =
    pull SM Move3


{-| -}
pullSm4 : Option msg
pullSm4 =
    pull SM Move4


{-| -}
pullSm5 : Option msg
pullSm5 =
    pull SM Move5


{-| -}
pullSm6 : Option msg
pullSm6 =
    pull SM Move6


{-| -}
pullSm7 : Option msg
pullSm7 =
    pull SM Move7


{-| -}
pullSm8 : Option msg
pullSm8 =
    pull SM Move8


{-| -}
pullSm9 : Option msg
pullSm9 =
    pull SM Move9


{-| -}
pullSm10 : Option msg
pullSm10 =
    pull SM Move10


{-| -}
pullSm11 : Option msg
pullSm11 =
    pull SM Move11


{-| -}
pullSm12 : Option msg
pullSm12 =
    pull SM Move12



-- MD Pulls


{-| -}
pullMd0 : Option msg
pullMd0 =
    pull MD Move0


{-| -}
pullMd1 : Option msg
pullMd1 =
    pull MD Move1


{-| -}
pullMd2 : Option msg
pullMd2 =
    pull MD Move2


{-| -}
pullMd3 : Option msg
pullMd3 =
    pull MD Move3


{-| -}
pullMd4 : Option msg
pullMd4 =
    pull MD Move4


{-| -}
pullMd5 : Option msg
pullMd5 =
    pull MD Move5


{-| -}
pullMd6 : Option msg
pullMd6 =
    pull MD Move6


{-| -}
pullMd7 : Option msg
pullMd7 =
    pull MD Move7


{-| -}
pullMd8 : Option msg
pullMd8 =
    pull MD Move8


{-| -}
pullMd9 : Option msg
pullMd9 =
    pull MD Move9


{-| -}
pullMd10 : Option msg
pullMd10 =
    pull MD Move10


{-| -}
pullMd11 : Option msg
pullMd11 =
    pull MD Move11


{-| -}
pullMd12 : Option msg
pullMd12 =
    pull MD Move12



-- LG Pulls


{-| -}
pullLg0 : Option msg
pullLg0 =
    pull LG Move0


{-| -}
pullLg1 : Option msg
pullLg1 =
    pull LG Move1


{-| -}
pullLg2 : Option msg
pullLg2 =
    pull LG Move2


{-| -}
pullLg3 : Option msg
pullLg3 =
    pull LG Move3


{-| -}
pullLg4 : Option msg
pullLg4 =
    pull LG Move4


{-| -}
pullLg5 : Option msg
pullLg5 =
    pull LG Move5


{-| -}
pullLg6 : Option msg
pullLg6 =
    pull LG Move6


{-| -}
pullLg7 : Option msg
pullLg7 =
    pull LG Move7


{-| -}
pullLg8 : Option msg
pullLg8 =
    pull LG Move8


{-| -}
pullLg9 : Option msg
pullLg9 =
    pull LG Move9


{-| -}
pullLg10 : Option msg
pullLg10 =
    pull LG Move10


{-| -}
pullLg11 : Option msg
pullLg11 =
    pull LG Move11


{-| -}
pullLg12 : Option msg
pullLg12 =
    pull LG Move12



-- XL Pulls


{-| -}
pullXl0 : Option msg
pullXl0 =
    pull XL Move0


{-| -}
pullXl1 : Option msg
pullXl1 =
    pull XL Move1


{-| -}
pullXl2 : Option msg
pullXl2 =
    pull XL Move2


{-| -}
pullXl3 : Option msg
pullXl3 =
    pull XL Move3


{-| -}
pullXl4 : Option msg
pullXl4 =
    pull XL Move4


{-| -}
pullXl5 : Option msg
pullXl5 =
    pull XL Move5


{-| -}
pullXl6 : Option msg
pullXl6 =
    pull XL Move6


{-| -}
pullXl7 : Option msg
pullXl7 =
    pull XL Move7


{-| -}
pullXl8 : Option msg
pullXl8 =
    pull XL Move8


{-| -}
pullXl9 : Option msg
pullXl9 =
    pull XL Move9


{-| -}
pullXl10 : Option msg
pullXl10 =
    pull XL Move10


{-| -}
pullXl11 : Option msg
pullXl11 =
    pull XL Move11


{-| -}
pullXl12 : Option msg
pullXl12 =
    pull XL Move12



{- *********** Pushes ******************** -}
-- XS Pushes


{-| -}
pushXs0 : Option msg
pushXs0 =
    push XS Move0


{-| -}
pushXs1 : Option msg
pushXs1 =
    push XS Move1


{-| -}
pushXs2 : Option msg
pushXs2 =
    push XS Move2


{-| -}
pushXs3 : Option msg
pushXs3 =
    push XS Move3


{-| -}
pushXs4 : Option msg
pushXs4 =
    push XS Move4


{-| -}
pushXs5 : Option msg
pushXs5 =
    push XS Move5


{-| -}
pushXs6 : Option msg
pushXs6 =
    push XS Move6


{-| -}
pushXs7 : Option msg
pushXs7 =
    push XS Move7


{-| -}
pushXs8 : Option msg
pushXs8 =
    push XS Move8


{-| -}
pushXs9 : Option msg
pushXs9 =
    push XS Move9


{-| -}
pushXs10 : Option msg
pushXs10 =
    push XS Move10


{-| -}
pushXs11 : Option msg
pushXs11 =
    push XS Move11


{-| -}
pushXs12 : Option msg
pushXs12 =
    push XS Move12



-- SM Pushes


{-| -}
pushSm0 : Option msg
pushSm0 =
    push SM Move0


{-| -}
pushSm1 : Option msg
pushSm1 =
    push SM Move1


{-| -}
pushSm2 : Option msg
pushSm2 =
    push SM Move2


{-| -}
pushSm3 : Option msg
pushSm3 =
    push SM Move3


{-| -}
pushSm4 : Option msg
pushSm4 =
    push SM Move4


{-| -}
pushSm5 : Option msg
pushSm5 =
    push SM Move5


{-| -}
pushSm6 : Option msg
pushSm6 =
    push SM Move6


{-| -}
pushSm7 : Option msg
pushSm7 =
    push SM Move7


{-| -}
pushSm8 : Option msg
pushSm8 =
    push SM Move8


{-| -}
pushSm9 : Option msg
pushSm9 =
    push SM Move9


{-| -}
pushSm10 : Option msg
pushSm10 =
    push SM Move10


{-| -}
pushSm11 : Option msg
pushSm11 =
    push SM Move11


{-| -}
pushSm12 : Option msg
pushSm12 =
    push SM Move12



-- MD Pushes


{-| -}
pushMd0 : Option msg
pushMd0 =
    push MD Move0


{-| -}
pushMd1 : Option msg
pushMd1 =
    push MD Move1


{-| -}
pushMd2 : Option msg
pushMd2 =
    push MD Move2


{-| -}
pushMd3 : Option msg
pushMd3 =
    push MD Move3


{-| -}
pushMd4 : Option msg
pushMd4 =
    push MD Move4


{-| -}
pushMd5 : Option msg
pushMd5 =
    push MD Move5


{-| -}
pushMd6 : Option msg
pushMd6 =
    push MD Move6


{-| -}
pushMd7 : Option msg
pushMd7 =
    push MD Move7


{-| -}
pushMd8 : Option msg
pushMd8 =
    push MD Move8


{-| -}
pushMd9 : Option msg
pushMd9 =
    push MD Move9


{-| -}
pushMd10 : Option msg
pushMd10 =
    push MD Move10


{-| -}
pushMd11 : Option msg
pushMd11 =
    push MD Move11


{-| -}
pushMd12 : Option msg
pushMd12 =
    push MD Move12



-- LG Pushes


{-| -}
pushLg0 : Option msg
pushLg0 =
    push LG Move0


{-| -}
pushLg1 : Option msg
pushLg1 =
    push LG Move1


{-| -}
pushLg2 : Option msg
pushLg2 =
    push LG Move2


{-| -}
pushLg3 : Option msg
pushLg3 =
    push LG Move3


{-| -}
pushLg4 : Option msg
pushLg4 =
    push LG Move4


{-| -}
pushLg5 : Option msg
pushLg5 =
    push LG Move5


{-| -}
pushLg6 : Option msg
pushLg6 =
    push LG Move6


{-| -}
pushLg7 : Option msg
pushLg7 =
    push LG Move7


{-| -}
pushLg8 : Option msg
pushLg8 =
    push LG Move8


{-| -}
pushLg9 : Option msg
pushLg9 =
    push LG Move9


{-| -}
pushLg10 : Option msg
pushLg10 =
    push LG Move10


{-| -}
pushLg11 : Option msg
pushLg11 =
    push LG Move11


{-| -}
pushLg12 : Option msg
pushLg12 =
    push LG Move12



-- XL Pushes


{-| -}
pushXl0 : Option msg
pushXl0 =
    push XL Move0


{-| -}
pushXl1 : Option msg
pushXl1 =
    push XL Move1


{-| -}
pushXl2 : Option msg
pushXl2 =
    push XL Move2


{-| -}
pushXl3 : Option msg
pushXl3 =
    push XL Move3


{-| -}
pushXl4 : Option msg
pushXl4 =
    push XL Move4


{-| -}
pushXl5 : Option msg
pushXl5 =
    push XL Move5


{-| -}
pushXl6 : Option msg
pushXl6 =
    push XL Move6


{-| -}
pushXl7 : Option msg
pushXl7 =
    push XL Move7


{-| -}
pushXl8 : Option msg
pushXl8 =
    push XL Move8


{-| -}
pushXl9 : Option msg
pushXl9 =
    push XL Move9


{-| -}
pushXl10 : Option msg
pushXl10 =
    push XL Move10


{-| -}
pushXl11 : Option msg
pushXl11 =
    push XL Move11


{-| -}
pushXl12 : Option msg
pushXl12 =
    push XL Move12
