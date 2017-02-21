module Bootstrap.Grid.Col exposing
    (..)


import Html
import Bootstrap.Grid.Internal as Internal exposing (..)


type alias ColOption msg = Internal.ColOption msg
type alias Width = Internal.Width
type alias Offset = Internal.Offset
type alias Pull = Internal.Pull
type alias Push = Internal.Push
type alias VAlign = Internal.VAlign


attrs : List (Html.Attribute msg) -> ColOption msg
attrs attrs =
    ColAttrs attrs



width : Width -> ColOption msg
width width =
    Widths [width]

widths : List Width -> ColOption msg
widths widths =
    Widths widths


offset : Offset -> ColOption msg
offset offset =
    Offsets [ offset ]

offsets : List Offset -> ColOption msg
offsets offsets =
    Offsets offsets


pull : Pull -> ColOption msg
pull pull =
    Pulls [pull]

pulls : List Pull -> ColOption msg
pulls pulls =
    Pulls pulls


push : Push -> ColOption msg
push push =
    Pushes [ push ]

pushes : List Push -> ColOption msg
pushes pushes =
    Pushes pushes

align : VAlign -> ColOption msg
align align =
    ColAligns [ align ]

aligns : List VAlign -> ColOption msg
aligns aligns =
    ColAligns aligns



{- *********** Aligns ******************* -}

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



{- *********** Widths ******************** -}
-- XS Widths


{-| -}
xs : Width
xs =
    Width XS Col


{-| -}
xs1 : Width
xs1 =
    Width XS Col1


{-| -}
xs2 : Width
xs2 =
    Width XS Col2


{-| -}
xs3 : Width
xs3 =
    Width XS Col3


{-| -}
xs4 : Width
xs4 =
    Width XS Col4


{-| -}
xs5 : Width
xs5 =
    Width XS Col5


{-| -}
xs6 : Width
xs6 =
    Width XS Col6


{-| -}
xs7 : Width
xs7 =
    Width XS Col7


{-| -}
xs8 : Width
xs8 =
    Width XS Col8


{-| -}
xs9 : Width
xs9 =
    Width XS Col9


{-| -}
xs10 : Width
xs10 =
    Width XS Col10


{-| -}
xs11 : Width
xs11 =
    Width XS Col11


{-| -}
xs12 : Width
xs12 =
    Width XS Col12


{-| -}
xsAuto : Width
xsAuto =
    Width XS ColAuto



-- SM Widths


{-| -}
sm : Width
sm =
    Width SM Col


{-| -}
sm1 : Width
sm1 =
    Width SM Col1


{-| -}
sm2 : Width
sm2 =
    Width SM Col2


{-| -}
sm3 : Width
sm3 =
    Width SM Col3


{-| -}
sm4 : Width
sm4 =
    Width SM Col4


{-| -}
sm5 : Width
sm5 =
    Width SM Col5


{-| -}
sm6 : Width
sm6 =
    Width SM Col6


{-| -}
sm7 : Width
sm7 =
    Width SM Col7


{-| -}
sm8 : Width
sm8 =
    Width SM Col8


{-| -}
sm9 : Width
sm9 =
    Width SM Col9


{-| -}
sm10 : Width
sm10 =
    Width SM Col10


{-| -}
sm11 : Width
sm11 =
    Width SM Col11


{-| -}
sm12 : Width
sm12 =
    Width SM Col12


{-| -}
smAuto : Width
smAuto =
    Width XS ColAuto


-- MD Widths


{-| -}
md : Width
md =
    Width MD Col


{-| -}
md1 : Width
md1 =
    Width MD Col1


{-| -}
md2 : Width
md2 =
    Width MD Col2


{-| -}
md3 : Width
md3 =
    Width MD Col3


{-| -}
md4 : Width
md4 =
    Width MD Col4


{-| -}
md5 : Width
md5 =
    Width MD Col5


{-| -}
md6 : Width
md6 =
    Width MD Col6


{-| -}
md7 : Width
md7 =
    Width MD Col7


{-| -}
md8 : Width
md8 =
    Width MD Col8


{-| -}
md9 : Width
md9 =
    Width MD Col9


{-| -}
md10 : Width
md10 =
    Width MD Col10


{-| -}
md11 : Width
md11 =
    Width MD Col11


{-| -}
md12 : Width
md12 =
    Width MD Col12


{-| -}
mdAuto : Width
mdAuto =
    Width XS ColAuto


-- LG Widths


{-| -}
lg : Width
lg =
    Width LG Col


{-| -}
lg1 : Width
lg1 =
    Width LG Col1


{-| -}
lg2 : Width
lg2 =
    Width LG Col2


{-| -}
lg3 : Width
lg3 =
    Width LG Col3


{-| -}
lg4 : Width
lg4 =
    Width LG Col4


{-| -}
lg5 : Width
lg5 =
    Width LG Col5


{-| -}
lg6 : Width
lg6 =
    Width LG Col6


{-| -}
lg7 : Width
lg7 =
    Width LG Col7


{-| -}
lg8 : Width
lg8 =
    Width LG Col8


{-| -}
lg9 : Width
lg9 =
    Width LG Col9


{-| -}
lg10 : Width
lg10 =
    Width LG Col10


{-| -}
lg11 : Width
lg11 =
    Width LG Col11


{-| -}
lg12 : Width
lg12 =
    Width LG Col12


{-| -}
lgAuto : Width
lgAuto =
    Width XS ColAuto


-- XL Widths


{-| -}
xl : Width
xl =
    Width XL Col


{-| -}
xl1 : Width
xl1 =
    Width XL Col1


{-| -}
xl2 : Width
xl2 =
    Width XL Col2


{-| -}
xl3 : Width
xl3 =
    Width XL Col3


{-| -}
xl4 : Width
xl4 =
    Width XL Col4


{-| -}
xl5 : Width
xl5 =
    Width XL Col5


{-| -}
xl6 : Width
xl6 =
    Width XL Col6


{-| -}
xl7 : Width
xl7 =
    Width XL Col7


{-| -}
xl8 : Width
xl8 =
    Width XL Col8


{-| -}
xl9 : Width
xl9 =
    Width XL Col9


{-| -}
xl10 : Width
xl10 =
    Width XL Col10


{-| -}
xl11 : Width
xl11 =
    Width XL Col11


{-| -}
xl12 : Width
xl12 =
    Width XL Col12


{-| -}
xlAuto : Width
xlAuto =
    Width XS ColAuto


{- *************** OFFSETS ******************** -}
-- XS Offsets


{-| -}
offsetXs1 : Offset
offsetXs1 =
    Offset XS Offset1


{-| -}
offsetXs2 : Offset
offsetXs2 =
    Offset XS Offset2


{-| -}
offsetXs3 : Offset
offsetXs3 =
    Offset XS Offset3


{-| -}
offsetXs4 : Offset
offsetXs4 =
    Offset XS Offset4


{-| -}
offsetXs5 : Offset
offsetXs5 =
    Offset XS Offset5


{-| -}
offsetXs6 : Offset
offsetXs6 =
    Offset XS Offset6


{-| -}
offsetXs7 : Offset
offsetXs7 =
    Offset XS Offset7


{-| -}
offsetXs8 : Offset
offsetXs8 =
    Offset XS Offset8


{-| -}
offsetXs9 : Offset
offsetXs9 =
    Offset XS Offset9


{-| -}
offsetXs10 : Offset
offsetXs10 =
    Offset XS Offset10


{-| -}
offsetXs11 : Offset
offsetXs11 =
    Offset XS Offset11



-- SM Offsets


{-| -}
offsetSm0 : Offset
offsetSm0 =
    Offset SM Offset0



offsetSm1 : Offset
offsetSm1 =
    Offset SM Offset1


{-| -}
offsetSm2 : Offset
offsetSm2 =
    Offset SM Offset2


{-| -}
offsetSm3 : Offset
offsetSm3 =
    Offset SM Offset3


{-| -}
offsetSm4 : Offset
offsetSm4 =
    Offset SM Offset4


{-| -}
offsetSm5 : Offset
offsetSm5 =
    Offset SM Offset5


{-| -}
offsetSm6 : Offset
offsetSm6 =
    Offset SM Offset6


{-| -}
offsetSm7 : Offset
offsetSm7 =
    Offset SM Offset7


{-| -}
offsetSm8 : Offset
offsetSm8 =
    Offset SM Offset8


{-| -}
offsetSm9 : Offset
offsetSm9 =
    Offset SM Offset9


{-| -}
offsetSm10 : Offset
offsetSm10 =
    Offset SM Offset10


{-| -}
offsetSm11 : Offset
offsetSm11 =
    Offset SM Offset11



-- MD Offsets


{-| -}
offsetMd0 : Offset
offsetMd0 =
    Offset MD Offset0


offsetMd1 : Offset
offsetMd1 =
    Offset MD Offset1


{-| -}
offsetMd2 : Offset
offsetMd2 =
    Offset MD Offset2


{-| -}
offsetMd3 : Offset
offsetMd3 =
    Offset MD Offset3


{-| -}
offsetMd4 : Offset
offsetMd4 =
    Offset MD Offset4


{-| -}
offsetMd5 : Offset
offsetMd5 =
    Offset MD Offset5


{-| -}
offsetMd6 : Offset
offsetMd6 =
    Offset MD Offset6


{-| -}
offsetMd7 : Offset
offsetMd7 =
    Offset MD Offset7


{-| -}
offsetMd8 : Offset
offsetMd8 =
    Offset MD Offset8


{-| -}
offsetMd9 : Offset
offsetMd9 =
    Offset MD Offset9


{-| -}
offsetMd10 : Offset
offsetMd10 =
    Offset MD Offset10


{-| -}
offsetMd11 : Offset
offsetMd11 =
    Offset MD Offset11



-- LG Offsets
offsetLg0 : Offset
offsetLg0 =
    Offset LG Offset0


{-| -}
offsetLg1 : Offset
offsetLg1 =
    Offset LG Offset1


{-| -}
offsetLg2 : Offset
offsetLg2 =
    Offset LG Offset2


{-| -}
offsetLg3 : Offset
offsetLg3 =
    Offset LG Offset3


{-| -}
offsetLg4 : Offset
offsetLg4 =
    Offset LG Offset4


{-| -}
offsetLg5 : Offset
offsetLg5 =
    Offset LG Offset5


{-| -}
offsetLg6 : Offset
offsetLg6 =
    Offset LG Offset6


{-| -}
offsetLg7 : Offset
offsetLg7 =
    Offset LG Offset7


{-| -}
offsetLg8 : Offset
offsetLg8 =
    Offset LG Offset8


{-| -}
offsetLg9 : Offset
offsetLg9 =
    Offset LG Offset9


{-| -}
offsetLg10 : Offset
offsetLg10 =
    Offset LG Offset10


{-| -}
offsetLg11 : Offset
offsetLg11 =
    Offset LG Offset11



-- XL Offsets

offsetXl0 : Offset
offsetXl0 =
    Offset LG Offset0


{-| -}
offsetXl1 : Offset
offsetXl1 =
    Offset XL Offset1


{-| -}
offsetXl2 : Offset
offsetXl2 =
    Offset XL Offset2


{-| -}
offsetXl3 : Offset
offsetXl3 =
    Offset XL Offset3


{-| -}
offsetXl4 : Offset
offsetXl4 =
    Offset XL Offset4


{-| -}
offsetXl5 : Offset
offsetXl5 =
    Offset XL Offset5


{-| -}
offsetXl6 : Offset
offsetXl6 =
    Offset XL Offset6


{-| -}
offsetXl7 : Offset
offsetXl7 =
    Offset XL Offset7


{-| -}
offsetXl8 : Offset
offsetXl8 =
    Offset XL Offset8


{-| -}
offsetXl9 : Offset
offsetXl9 =
    Offset XL Offset9


{-| -}
offsetXl10 : Offset
offsetXl10 =
    Offset XL Offset10


{-| -}
offsetXl11 : Offset
offsetXl11 =
    Offset XL Offset11



{- *********** Pulls ******************** -}
-- XS Pulls


{-| -}
pullXs0 : Pull
pullXs0 =
    Pull XS Move0


{-| -}
pullXs1 : Pull
pullXs1 =
    Pull XS Move1


{-| -}
pullXs2 : Pull
pullXs2 =
    Pull XS Move2


{-| -}
pullXs3 : Pull
pullXs3 =
    Pull XS Move3


{-| -}
pullXs4 : Pull
pullXs4 =
    Pull XS Move4


{-| -}
pullXs5 : Pull
pullXs5 =
    Pull XS Move5


{-| -}
pullXs6 : Pull
pullXs6 =
    Pull XS Move6


{-| -}
pullXs7 : Pull
pullXs7 =
    Pull XS Move7


{-| -}
pullXs8 : Pull
pullXs8 =
    Pull XS Move8


{-| -}
pullXs9 : Pull
pullXs9 =
    Pull XS Move9


{-| -}
pullXs10 : Pull
pullXs10 =
    Pull XS Move10


{-| -}
pullXs11 : Pull
pullXs11 =
    Pull XS Move11


{-| -}
pullXs12 : Pull
pullXs12 =
    Pull XS Move12



-- SM Pulls


{-| -}
pullSm0 : Pull
pullSm0 =
    Pull SM Move0


{-| -}
pullSm1 : Pull
pullSm1 =
    Pull SM Move1


{-| -}
pullSm2 : Pull
pullSm2 =
    Pull SM Move2


{-| -}
pullSm3 : Pull
pullSm3 =
    Pull SM Move3


{-| -}
pullSm4 : Pull
pullSm4 =
    Pull SM Move4


{-| -}
pullSm5 : Pull
pullSm5 =
    Pull SM Move5


{-| -}
pullSm6 : Pull
pullSm6 =
    Pull SM Move6


{-| -}
pullSm7 : Pull
pullSm7 =
    Pull SM Move7


{-| -}
pullSm8 : Pull
pullSm8 =
    Pull SM Move8


{-| -}
pullSm9 : Pull
pullSm9 =
    Pull SM Move9


{-| -}
pullSm10 : Pull
pullSm10 =
    Pull SM Move10


{-| -}
pullSm11 : Pull
pullSm11 =
    Pull SM Move11


{-| -}
pullSm12 : Pull
pullSm12 =
    Pull SM Move12



-- MD Pulls


{-| -}
pullMd0 : Pull
pullMd0 =
    Pull MD Move0


{-| -}
pullMd1 : Pull
pullMd1 =
    Pull MD Move1


{-| -}
pullMd2 : Pull
pullMd2 =
    Pull MD Move2


{-| -}
pullMd3 : Pull
pullMd3 =
    Pull MD Move3


{-| -}
pullMd4 : Pull
pullMd4 =
    Pull MD Move4


{-| -}
pullMd5 : Pull
pullMd5 =
    Pull MD Move5


{-| -}
pullMd6 : Pull
pullMd6 =
    Pull MD Move6


{-| -}
pullMd7 : Pull
pullMd7 =
    Pull MD Move7


{-| -}
pullMd8 : Pull
pullMd8 =
    Pull MD Move8


{-| -}
pullMd9 : Pull
pullMd9 =
    Pull MD Move9


{-| -}
pullMd10 : Pull
pullMd10 =
    Pull MD Move10


{-| -}
pullMd11 : Pull
pullMd11 =
    Pull MD Move11


{-| -}
pullMd12 : Pull
pullMd12 =
    Pull MD Move12



-- LG Pulls


{-| -}
pullLg0 : Pull
pullLg0 =
    Pull LG Move0


{-| -}
pullLg1 : Pull
pullLg1 =
    Pull LG Move1


{-| -}
pullLg2 : Pull
pullLg2 =
    Pull LG Move2


{-| -}
pullLg3 : Pull
pullLg3 =
    Pull LG Move3


{-| -}
pullLg4 : Pull
pullLg4 =
    Pull LG Move4


{-| -}
pullLg5 : Pull
pullLg5 =
    Pull LG Move5


{-| -}
pullLg6 : Pull
pullLg6 =
    Pull LG Move6


{-| -}
pullLg7 : Pull
pullLg7 =
    Pull LG Move7


{-| -}
pullLg8 : Pull
pullLg8 =
    Pull LG Move8


{-| -}
pullLg9 : Pull
pullLg9 =
    Pull LG Move9


{-| -}
pullLg10 : Pull
pullLg10 =
    Pull LG Move10


{-| -}
pullLg11 : Pull
pullLg11 =
    Pull LG Move11


{-| -}
pullLg12 : Pull
pullLg12 =
    Pull LG Move12



-- XL Pulls


{-| -}
pullXl0 : Pull
pullXl0 =
    Pull XL Move0


{-| -}
pullXl1 : Pull
pullXl1 =
    Pull XL Move1


{-| -}
pullXl2 : Pull
pullXl2 =
    Pull XL Move2


{-| -}
pullXl3 : Pull
pullXl3 =
    Pull XL Move3


{-| -}
pullXl4 : Pull
pullXl4 =
    Pull XL Move4


{-| -}
pullXl5 : Pull
pullXl5 =
    Pull XL Move5


{-| -}
pullXl6 : Pull
pullXl6 =
    Pull XL Move6


{-| -}
pullXl7 : Pull
pullXl7 =
    Pull XL Move7


{-| -}
pullXl8 : Pull
pullXl8 =
    Pull XL Move8


{-| -}
pullXl9 : Pull
pullXl9 =
    Pull XL Move9


{-| -}
pullXl10 : Pull
pullXl10 =
    Pull XL Move10


{-| -}
pullXl11 : Pull
pullXl11 =
    Pull XL Move11


{-| -}
pullXl12 : Pull
pullXl12 =
    Pull XL Move12



{- *********** Pushes ******************** -}
-- XS Pushes


{-| -}
pushXs0 : Push
pushXs0 =
    Push XS Move0


{-| -}
pushXs1 : Push
pushXs1 =
    Push XS Move1


{-| -}
pushXs2 : Push
pushXs2 =
    Push XS Move2


{-| -}
pushXs3 : Push
pushXs3 =
    Push XS Move3


{-| -}
pushXs4 : Push
pushXs4 =
    Push XS Move4


{-| -}
pushXs5 : Push
pushXs5 =
    Push XS Move5


{-| -}
pushXs6 : Push
pushXs6 =
    Push XS Move6


{-| -}
pushXs7 : Push
pushXs7 =
    Push XS Move7


{-| -}
pushXs8 : Push
pushXs8 =
    Push XS Move8


{-| -}
pushXs9 : Push
pushXs9 =
    Push XS Move9


{-| -}
pushXs10 : Push
pushXs10 =
    Push XS Move10


{-| -}
pushXs11 : Push
pushXs11 =
    Push XS Move11


{-| -}
pushXs12 : Push
pushXs12 =
    Push XS Move12



-- SM Pushes


{-| -}
pushSm0 : Push
pushSm0 =
    Push SM Move0


{-| -}
pushSm1 : Push
pushSm1 =
    Push SM Move1


{-| -}
pushSm2 : Push
pushSm2 =
    Push SM Move2


{-| -}
pushSm3 : Push
pushSm3 =
    Push SM Move3


{-| -}
pushSm4 : Push
pushSm4 =
    Push SM Move4


{-| -}
pushSm5 : Push
pushSm5 =
    Push SM Move5


{-| -}
pushSm6 : Push
pushSm6 =
    Push SM Move6


{-| -}
pushSm7 : Push
pushSm7 =
    Push SM Move7


{-| -}
pushSm8 : Push
pushSm8 =
    Push SM Move8


{-| -}
pushSm9 : Push
pushSm9 =
    Push SM Move9


{-| -}
pushSm10 : Push
pushSm10 =
    Push SM Move10


{-| -}
pushSm11 : Push
pushSm11 =
    Push SM Move11


{-| -}
pushSm12 : Push
pushSm12 =
    Push SM Move12



-- MD Pushes


{-| -}
pushMd0 : Push
pushMd0 =
    Push MD Move0


{-| -}
pushMd1 : Push
pushMd1 =
    Push MD Move1


{-| -}
pushMd2 : Push
pushMd2 =
    Push MD Move2


{-| -}
pushMd3 : Push
pushMd3 =
    Push MD Move3


{-| -}
pushMd4 : Push
pushMd4 =
    Push MD Move4


{-| -}
pushMd5 : Push
pushMd5 =
    Push MD Move5


{-| -}
pushMd6 : Push
pushMd6 =
    Push MD Move6


{-| -}
pushMd7 : Push
pushMd7 =
    Push MD Move7


{-| -}
pushMd8 : Push
pushMd8 =
    Push MD Move8


{-| -}
pushMd9 : Push
pushMd9 =
    Push MD Move9


{-| -}
pushMd10 : Push
pushMd10 =
    Push MD Move10


{-| -}
pushMd11 : Push
pushMd11 =
    Push MD Move11


{-| -}
pushMd12 : Push
pushMd12 =
    Push MD Move12



-- LG Pushes


{-| -}
pushLg0 : Push
pushLg0 =
    Push LG Move0


{-| -}
pushLg1 : Push
pushLg1 =
    Push LG Move1


{-| -}
pushLg2 : Push
pushLg2 =
    Push LG Move2


{-| -}
pushLg3 : Push
pushLg3 =
    Push LG Move3


{-| -}
pushLg4 : Push
pushLg4 =
    Push LG Move4


{-| -}
pushLg5 : Push
pushLg5 =
    Push LG Move5


{-| -}
pushLg6 : Push
pushLg6 =
    Push LG Move6


{-| -}
pushLg7 : Push
pushLg7 =
    Push LG Move7


{-| -}
pushLg8 : Push
pushLg8 =
    Push LG Move8


{-| -}
pushLg9 : Push
pushLg9 =
    Push LG Move9


{-| -}
pushLg10 : Push
pushLg10 =
    Push LG Move10


{-| -}
pushLg11 : Push
pushLg11 =
    Push LG Move11


{-| -}
pushLg12 : Push
pushLg12 =
    Push LG Move12



-- XL Pushes


{-| -}
pushXl0 : Push
pushXl0 =
    Push XL Move0


{-| -}
pushXl1 : Push
pushXl1 =
    Push XL Move1


{-| -}
pushXl2 : Push
pushXl2 =
    Push XL Move2


{-| -}
pushXl3 : Push
pushXl3 =
    Push XL Move3


{-| -}
pushXl4 : Push
pushXl4 =
    Push XL Move4


{-| -}
pushXl5 : Push
pushXl5 =
    Push XL Move5


{-| -}
pushXl6 : Push
pushXl6 =
    Push XL Move6


{-| -}
pushXl7 : Push
pushXl7 =
    Push XL Move7


{-| -}
pushXl8 : Push
pushXl8 =
    Push XL Move8


{-| -}
pushXl9 : Push
pushXl9 =
    Push XL Move9


{-| -}
pushXl10 : Push
pushXl10 =
    Push XL Move10


{-| -}
pushXl11 : Push
pushXl11 =
    Push XL Move11


{-| -}
pushXl12 : Push
pushXl12 =
    Push XL Move12
