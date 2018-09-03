module Bootstrap.Utilities.Spacing exposing
    ( m0, m1, m2, m3, m4, m5, mAuto, mt0, mt1, mt2, mt3, mt4, mt5, mtAuto, mb0, mb1, mb2, mb3, mb4, mb5, mbAuto, ml0, ml1, ml2, ml3, ml4, ml5, mlAuto, mr0, mr1, mr2, mr3, mr4, mr5, mrAuto, mx0, mx1, mx2, mx3, mx4, mx5, mxAuto, my0, my1, my2, my3, my4, my5, myAuto, m0Sm, m1Sm, m2Sm, m3Sm, m4Sm, m5Sm, mAutoSm, mt0Sm, mt1Sm, mt2Sm, mt3Sm, mt4Sm, mt5Sm, mtAutoSm, mb0Sm, mb1Sm, mb2Sm, mb3Sm, mb4Sm, mb5Sm, mbAutoSm, ml0Sm, ml1Sm, ml2Sm, ml3Sm, ml4Sm, ml5Sm, mlAutoSm, mr0Sm, mr1Sm, mr2Sm, mr3Sm, mr4Sm, mr5Sm, mrAutoSm, mx0Sm, mx1Sm, mx2Sm, mx3Sm, mx4Sm, mx5Sm, mxAutoSm, my0Sm, my1Sm, my2Sm, my3Sm, my4Sm, my5Sm, myAutoSm, m0Md, m1Md, m2Md, m3Md, m4Md, m5Md, mAutoMd, mt0Md, mt1Md, mt2Md, mt3Md, mt4Md, mt5Md, mtAutoMd, mb0Md, mb1Md, mb2Md, mb3Md, mb4Md, mb5Md, mbAutoMd, ml0Md, ml1Md, ml2Md, ml3Md, ml4Md, ml5Md, mlAutoMd, mr0Md, mr1Md, mr2Md, mr3Md, mr4Md, mr5Md, mrAutoMd, mx0Md, mx1Md, mx2Md, mx3Md, mx4Md, mx5Md, mxAutoMd, my0Md, my1Md, my2Md, my3Md, my4Md, my5Md, myAutoMd, m0Lg, m1Lg, m2Lg, m3Lg, m4Lg, m5Lg, mAutoLg, mt0Lg, mt1Lg, mt2Lg, mt3Lg, mt4Lg, mt5Lg, mtAutoLg, mb0Lg, mb1Lg, mb2Lg, mb3Lg, mb4Lg, mb5Lg, mbAutoLg, ml0Lg, ml1Lg, ml2Lg, ml3Lg, ml4Lg, ml5Lg, mlAutoLg, mr0Lg, mr1Lg, mr2Lg, mr3Lg, mr4Lg, mr5Lg, mrAutoLg, mx0Lg, mx1Lg, mx2Lg, mx3Lg, mx4Lg, mx5Lg, mxAutoLg, my0Lg, my1Lg, my2Lg, my3Lg, my4Lg, my5Lg, myAutoLg, m0Xl, m1Xl, m2Xl, m3Xl, m4Xl, m5Xl, mAutoXl, mt0Xl, mt1Xl, mt2Xl, mt3Xl, mt4Xl, mt5Xl, mtAutoXl, mb0Xl, mb1Xl, mb2Xl, mb3Xl, mb4Xl, mb5Xl, mbAutoXl, ml0Xl, ml1Xl, ml2Xl, ml3Xl, ml4Xl, ml5Xl, mlAutoXl, mr0Xl, mr1Xl, mr2Xl, mr3Xl, mr4Xl, mr5Xl, mrAutoXl, mx0Xl, mx1Xl, mx2Xl, mx3Xl, mx4Xl, mx5Xl, mxAutoXl, my0Xl, my1Xl, my2Xl, my3Xl, my4Xl, my5Xl, myAutoXl
    , p0, p1, p2, p3, p4, p5, pt0, pt1, pt2, pt3, pt4, pt5, pb0, pb1, pb2, pb3, pb4, pb5, pl0, pl1, pl2, pl3, pl4, pl5, pr0, pr1, pr2, pr3, pr4, pr5, px0, px1, px2, px3, px4, px5, py0, py1, py2, py3, py4, py5, p0Sm, p1Sm, p2Sm, p3Sm, p4Sm, p5Sm, pt0Sm, pt1Sm, pt2Sm, pt3Sm, pt4Sm, pt5Sm, pb0Sm, pb1Sm, pb2Sm, pb3Sm, pb4Sm, pb5Sm, pl0Sm, pl1Sm, pl2Sm, pl3Sm, pl4Sm, pl5Sm, pr0Sm, pr1Sm, pr2Sm, pr3Sm, pr4Sm, pr5Sm, px0Sm, px1Sm, px2Sm, px3Sm, px4Sm, px5Sm, py0Sm, py1Sm, py2Sm, py3Sm, py4Sm, py5Sm, p0Md, p1Md, p2Md, p3Md, p4Md, p5Md, pt0Md, pt1Md, pt2Md, pt3Md, pt4Md, pt5Md, pb0Md, pb1Md, pb2Md, pb3Md, pb4Md, pb5Md, pl0Md, pl1Md, pl2Md, pl3Md, pl4Md, pl5Md, pr0Md, pr1Md, pr2Md, pr3Md, pr4Md, pr5Md, px0Md, px1Md, px2Md, px3Md, px4Md, px5Md, py0Md, py1Md, py2Md, py3Md, py4Md, py5Md, p0Lg, p1Lg, p2Lg, p3Lg, p4Lg, p5Lg, pt0Lg, pt1Lg, pt2Lg, pt3Lg, pt4Lg, pt5Lg, pb0Lg, pb1Lg, pb2Lg, pb3Lg, pb4Lg, pb5Lg, pl0Lg, pl1Lg, pl2Lg, pl3Lg, pl4Lg, pl5Lg, pr0Lg, pr1Lg, pr2Lg, pr3Lg, pr4Lg, pr5Lg, px0Lg, px1Lg, px2Lg, px3Lg, px4Lg, px5Lg, py0Lg, py1Lg, py2Lg, py3Lg, py4Lg, py5Lg, p0Xl, p1Xl, p2Xl, p3Xl, p4Xl, p5Xl, pt0Xl, pt1Xl, pt2Xl, pt3Xl, pt4Xl, pt5Xl, pb0Xl, pb1Xl, pb2Xl, pb3Xl, pb4Xl, pb5Xl, pl0Xl, pl1Xl, pl2Xl, pl3Xl, pl4Xl, pl5Xl, pr0Xl, pr1Xl, pr2Xl, pr3Xl, pr4Xl, pr5Xl, px0Xl, px1Xl, px2Xl, px3Xl, px4Xl, px5Xl, py0Xl, py1Xl, py2Xl, py3Xl, py4Xl, py5Xl
    )

{-| Bootstrap includes a wide range of shorthand responsive margin and padding utility classes to modify an element’s appearance.


# Margins

@docs m0, m1, m2, m3, m4, m5, mAuto, mt0, mt1, mt2, mt3, mt4, mt5, mtAuto, mb0, mb1, mb2, mb3, mb4, mb5, mbAuto, ml0, ml1, ml2, ml3, ml4, ml5, mlAuto, mr0, mr1, mr2, mr3, mr4, mr5, mrAuto, mx0, mx1, mx2, mx3, mx4, mx5, mxAuto, my0, my1, my2, my3, my4, my5, myAuto, m0Sm, m1Sm, m2Sm, m3Sm, m4Sm, m5Sm, mAutoSm, mt0Sm, mt1Sm, mt2Sm, mt3Sm, mt4Sm, mt5Sm, mtAutoSm, mb0Sm, mb1Sm, mb2Sm, mb3Sm, mb4Sm, mb5Sm, mbAutoSm, ml0Sm, ml1Sm, ml2Sm, ml3Sm, ml4Sm, ml5Sm, mlAutoSm, mr0Sm, mr1Sm, mr2Sm, mr3Sm, mr4Sm, mr5Sm, mrAutoSm, mx0Sm, mx1Sm, mx2Sm, mx3Sm, mx4Sm, mx5Sm, mxAutoSm, my0Sm, my1Sm, my2Sm, my3Sm, my4Sm, my5Sm, myAutoSm, m0Md, m1Md, m2Md, m3Md, m4Md, m5Md, mAutoMd, mt0Md, mt1Md, mt2Md, mt3Md, mt4Md, mt5Md, mtAutoMd, mb0Md, mb1Md, mb2Md, mb3Md, mb4Md, mb5Md, mbAutoMd, ml0Md, ml1Md, ml2Md, ml3Md, ml4Md, ml5Md, mlAutoMd, mr0Md, mr1Md, mr2Md, mr3Md, mr4Md, mr5Md, mrAutoMd, mx0Md, mx1Md, mx2Md, mx3Md, mx4Md, mx5Md, mxAutoMd, my0Md, my1Md, my2Md, my3Md, my4Md, my5Md, myAutoMd, m0Lg, m1Lg, m2Lg, m3Lg, m4Lg, m5Lg, mAutoLg, mt0Lg, mt1Lg, mt2Lg, mt3Lg, mt4Lg, mt5Lg, mtAutoLg, mb0Lg, mb1Lg, mb2Lg, mb3Lg, mb4Lg, mb5Lg, mbAutoLg, ml0Lg, ml1Lg, ml2Lg, ml3Lg, ml4Lg, ml5Lg, mlAutoLg, mr0Lg, mr1Lg, mr2Lg, mr3Lg, mr4Lg, mr5Lg, mrAutoLg, mx0Lg, mx1Lg, mx2Lg, mx3Lg, mx4Lg, mx5Lg, mxAutoLg, my0Lg, my1Lg, my2Lg, my3Lg, my4Lg, my5Lg, myAutoLg, m0Xl, m1Xl, m2Xl, m3Xl, m4Xl, m5Xl, mAutoXl, mt0Xl, mt1Xl, mt2Xl, mt3Xl, mt4Xl, mt5Xl, mtAutoXl, mb0Xl, mb1Xl, mb2Xl, mb3Xl, mb4Xl, mb5Xl, mbAutoXl, ml0Xl, ml1Xl, ml2Xl, ml3Xl, ml4Xl, ml5Xl, mlAutoXl, mr0Xl, mr1Xl, mr2Xl, mr3Xl, mr4Xl, mr5Xl, mrAutoXl, mx0Xl, mx1Xl, mx2Xl, mx3Xl, mx4Xl, mx5Xl, mxAutoXl, my0Xl, my1Xl, my2Xl, my3Xl, my4Xl, my5Xl, myAutoXl


# Padding

@docs p0, p1, p2, p3, p4, p5, pt0, pt1, pt2, pt3, pt4, pt5, pb0, pb1, pb2, pb3, pb4, pb5, pl0, pl1, pl2, pl3, pl4, pl5, pr0, pr1, pr2, pr3, pr4, pr5, px0, px1, px2, px3, px4, px5, py0, py1, py2, py3, py4, py5, p0Sm, p1Sm, p2Sm, p3Sm, p4Sm, p5Sm, pt0Sm, pt1Sm, pt2Sm, pt3Sm, pt4Sm, pt5Sm, pb0Sm, pb1Sm, pb2Sm, pb3Sm, pb4Sm, pb5Sm, pl0Sm, pl1Sm, pl2Sm, pl3Sm, pl4Sm, pl5Sm, pr0Sm, pr1Sm, pr2Sm, pr3Sm, pr4Sm, pr5Sm, px0Sm, px1Sm, px2Sm, px3Sm, px4Sm, px5Sm, py0Sm, py1Sm, py2Sm, py3Sm, py4Sm, py5Sm, p0Md, p1Md, p2Md, p3Md, p4Md, p5Md, pt0Md, pt1Md, pt2Md, pt3Md, pt4Md, pt5Md, pb0Md, pb1Md, pb2Md, pb3Md, pb4Md, pb5Md, pl0Md, pl1Md, pl2Md, pl3Md, pl4Md, pl5Md, pr0Md, pr1Md, pr2Md, pr3Md, pr4Md, pr5Md, px0Md, px1Md, px2Md, px3Md, px4Md, px5Md, py0Md, py1Md, py2Md, py3Md, py4Md, py5Md, p0Lg, p1Lg, p2Lg, p3Lg, p4Lg, p5Lg, pt0Lg, pt1Lg, pt2Lg, pt3Lg, pt4Lg, pt5Lg, pb0Lg, pb1Lg, pb2Lg, pb3Lg, pb4Lg, pb5Lg, pl0Lg, pl1Lg, pl2Lg, pl3Lg, pl4Lg, pl5Lg, pr0Lg, pr1Lg, pr2Lg, pr3Lg, pr4Lg, pr5Lg, px0Lg, px1Lg, px2Lg, px3Lg, px4Lg, px5Lg, py0Lg, py1Lg, py2Lg, py3Lg, py4Lg, py5Lg, p0Xl, p1Xl, p2Xl, p3Xl, p4Xl, p5Xl, pt0Xl, pt1Xl, pt2Xl, pt3Xl, pt4Xl, pt5Xl, pb0Xl, pb1Xl, pb2Xl, pb3Xl, pb4Xl, pb5Xl, pl0Xl, pl1Xl, pl2Xl, pl3Xl, pl4Xl, pl5Xl, pr0Xl, pr1Xl, pr2Xl, pr3Xl, pr4Xl, pr5Xl, px0Xl, px1Xl, px2Xl, px3Xl, px4Xl, px5Xl, py0Xl, py1Xl, py2Xl, py3Xl, py4Xl, py5Xl

-}

import Html exposing (Attribute)
import Html.Attributes exposing (class)


{-| Set margin to 0.
-}
m0 : Attribute msg
m0 =
    class "m-0"


{-| Set margin to 1.
-}
m1 : Attribute msg
m1 =
    class "m-1"


{-| Set margin to 2.
-}
m2 : Attribute msg
m2 =
    class "m-2"


{-| Set margin to 3.
-}
m3 : Attribute msg
m3 =
    class "m-3"


{-| Set margin to 4.
-}
m4 : Attribute msg
m4 =
    class "m-4"


{-| Set margin to 5.
-}
m5 : Attribute msg
m5 =
    class "m-5"


{-| Set margin to auto.
-}
mAuto : Attribute msg
mAuto =
    class "m-auto"


{-| Set margin top to 0.
-}
mt0 : Attribute msg
mt0 =
    class "mt-0"


{-| Set margin top to 1.
-}
mt1 : Attribute msg
mt1 =
    class "mt-1"


{-| Set margin top to 2.
-}
mt2 : Attribute msg
mt2 =
    class "mt-2"


{-| Set margin top to 3.
-}
mt3 : Attribute msg
mt3 =
    class "mt-3"


{-| Set margin top to 4.
-}
mt4 : Attribute msg
mt4 =
    class "mt-4"


{-| Set margin top to 5.
-}
mt5 : Attribute msg
mt5 =
    class "mt-5"


{-| Set margin top to auto.
-}
mtAuto : Attribute msg
mtAuto =
    class "mt-auto"


{-| Set margin bottom to 0.
-}
mb0 : Attribute msg
mb0 =
    class "mb-0"


{-| Set margin bottom to 1.
-}
mb1 : Attribute msg
mb1 =
    class "mb-1"


{-| Set margin bottom to 2.
-}
mb2 : Attribute msg
mb2 =
    class "mb-2"


{-| Set margin bottom to 3.
-}
mb3 : Attribute msg
mb3 =
    class "mb-3"


{-| Set margin bottom to 4.
-}
mb4 : Attribute msg
mb4 =
    class "mb-4"


{-| Set margin bottom to 5.
-}
mb5 : Attribute msg
mb5 =
    class "mb-5"


{-| Set margin bottom to auto.
-}
mbAuto : Attribute msg
mbAuto =
    class "mb-auto"


{-| Set margin left to 0.
-}
ml0 : Attribute msg
ml0 =
    class "ml-0"


{-| Set margin left to 1.
-}
ml1 : Attribute msg
ml1 =
    class "ml-1"


{-| Set margin left to 2.
-}
ml2 : Attribute msg
ml2 =
    class "ml-2"


{-| Set margin left to 3.
-}
ml3 : Attribute msg
ml3 =
    class "ml-3"


{-| Set margin left to 4.
-}
ml4 : Attribute msg
ml4 =
    class "ml-4"


{-| Set margin left to 5.
-}
ml5 : Attribute msg
ml5 =
    class "ml-5"


{-| Set margin left to auto.
-}
mlAuto : Attribute msg
mlAuto =
    class "ml-auto"


{-| Set margin right to 0.
-}
mr0 : Attribute msg
mr0 =
    class "mr-0"


{-| Set margin right to 1.
-}
mr1 : Attribute msg
mr1 =
    class "mr-1"


{-| Set margin right to 2.
-}
mr2 : Attribute msg
mr2 =
    class "mr-2"


{-| Set margin right to 3.
-}
mr3 : Attribute msg
mr3 =
    class "mr-3"


{-| Set margin right to 4.
-}
mr4 : Attribute msg
mr4 =
    class "mr-4"


{-| Set margin right to 5.
-}
mr5 : Attribute msg
mr5 =
    class "mr-5"


{-| Set margin right to auto.
-}
mrAuto : Attribute msg
mrAuto =
    class "mr-auto"


{-| Set margin left and right to 0.
-}
mx0 : Attribute msg
mx0 =
    class "mx-0"


{-| Set margin left and right to 1.
-}
mx1 : Attribute msg
mx1 =
    class "mx-1"


{-| Set margin left and right to 2.
-}
mx2 : Attribute msg
mx2 =
    class "mx-2"


{-| Set margin left and right to 3.
-}
mx3 : Attribute msg
mx3 =
    class "mx-3"


{-| Set margin left and right to 4.
-}
mx4 : Attribute msg
mx4 =
    class "mx-4"


{-| Set margin left and right to 5.
-}
mx5 : Attribute msg
mx5 =
    class "mx-5"


{-| Set margin left and right to auto.
-}
mxAuto : Attribute msg
mxAuto =
    class "mx-auto"


{-| Set margin top and bottom to 0.
-}
my0 : Attribute msg
my0 =
    class "my-0"


{-| Set margin top and bottom to 1.
-}
my1 : Attribute msg
my1 =
    class "my-1"


{-| Set margin top and bottom to 2.
-}
my2 : Attribute msg
my2 =
    class "my-2"


{-| Set margin top and bottom to 3.
-}
my3 : Attribute msg
my3 =
    class "my-3"


{-| Set margin top and bottom to 4.
-}
my4 : Attribute msg
my4 =
    class "my-4"


{-| Set margin top and bottom to 5.
-}
my5 : Attribute msg
my5 =
    class "my-5"


{-| Set margin top and bottom to auto.
-}
myAuto : Attribute msg
myAuto =
    class "my-auto"


{-| Set margin to 0 applicable from breakpoint SM.
-}
m0Sm : Attribute msg
m0Sm =
    class "m-sm-0"


{-| Set margin to 1 applicable from breakpoint SM.
-}
m1Sm : Attribute msg
m1Sm =
    class "m-sm-1"


{-| Set margin to 2 applicable from breakpoint SM.
-}
m2Sm : Attribute msg
m2Sm =
    class "m-sm-2"


{-| Set margin to 3 applicable from breakpoint SM.
-}
m3Sm : Attribute msg
m3Sm =
    class "m-sm-3"


{-| Set margin to 4 applicable from breakpoint SM.
-}
m4Sm : Attribute msg
m4Sm =
    class "m-sm-4"


{-| Set margin to 5 applicable from breakpoint SM.
-}
m5Sm : Attribute msg
m5Sm =
    class "m-sm-5"


{-| Set margin to auto applicable from breakpoint SM.
-}
mAutoSm : Attribute msg
mAutoSm =
    class "m-sm-auto"


{-| Set margin top to 0 applicable from breakpoint SM.
-}
mt0Sm : Attribute msg
mt0Sm =
    class "mt-sm-0"


{-| Set margin top to 1 applicable from breakpoint SM.
-}
mt1Sm : Attribute msg
mt1Sm =
    class "mt-sm-1"


{-| Set margin top to 2 applicable from breakpoint SM.
-}
mt2Sm : Attribute msg
mt2Sm =
    class "mt-sm-2"


{-| Set margin top to 3 applicable from breakpoint SM.
-}
mt3Sm : Attribute msg
mt3Sm =
    class "mt-sm-3"


{-| Set margin top to 4 applicable from breakpoint SM.
-}
mt4Sm : Attribute msg
mt4Sm =
    class "mt-sm-4"


{-| Set margin top to 5 applicable from breakpoint SM.
-}
mt5Sm : Attribute msg
mt5Sm =
    class "mt-sm-5"


{-| Set margin top to auto applicable from breakpoint SM.
-}
mtAutoSm : Attribute msg
mtAutoSm =
    class "mt-sm-auto"


{-| Set margin bottom to 0 applicable from breakpoint SM.
-}
mb0Sm : Attribute msg
mb0Sm =
    class "mb-sm-0"


{-| Set margin bottom to 1 applicable from breakpoint SM.
-}
mb1Sm : Attribute msg
mb1Sm =
    class "mb-sm-1"


{-| Set margin bottom to 2 applicable from breakpoint SM.
-}
mb2Sm : Attribute msg
mb2Sm =
    class "mb-sm-2"


{-| Set margin bottom to 3 applicable from breakpoint SM.
-}
mb3Sm : Attribute msg
mb3Sm =
    class "mb-sm-3"


{-| Set margin bottom to 4 applicable from breakpoint SM.
-}
mb4Sm : Attribute msg
mb4Sm =
    class "mb-sm-4"


{-| Set margin bottom to 5 applicable from breakpoint SM.
-}
mb5Sm : Attribute msg
mb5Sm =
    class "mb-sm-5"


{-| Set margin bottom to auto applicable from breakpoint SM.
-}
mbAutoSm : Attribute msg
mbAutoSm =
    class "mb-sm-auto"


{-| Set margin left to 0 applicable from breakpoint SM.
-}
ml0Sm : Attribute msg
ml0Sm =
    class "ml-sm-0"


{-| Set margin left to 1 applicable from breakpoint SM.
-}
ml1Sm : Attribute msg
ml1Sm =
    class "ml-sm-1"


{-| Set margin left to 2 applicable from breakpoint SM.
-}
ml2Sm : Attribute msg
ml2Sm =
    class "ml-sm-2"


{-| Set margin left to 3 applicable from breakpoint SM.
-}
ml3Sm : Attribute msg
ml3Sm =
    class "ml-sm-3"


{-| Set margin left to 4 applicable from breakpoint SM.
-}
ml4Sm : Attribute msg
ml4Sm =
    class "ml-sm-4"


{-| Set margin left to 5 applicable from breakpoint SM.
-}
ml5Sm : Attribute msg
ml5Sm =
    class "ml-sm-5"


{-| Set margin left to auto applicable from breakpoint SM.
-}
mlAutoSm : Attribute msg
mlAutoSm =
    class "ml-sm-auto"


{-| Set margin right to 0 applicable from breakpoint SM.
-}
mr0Sm : Attribute msg
mr0Sm =
    class "mr-sm-0"


{-| Set margin right to 1 applicable from breakpoint SM.
-}
mr1Sm : Attribute msg
mr1Sm =
    class "mr-sm-1"


{-| Set margin right to 2 applicable from breakpoint SM.
-}
mr2Sm : Attribute msg
mr2Sm =
    class "mr-sm-2"


{-| Set margin right to 3 applicable from breakpoint SM.
-}
mr3Sm : Attribute msg
mr3Sm =
    class "mr-sm-3"


{-| Set margin right to 4 applicable from breakpoint SM.
-}
mr4Sm : Attribute msg
mr4Sm =
    class "mr-sm-4"


{-| Set margin right to 5 applicable from breakpoint SM.
-}
mr5Sm : Attribute msg
mr5Sm =
    class "mr-sm-5"


{-| Set margin right to auto applicable from breakpoint SM.
-}
mrAutoSm : Attribute msg
mrAutoSm =
    class "mr-sm-auto"


{-| Set margin left and right to 0 applicable from breakpoint SM.
-}
mx0Sm : Attribute msg
mx0Sm =
    class "mx-sm-0"


{-| Set margin left and right to 1 applicable from breakpoint SM.
-}
mx1Sm : Attribute msg
mx1Sm =
    class "mx-sm-1"


{-| Set margin left and right to 2 applicable from breakpoint SM.
-}
mx2Sm : Attribute msg
mx2Sm =
    class "mx-sm-2"


{-| Set margin left and right to 3 applicable from breakpoint SM.
-}
mx3Sm : Attribute msg
mx3Sm =
    class "mx-sm-3"


{-| Set margin left and right to 4 applicable from breakpoint SM.
-}
mx4Sm : Attribute msg
mx4Sm =
    class "mx-sm-4"


{-| Set margin left and right to 5 applicable from breakpoint SM.
-}
mx5Sm : Attribute msg
mx5Sm =
    class "mx-sm-5"


{-| Set margin left and right to auto applicable from breakpoint SM.
-}
mxAutoSm : Attribute msg
mxAutoSm =
    class "mx-sm-auto"


{-| Set margin top and bottom to 0 applicable from breakpoint SM.
-}
my0Sm : Attribute msg
my0Sm =
    class "my-sm-0"


{-| Set margin top and bottom to 1 applicable from breakpoint SM.
-}
my1Sm : Attribute msg
my1Sm =
    class "my-sm-1"


{-| Set margin top and bottom to 2 applicable from breakpoint SM.
-}
my2Sm : Attribute msg
my2Sm =
    class "my-sm-2"


{-| Set margin top and bottom to 3 applicable from breakpoint SM.
-}
my3Sm : Attribute msg
my3Sm =
    class "my-sm-3"


{-| Set margin top and bottom to 4 applicable from breakpoint SM.
-}
my4Sm : Attribute msg
my4Sm =
    class "my-sm-4"


{-| Set margin top and bottom to 5 applicable from breakpoint SM.
-}
my5Sm : Attribute msg
my5Sm =
    class "my-sm-5"


{-| Set margin top and bottom to auto applicable from breakpoint SM.
-}
myAutoSm : Attribute msg
myAutoSm =
    class "my-sm-auto"


{-| Set margin to 0 applicable from breakpoint MD.
-}
m0Md : Attribute msg
m0Md =
    class "m-md-0"


{-| Set margin to 1 applicable from breakpoint MD.
-}
m1Md : Attribute msg
m1Md =
    class "m-md-1"


{-| Set margin to 2 applicable from breakpoint MD.
-}
m2Md : Attribute msg
m2Md =
    class "m-md-2"


{-| Set margin to 3 applicable from breakpoint MD.
-}
m3Md : Attribute msg
m3Md =
    class "m-md-3"


{-| Set margin to 4 applicable from breakpoint MD.
-}
m4Md : Attribute msg
m4Md =
    class "m-md-4"


{-| Set margin to 5 applicable from breakpoint MD.
-}
m5Md : Attribute msg
m5Md =
    class "m-md-5"


{-| Set margin to auto applicable from breakpoint MD.
-}
mAutoMd : Attribute msg
mAutoMd =
    class "m-md-auto"


{-| Set margin top to 0 applicable from breakpoint MD.
-}
mt0Md : Attribute msg
mt0Md =
    class "mt-md-0"


{-| Set margin top to 1 applicable from breakpoint MD.
-}
mt1Md : Attribute msg
mt1Md =
    class "mt-md-1"


{-| Set margin top to 2 applicable from breakpoint MD.
-}
mt2Md : Attribute msg
mt2Md =
    class "mt-md-2"


{-| Set margin top to 3 applicable from breakpoint MD.
-}
mt3Md : Attribute msg
mt3Md =
    class "mt-md-3"


{-| Set margin top to 4 applicable from breakpoint MD.
-}
mt4Md : Attribute msg
mt4Md =
    class "mt-md-4"


{-| Set margin top to 5 applicable from breakpoint MD.
-}
mt5Md : Attribute msg
mt5Md =
    class "mt-md-5"


{-| Set margin top to auto applicable from breakpoint MD.
-}
mtAutoMd : Attribute msg
mtAutoMd =
    class "mt-md-auto"


{-| Set margin bottom to 0 applicable from breakpoint MD.
-}
mb0Md : Attribute msg
mb0Md =
    class "mb-md-0"


{-| Set margin bottom to 1 applicable from breakpoint MD.
-}
mb1Md : Attribute msg
mb1Md =
    class "mb-md-1"


{-| Set margin bottom to 2 applicable from breakpoint MD.
-}
mb2Md : Attribute msg
mb2Md =
    class "mb-md-2"


{-| Set margin bottom to 3 applicable from breakpoint MD.
-}
mb3Md : Attribute msg
mb3Md =
    class "mb-md-3"


{-| Set margin bottom to 4 applicable from breakpoint MD.
-}
mb4Md : Attribute msg
mb4Md =
    class "mb-md-4"


{-| Set margin bottom to 5 applicable from breakpoint MD.
-}
mb5Md : Attribute msg
mb5Md =
    class "mb-md-5"


{-| Set margin bottom to auto applicable from breakpoint MD.
-}
mbAutoMd : Attribute msg
mbAutoMd =
    class "mb-md-auto"


{-| Set margin left to 0 applicable from breakpoint MD.
-}
ml0Md : Attribute msg
ml0Md =
    class "ml-md-0"


{-| Set margin left to 1 applicable from breakpoint MD.
-}
ml1Md : Attribute msg
ml1Md =
    class "ml-md-1"


{-| Set margin left to 2 applicable from breakpoint MD.
-}
ml2Md : Attribute msg
ml2Md =
    class "ml-md-2"


{-| Set margin left to 3 applicable from breakpoint MD.
-}
ml3Md : Attribute msg
ml3Md =
    class "ml-md-3"


{-| Set margin left to 4 applicable from breakpoint MD.
-}
ml4Md : Attribute msg
ml4Md =
    class "ml-md-4"


{-| Set margin left to 5 applicable from breakpoint MD.
-}
ml5Md : Attribute msg
ml5Md =
    class "ml-md-5"


{-| Set margin left to auto applicable from breakpoint MD.
-}
mlAutoMd : Attribute msg
mlAutoMd =
    class "ml-md-auto"


{-| Set margin right to 0 applicable from breakpoint MD.
-}
mr0Md : Attribute msg
mr0Md =
    class "mr-md-0"


{-| Set margin right to 1 applicable from breakpoint MD.
-}
mr1Md : Attribute msg
mr1Md =
    class "mr-md-1"


{-| Set margin right to 2 applicable from breakpoint MD.
-}
mr2Md : Attribute msg
mr2Md =
    class "mr-md-2"


{-| Set margin right to 3 applicable from breakpoint MD.
-}
mr3Md : Attribute msg
mr3Md =
    class "mr-md-3"


{-| Set margin right to 4 applicable from breakpoint MD.
-}
mr4Md : Attribute msg
mr4Md =
    class "mr-md-4"


{-| Set margin right to 5 applicable from breakpoint MD.
-}
mr5Md : Attribute msg
mr5Md =
    class "mr-md-5"


{-| Set margin right to auto applicable from breakpoint MD.
-}
mrAutoMd : Attribute msg
mrAutoMd =
    class "mr-md-auto"


{-| Set margin left and right to 0 applicable from breakpoint MD.
-}
mx0Md : Attribute msg
mx0Md =
    class "mx-md-0"


{-| Set margin left and right to 1 applicable from breakpoint MD.
-}
mx1Md : Attribute msg
mx1Md =
    class "mx-md-1"


{-| Set margin left and right to 2 applicable from breakpoint MD.
-}
mx2Md : Attribute msg
mx2Md =
    class "mx-md-2"


{-| Set margin left and right to 3 applicable from breakpoint MD.
-}
mx3Md : Attribute msg
mx3Md =
    class "mx-md-3"


{-| Set margin left and right to 4 applicable from breakpoint MD.
-}
mx4Md : Attribute msg
mx4Md =
    class "mx-md-4"


{-| Set margin left and right to 5 applicable from breakpoint MD.
-}
mx5Md : Attribute msg
mx5Md =
    class "mx-md-5"


{-| Set margin left and right to auto applicable from breakpoint MD.
-}
mxAutoMd : Attribute msg
mxAutoMd =
    class "mx-md-auto"


{-| Set margin top and bottom to 0 applicable from breakpoint MD.
-}
my0Md : Attribute msg
my0Md =
    class "my-md-0"


{-| Set margin top and bottom to 1 applicable from breakpoint MD.
-}
my1Md : Attribute msg
my1Md =
    class "my-md-1"


{-| Set margin top and bottom to 2 applicable from breakpoint MD.
-}
my2Md : Attribute msg
my2Md =
    class "my-md-2"


{-| Set margin top and bottom to 3 applicable from breakpoint MD.
-}
my3Md : Attribute msg
my3Md =
    class "my-md-3"


{-| Set margin top and bottom to 4 applicable from breakpoint MD.
-}
my4Md : Attribute msg
my4Md =
    class "my-md-4"


{-| Set margin top and bottom to 5 applicable from breakpoint MD.
-}
my5Md : Attribute msg
my5Md =
    class "my-md-5"


{-| Set margin top and bottom to auto applicable from breakpoint MD.
-}
myAutoMd : Attribute msg
myAutoMd =
    class "my-md-auto"


{-| Set margin to 0 applicable from breakpoint LG.
-}
m0Lg : Attribute msg
m0Lg =
    class "m-lg-0"


{-| Set margin to 1 applicable from breakpoint LG.
-}
m1Lg : Attribute msg
m1Lg =
    class "m-lg-1"


{-| Set margin to 2 applicable from breakpoint LG.
-}
m2Lg : Attribute msg
m2Lg =
    class "m-lg-2"


{-| Set margin to 3 applicable from breakpoint LG.
-}
m3Lg : Attribute msg
m3Lg =
    class "m-lg-3"


{-| Set margin to 4 applicable from breakpoint LG.
-}
m4Lg : Attribute msg
m4Lg =
    class "m-lg-4"


{-| Set margin to 5 applicable from breakpoint LG.
-}
m5Lg : Attribute msg
m5Lg =
    class "m-lg-5"


{-| Set margin to auto applicable from breakpoint LG.
-}
mAutoLg : Attribute msg
mAutoLg =
    class "m-lg-auto"


{-| Set margin top to 0 applicable from breakpoint LG.
-}
mt0Lg : Attribute msg
mt0Lg =
    class "mt-lg-0"


{-| Set margin top to 1 applicable from breakpoint LG.
-}
mt1Lg : Attribute msg
mt1Lg =
    class "mt-lg-1"


{-| Set margin top to 2 applicable from breakpoint LG.
-}
mt2Lg : Attribute msg
mt2Lg =
    class "mt-lg-2"


{-| Set margin top to 3 applicable from breakpoint LG.
-}
mt3Lg : Attribute msg
mt3Lg =
    class "mt-lg-3"


{-| Set margin top to 4 applicable from breakpoint LG.
-}
mt4Lg : Attribute msg
mt4Lg =
    class "mt-lg-4"


{-| Set margin top to 5 applicable from breakpoint LG.
-}
mt5Lg : Attribute msg
mt5Lg =
    class "mt-lg-5"


{-| Set margin top to auto applicable from breakpoint LG.
-}
mtAutoLg : Attribute msg
mtAutoLg =
    class "mt-lg-auto"


{-| Set margin bottom to 0 applicable from breakpoint LG.
-}
mb0Lg : Attribute msg
mb0Lg =
    class "mb-lg-0"


{-| Set margin bottom to 1 applicable from breakpoint LG.
-}
mb1Lg : Attribute msg
mb1Lg =
    class "mb-lg-1"


{-| Set margin bottom to 2 applicable from breakpoint LG.
-}
mb2Lg : Attribute msg
mb2Lg =
    class "mb-lg-2"


{-| Set margin bottom to 3 applicable from breakpoint LG.
-}
mb3Lg : Attribute msg
mb3Lg =
    class "mb-lg-3"


{-| Set margin bottom to 4 applicable from breakpoint LG.
-}
mb4Lg : Attribute msg
mb4Lg =
    class "mb-lg-4"


{-| Set margin bottom to 5 applicable from breakpoint LG.
-}
mb5Lg : Attribute msg
mb5Lg =
    class "mb-lg-5"


{-| Set margin bottom to auto applicable from breakpoint LG.
-}
mbAutoLg : Attribute msg
mbAutoLg =
    class "mb-lg-auto"


{-| Set margin left to 0 applicable from breakpoint LG.
-}
ml0Lg : Attribute msg
ml0Lg =
    class "ml-lg-0"


{-| Set margin left to 1 applicable from breakpoint LG.
-}
ml1Lg : Attribute msg
ml1Lg =
    class "ml-lg-1"


{-| Set margin left to 2 applicable from breakpoint LG.
-}
ml2Lg : Attribute msg
ml2Lg =
    class "ml-lg-2"


{-| Set margin left to 3 applicable from breakpoint LG.
-}
ml3Lg : Attribute msg
ml3Lg =
    class "ml-lg-3"


{-| Set margin left to 4 applicable from breakpoint LG.
-}
ml4Lg : Attribute msg
ml4Lg =
    class "ml-lg-4"


{-| Set margin left to 5 applicable from breakpoint LG.
-}
ml5Lg : Attribute msg
ml5Lg =
    class "ml-lg-5"


{-| Set margin left to auto applicable from breakpoint LG.
-}
mlAutoLg : Attribute msg
mlAutoLg =
    class "ml-lg-auto"


{-| Set margin right to 0 applicable from breakpoint LG.
-}
mr0Lg : Attribute msg
mr0Lg =
    class "mr-lg-0"


{-| Set margin right to 1 applicable from breakpoint LG.
-}
mr1Lg : Attribute msg
mr1Lg =
    class "mr-lg-1"


{-| Set margin right to 2 applicable from breakpoint LG.
-}
mr2Lg : Attribute msg
mr2Lg =
    class "mr-lg-2"


{-| Set margin right to 3 applicable from breakpoint LG.
-}
mr3Lg : Attribute msg
mr3Lg =
    class "mr-lg-3"


{-| Set margin right to 4 applicable from breakpoint LG.
-}
mr4Lg : Attribute msg
mr4Lg =
    class "mr-lg-4"


{-| Set margin right to 5 applicable from breakpoint LG.
-}
mr5Lg : Attribute msg
mr5Lg =
    class "mr-lg-5"


{-| Set margin right to auto applicable from breakpoint LG.
-}
mrAutoLg : Attribute msg
mrAutoLg =
    class "mr-lg-auto"


{-| Set margin left and right to 0 applicable from breakpoint LG.
-}
mx0Lg : Attribute msg
mx0Lg =
    class "mx-lg-0"


{-| Set margin left and right to 1 applicable from breakpoint LG.
-}
mx1Lg : Attribute msg
mx1Lg =
    class "mx-lg-1"


{-| Set margin left and right to 2 applicable from breakpoint LG.
-}
mx2Lg : Attribute msg
mx2Lg =
    class "mx-lg-2"


{-| Set margin left and right to 3 applicable from breakpoint LG.
-}
mx3Lg : Attribute msg
mx3Lg =
    class "mx-lg-3"


{-| Set margin left and right to 4 applicable from breakpoint LG.
-}
mx4Lg : Attribute msg
mx4Lg =
    class "mx-lg-4"


{-| Set margin left and right to 5 applicable from breakpoint LG.
-}
mx5Lg : Attribute msg
mx5Lg =
    class "mx-lg-5"


{-| Set margin left and right to auto applicable from breakpoint LG.
-}
mxAutoLg : Attribute msg
mxAutoLg =
    class "mx-lg-auto"


{-| Set margin top and bottom to 0 applicable from breakpoint LG.
-}
my0Lg : Attribute msg
my0Lg =
    class "my-lg-0"


{-| Set margin top and bottom to 1 applicable from breakpoint LG.
-}
my1Lg : Attribute msg
my1Lg =
    class "my-lg-1"


{-| Set margin top and bottom to 2 applicable from breakpoint LG.
-}
my2Lg : Attribute msg
my2Lg =
    class "my-lg-2"


{-| Set margin top and bottom to 3 applicable from breakpoint LG.
-}
my3Lg : Attribute msg
my3Lg =
    class "my-lg-3"


{-| Set margin top and bottom to 4 applicable from breakpoint LG.
-}
my4Lg : Attribute msg
my4Lg =
    class "my-lg-4"


{-| Set margin top and bottom to 5 applicable from breakpoint LG.
-}
my5Lg : Attribute msg
my5Lg =
    class "my-lg-5"


{-| Set margin top and bottom to auto applicable from breakpoint LG.
-}
myAutoLg : Attribute msg
myAutoLg =
    class "my-lg-auto"


{-| Set margin to 0 applicable from breakpoint XL.
-}
m0Xl : Attribute msg
m0Xl =
    class "m-xl-0"


{-| Set margin to 1 applicable from breakpoint XL.
-}
m1Xl : Attribute msg
m1Xl =
    class "m-xl-1"


{-| Set margin to 2 applicable from breakpoint XL.
-}
m2Xl : Attribute msg
m2Xl =
    class "m-xl-2"


{-| Set margin to 3 applicable from breakpoint XL.
-}
m3Xl : Attribute msg
m3Xl =
    class "m-xl-3"


{-| Set margin to 4 applicable from breakpoint XL.
-}
m4Xl : Attribute msg
m4Xl =
    class "m-xl-4"


{-| Set margin to 5 applicable from breakpoint XL.
-}
m5Xl : Attribute msg
m5Xl =
    class "m-xl-5"


{-| Set margin to auto applicable from breakpoint XL.
-}
mAutoXl : Attribute msg
mAutoXl =
    class "m-xl-auto"


{-| Set margin top to 0 applicable from breakpoint XL.
-}
mt0Xl : Attribute msg
mt0Xl =
    class "mt-xl-0"


{-| Set margin top to 1 applicable from breakpoint XL.
-}
mt1Xl : Attribute msg
mt1Xl =
    class "mt-xl-1"


{-| Set margin top to 2 applicable from breakpoint XL.
-}
mt2Xl : Attribute msg
mt2Xl =
    class "mt-xl-2"


{-| Set margin top to 3 applicable from breakpoint XL.
-}
mt3Xl : Attribute msg
mt3Xl =
    class "mt-xl-3"


{-| Set margin top to 4 applicable from breakpoint XL.
-}
mt4Xl : Attribute msg
mt4Xl =
    class "mt-xl-4"


{-| Set margin top to 5 applicable from breakpoint XL.
-}
mt5Xl : Attribute msg
mt5Xl =
    class "mt-xl-5"


{-| Set margin top to auto applicable from breakpoint XL.
-}
mtAutoXl : Attribute msg
mtAutoXl =
    class "mt-xl-auto"


{-| Set margin bottom to 0 applicable from breakpoint XL.
-}
mb0Xl : Attribute msg
mb0Xl =
    class "mb-xl-0"


{-| Set margin bottom to 1 applicable from breakpoint XL.
-}
mb1Xl : Attribute msg
mb1Xl =
    class "mb-xl-1"


{-| Set margin bottom to 2 applicable from breakpoint XL.
-}
mb2Xl : Attribute msg
mb2Xl =
    class "mb-xl-2"


{-| Set margin bottom to 3 applicable from breakpoint XL.
-}
mb3Xl : Attribute msg
mb3Xl =
    class "mb-xl-3"


{-| Set margin bottom to 4 applicable from breakpoint XL.
-}
mb4Xl : Attribute msg
mb4Xl =
    class "mb-xl-4"


{-| Set margin bottom to 5 applicable from breakpoint XL.
-}
mb5Xl : Attribute msg
mb5Xl =
    class "mb-xl-5"


{-| Set margin bottom to auto applicable from breakpoint XL.
-}
mbAutoXl : Attribute msg
mbAutoXl =
    class "mb-xl-auto"


{-| Set margin left to 0 applicable from breakpoint XL.
-}
ml0Xl : Attribute msg
ml0Xl =
    class "ml-xl-0"


{-| Set margin left to 1 applicable from breakpoint XL.
-}
ml1Xl : Attribute msg
ml1Xl =
    class "ml-xl-1"


{-| Set margin left to 2 applicable from breakpoint XL.
-}
ml2Xl : Attribute msg
ml2Xl =
    class "ml-xl-2"


{-| Set margin left to 3 applicable from breakpoint XL.
-}
ml3Xl : Attribute msg
ml3Xl =
    class "ml-xl-3"


{-| Set margin left to 4 applicable from breakpoint XL.
-}
ml4Xl : Attribute msg
ml4Xl =
    class "ml-xl-4"


{-| Set margin left to 5 applicable from breakpoint XL.
-}
ml5Xl : Attribute msg
ml5Xl =
    class "ml-xl-5"


{-| Set margin left to auto applicable from breakpoint XL.
-}
mlAutoXl : Attribute msg
mlAutoXl =
    class "ml-xl-auto"


{-| Set margin right to 0 applicable from breakpoint XL.
-}
mr0Xl : Attribute msg
mr0Xl =
    class "mr-xl-0"


{-| Set margin right to 1 applicable from breakpoint XL.
-}
mr1Xl : Attribute msg
mr1Xl =
    class "mr-xl-1"


{-| Set margin right to 2 applicable from breakpoint XL.
-}
mr2Xl : Attribute msg
mr2Xl =
    class "mr-xl-2"


{-| Set margin right to 3 applicable from breakpoint XL.
-}
mr3Xl : Attribute msg
mr3Xl =
    class "mr-xl-3"


{-| Set margin right to 4 applicable from breakpoint XL.
-}
mr4Xl : Attribute msg
mr4Xl =
    class "mr-xl-4"


{-| Set margin right to 5 applicable from breakpoint XL.
-}
mr5Xl : Attribute msg
mr5Xl =
    class "mr-xl-5"


{-| Set margin right to auto applicable from breakpoint XL.
-}
mrAutoXl : Attribute msg
mrAutoXl =
    class "mr-xl-auto"


{-| Set margin left and right to 0 applicable from breakpoint XL.
-}
mx0Xl : Attribute msg
mx0Xl =
    class "mx-xl-0"


{-| Set margin left and right to 1 applicable from breakpoint XL.
-}
mx1Xl : Attribute msg
mx1Xl =
    class "mx-xl-1"


{-| Set margin left and right to 2 applicable from breakpoint XL.
-}
mx2Xl : Attribute msg
mx2Xl =
    class "mx-xl-2"


{-| Set margin left and right to 3 applicable from breakpoint XL.
-}
mx3Xl : Attribute msg
mx3Xl =
    class "mx-xl-3"


{-| Set margin left and right to 4 applicable from breakpoint XL.
-}
mx4Xl : Attribute msg
mx4Xl =
    class "mx-xl-4"


{-| Set margin left and right to 5 applicable from breakpoint XL.
-}
mx5Xl : Attribute msg
mx5Xl =
    class "mx-xl-5"


{-| Set margin left and right to auto applicable from breakpoint XL.
-}
mxAutoXl : Attribute msg
mxAutoXl =
    class "mx-xl-auto"


{-| Set margin top and bottom to 0 applicable from breakpoint XL.
-}
my0Xl : Attribute msg
my0Xl =
    class "my-xl-0"


{-| Set margin top and bottom to 1 applicable from breakpoint XL.
-}
my1Xl : Attribute msg
my1Xl =
    class "my-xl-1"


{-| Set margin top and bottom to 2 applicable from breakpoint XL.
-}
my2Xl : Attribute msg
my2Xl =
    class "my-xl-2"


{-| Set margin top and bottom to 3 applicable from breakpoint XL.
-}
my3Xl : Attribute msg
my3Xl =
    class "my-xl-3"


{-| Set margin top and bottom to 4 applicable from breakpoint XL.
-}
my4Xl : Attribute msg
my4Xl =
    class "my-xl-4"


{-| Set margin top and bottom to 5 applicable from breakpoint XL.
-}
my5Xl : Attribute msg
my5Xl =
    class "my-xl-5"


{-| Set margin top and bottom to auto applicable from breakpoint XL.
-}
myAutoXl : Attribute msg
myAutoXl =
    class "my-xl-auto"


{-| Set padding to 0.
-}
p0 : Attribute msg
p0 =
    class "p-0"


{-| Set padding to 1.
-}
p1 : Attribute msg
p1 =
    class "p-1"


{-| Set padding to 2.
-}
p2 : Attribute msg
p2 =
    class "p-2"


{-| Set padding to 3.
-}
p3 : Attribute msg
p3 =
    class "p-3"


{-| Set padding to 4.
-}
p4 : Attribute msg
p4 =
    class "p-4"


{-| Set padding to 5.
-}
p5 : Attribute msg
p5 =
    class "p-5"


{-| Set padding top to 0.
-}
pt0 : Attribute msg
pt0 =
    class "pt-0"


{-| Set padding top to 1.
-}
pt1 : Attribute msg
pt1 =
    class "pt-1"


{-| Set padding top to 2.
-}
pt2 : Attribute msg
pt2 =
    class "pt-2"


{-| Set padding top to 3.
-}
pt3 : Attribute msg
pt3 =
    class "pt-3"


{-| Set padding top to 4.
-}
pt4 : Attribute msg
pt4 =
    class "pt-4"


{-| Set padding top to 5.
-}
pt5 : Attribute msg
pt5 =
    class "pt-5"


{-| Set padding bottom to 0.
-}
pb0 : Attribute msg
pb0 =
    class "pb-0"


{-| Set padding bottom to 1.
-}
pb1 : Attribute msg
pb1 =
    class "pb-1"


{-| Set padding bottom to 2.
-}
pb2 : Attribute msg
pb2 =
    class "pb-2"


{-| Set padding bottom to 3.
-}
pb3 : Attribute msg
pb3 =
    class "pb-3"


{-| Set padding bottom to 4.
-}
pb4 : Attribute msg
pb4 =
    class "pb-4"


{-| Set padding bottom to 5.
-}
pb5 : Attribute msg
pb5 =
    class "pb-5"


{-| Set padding left to 0.
-}
pl0 : Attribute msg
pl0 =
    class "pl-0"


{-| Set padding left to 1.
-}
pl1 : Attribute msg
pl1 =
    class "pl-1"


{-| Set padding left to 2.
-}
pl2 : Attribute msg
pl2 =
    class "pl-2"


{-| Set padding left to 3.
-}
pl3 : Attribute msg
pl3 =
    class "pl-3"


{-| Set padding left to 4.
-}
pl4 : Attribute msg
pl4 =
    class "pl-4"


{-| Set padding left to 5.
-}
pl5 : Attribute msg
pl5 =
    class "pl-5"


{-| Set padding right to 0.
-}
pr0 : Attribute msg
pr0 =
    class "pr-0"


{-| Set padding right to 1.
-}
pr1 : Attribute msg
pr1 =
    class "pr-1"


{-| Set padding right to 2.
-}
pr2 : Attribute msg
pr2 =
    class "pr-2"


{-| Set padding right to 3.
-}
pr3 : Attribute msg
pr3 =
    class "pr-3"


{-| Set padding right to 4.
-}
pr4 : Attribute msg
pr4 =
    class "pr-4"


{-| Set padding right to 5.
-}
pr5 : Attribute msg
pr5 =
    class "pr-5"


{-| Set padding left and right to 0.
-}
px0 : Attribute msg
px0 =
    class "px-0"


{-| Set padding left and right to 1.
-}
px1 : Attribute msg
px1 =
    class "px-1"


{-| Set padding left and right to 2.
-}
px2 : Attribute msg
px2 =
    class "px-2"


{-| Set padding left and right to 3.
-}
px3 : Attribute msg
px3 =
    class "px-3"


{-| Set padding left and right to 4.
-}
px4 : Attribute msg
px4 =
    class "px-4"


{-| Set padding left and right to 5.
-}
px5 : Attribute msg
px5 =
    class "px-5"


{-| Set padding top and bottom to 0.
-}
py0 : Attribute msg
py0 =
    class "py-0"


{-| Set padding top and bottom to 1.
-}
py1 : Attribute msg
py1 =
    class "py-1"


{-| Set padding top and bottom to 2.
-}
py2 : Attribute msg
py2 =
    class "py-2"


{-| Set padding top and bottom to 3.
-}
py3 : Attribute msg
py3 =
    class "py-3"


{-| Set padding top and bottom to 4.
-}
py4 : Attribute msg
py4 =
    class "py-4"


{-| Set padding top and bottom to 5.
-}
py5 : Attribute msg
py5 =
    class "py-5"


{-| Set padding to 0 applicable from breakpoint SM.
-}
p0Sm : Attribute msg
p0Sm =
    class "p-sm-0"


{-| Set padding to 1 applicable from breakpoint SM.
-}
p1Sm : Attribute msg
p1Sm =
    class "p-sm-1"


{-| Set padding to 2 applicable from breakpoint SM.
-}
p2Sm : Attribute msg
p2Sm =
    class "p-sm-2"


{-| Set padding to 3 applicable from breakpoint SM.
-}
p3Sm : Attribute msg
p3Sm =
    class "p-sm-3"


{-| Set padding to 4 applicable from breakpoint SM.
-}
p4Sm : Attribute msg
p4Sm =
    class "p-sm-4"


{-| Set padding to 5 applicable from breakpoint SM.
-}
p5Sm : Attribute msg
p5Sm =
    class "p-sm-5"


{-| Set padding top to 0 applicable from breakpoint SM.
-}
pt0Sm : Attribute msg
pt0Sm =
    class "pt-sm-0"


{-| Set padding top to 1 applicable from breakpoint SM.
-}
pt1Sm : Attribute msg
pt1Sm =
    class "pt-sm-1"


{-| Set padding top to 2 applicable from breakpoint SM.
-}
pt2Sm : Attribute msg
pt2Sm =
    class "pt-sm-2"


{-| Set padding top to 3 applicable from breakpoint SM.
-}
pt3Sm : Attribute msg
pt3Sm =
    class "pt-sm-3"


{-| Set padding top to 4 applicable from breakpoint SM.
-}
pt4Sm : Attribute msg
pt4Sm =
    class "pt-sm-4"


{-| Set padding top to 5 applicable from breakpoint SM.
-}
pt5Sm : Attribute msg
pt5Sm =
    class "pt-sm-5"


{-| Set padding bottom to 0 applicable from breakpoint SM.
-}
pb0Sm : Attribute msg
pb0Sm =
    class "pb-sm-0"


{-| Set padding bottom to 1 applicable from breakpoint SM.
-}
pb1Sm : Attribute msg
pb1Sm =
    class "pb-sm-1"


{-| Set padding bottom to 2 applicable from breakpoint SM.
-}
pb2Sm : Attribute msg
pb2Sm =
    class "pb-sm-2"


{-| Set padding bottom to 3 applicable from breakpoint SM.
-}
pb3Sm : Attribute msg
pb3Sm =
    class "pb-sm-3"


{-| Set padding bottom to 4 applicable from breakpoint SM.
-}
pb4Sm : Attribute msg
pb4Sm =
    class "pb-sm-4"


{-| Set padding bottom to 5 applicable from breakpoint SM.
-}
pb5Sm : Attribute msg
pb5Sm =
    class "pb-sm-5"


{-| Set padding left to 0 applicable from breakpoint SM.
-}
pl0Sm : Attribute msg
pl0Sm =
    class "pl-sm-0"


{-| Set padding left to 1 applicable from breakpoint SM.
-}
pl1Sm : Attribute msg
pl1Sm =
    class "pl-sm-1"


{-| Set padding left to 2 applicable from breakpoint SM.
-}
pl2Sm : Attribute msg
pl2Sm =
    class "pl-sm-2"


{-| Set padding left to 3 applicable from breakpoint SM.
-}
pl3Sm : Attribute msg
pl3Sm =
    class "pl-sm-3"


{-| Set padding left to 4 applicable from breakpoint SM.
-}
pl4Sm : Attribute msg
pl4Sm =
    class "pl-sm-4"


{-| Set padding left to 5 applicable from breakpoint SM.
-}
pl5Sm : Attribute msg
pl5Sm =
    class "pl-sm-5"


{-| Set padding right to 0 applicable from breakpoint SM.
-}
pr0Sm : Attribute msg
pr0Sm =
    class "pr-sm-0"


{-| Set padding right to 1 applicable from breakpoint SM.
-}
pr1Sm : Attribute msg
pr1Sm =
    class "pr-sm-1"


{-| Set padding right to 2 applicable from breakpoint SM.
-}
pr2Sm : Attribute msg
pr2Sm =
    class "pr-sm-2"


{-| Set padding right to 3 applicable from breakpoint SM.
-}
pr3Sm : Attribute msg
pr3Sm =
    class "pr-sm-3"


{-| Set padding right to 4 applicable from breakpoint SM.
-}
pr4Sm : Attribute msg
pr4Sm =
    class "pr-sm-4"


{-| Set padding right to 5 applicable from breakpoint SM.
-}
pr5Sm : Attribute msg
pr5Sm =
    class "pr-sm-5"


{-| Set padding left and right to 0 applicable from breakpoint SM.
-}
px0Sm : Attribute msg
px0Sm =
    class "px-sm-0"


{-| Set padding left and right to 1 applicable from breakpoint SM.
-}
px1Sm : Attribute msg
px1Sm =
    class "px-sm-1"


{-| Set padding left and right to 2 applicable from breakpoint SM.
-}
px2Sm : Attribute msg
px2Sm =
    class "px-sm-2"


{-| Set padding left and right to 3 applicable from breakpoint SM.
-}
px3Sm : Attribute msg
px3Sm =
    class "px-sm-3"


{-| Set padding left and right to 4 applicable from breakpoint SM.
-}
px4Sm : Attribute msg
px4Sm =
    class "px-sm-4"


{-| Set padding left and right to 5 applicable from breakpoint SM.
-}
px5Sm : Attribute msg
px5Sm =
    class "px-sm-5"


{-| Set padding top and bottom to 0 applicable from breakpoint SM.
-}
py0Sm : Attribute msg
py0Sm =
    class "py-sm-0"


{-| Set padding top and bottom to 1 applicable from breakpoint SM.
-}
py1Sm : Attribute msg
py1Sm =
    class "py-sm-1"


{-| Set padding top and bottom to 2 applicable from breakpoint SM.
-}
py2Sm : Attribute msg
py2Sm =
    class "py-sm-2"


{-| Set padding top and bottom to 3 applicable from breakpoint SM.
-}
py3Sm : Attribute msg
py3Sm =
    class "py-sm-3"


{-| Set padding top and bottom to 4 applicable from breakpoint SM.
-}
py4Sm : Attribute msg
py4Sm =
    class "py-sm-4"


{-| Set padding top and bottom to 5 applicable from breakpoint SM.
-}
py5Sm : Attribute msg
py5Sm =
    class "py-sm-5"


{-| Set padding to 0 applicable from breakpoint MD.
-}
p0Md : Attribute msg
p0Md =
    class "p-md-0"


{-| Set padding to 1 applicable from breakpoint MD.
-}
p1Md : Attribute msg
p1Md =
    class "p-md-1"


{-| Set padding to 2 applicable from breakpoint MD.
-}
p2Md : Attribute msg
p2Md =
    class "p-md-2"


{-| Set padding to 3 applicable from breakpoint MD.
-}
p3Md : Attribute msg
p3Md =
    class "p-md-3"


{-| Set padding to 4 applicable from breakpoint MD.
-}
p4Md : Attribute msg
p4Md =
    class "p-md-4"


{-| Set padding to 5 applicable from breakpoint MD.
-}
p5Md : Attribute msg
p5Md =
    class "p-md-5"


{-| Set padding top to 0 applicable from breakpoint MD.
-}
pt0Md : Attribute msg
pt0Md =
    class "pt-md-0"


{-| Set padding top to 1 applicable from breakpoint MD.
-}
pt1Md : Attribute msg
pt1Md =
    class "pt-md-1"


{-| Set padding top to 2 applicable from breakpoint MD.
-}
pt2Md : Attribute msg
pt2Md =
    class "pt-md-2"


{-| Set padding top to 3 applicable from breakpoint MD.
-}
pt3Md : Attribute msg
pt3Md =
    class "pt-md-3"


{-| Set padding top to 4 applicable from breakpoint MD.
-}
pt4Md : Attribute msg
pt4Md =
    class "pt-md-4"


{-| Set padding top to 5 applicable from breakpoint MD.
-}
pt5Md : Attribute msg
pt5Md =
    class "pt-md-5"


{-| Set padding bottom to 0 applicable from breakpoint MD.
-}
pb0Md : Attribute msg
pb0Md =
    class "pb-md-0"


{-| Set padding bottom to 1 applicable from breakpoint MD.
-}
pb1Md : Attribute msg
pb1Md =
    class "pb-md-1"


{-| Set padding bottom to 2 applicable from breakpoint MD.
-}
pb2Md : Attribute msg
pb2Md =
    class "pb-md-2"


{-| Set padding bottom to 3 applicable from breakpoint MD.
-}
pb3Md : Attribute msg
pb3Md =
    class "pb-md-3"


{-| Set padding bottom to 4 applicable from breakpoint MD.
-}
pb4Md : Attribute msg
pb4Md =
    class "pb-md-4"


{-| Set padding bottom to 5 applicable from breakpoint MD.
-}
pb5Md : Attribute msg
pb5Md =
    class "pb-md-5"


{-| Set padding left to 0 applicable from breakpoint MD.
-}
pl0Md : Attribute msg
pl0Md =
    class "pl-md-0"


{-| Set padding left to 1 applicable from breakpoint MD.
-}
pl1Md : Attribute msg
pl1Md =
    class "pl-md-1"


{-| Set padding left to 2 applicable from breakpoint MD.
-}
pl2Md : Attribute msg
pl2Md =
    class "pl-md-2"


{-| Set padding left to 3 applicable from breakpoint MD.
-}
pl3Md : Attribute msg
pl3Md =
    class "pl-md-3"


{-| Set padding left to 4 applicable from breakpoint MD.
-}
pl4Md : Attribute msg
pl4Md =
    class "pl-md-4"


{-| Set padding left to 5 applicable from breakpoint MD.
-}
pl5Md : Attribute msg
pl5Md =
    class "pl-md-5"


{-| Set padding right to 0 applicable from breakpoint MD.
-}
pr0Md : Attribute msg
pr0Md =
    class "pr-md-0"


{-| Set padding right to 1 applicable from breakpoint MD.
-}
pr1Md : Attribute msg
pr1Md =
    class "pr-md-1"


{-| Set padding right to 2 applicable from breakpoint MD.
-}
pr2Md : Attribute msg
pr2Md =
    class "pr-md-2"


{-| Set padding right to 3 applicable from breakpoint MD.
-}
pr3Md : Attribute msg
pr3Md =
    class "pr-md-3"


{-| Set padding right to 4 applicable from breakpoint MD.
-}
pr4Md : Attribute msg
pr4Md =
    class "pr-md-4"


{-| Set padding right to 5 applicable from breakpoint MD.
-}
pr5Md : Attribute msg
pr5Md =
    class "pr-md-5"


{-| Set padding left and right to 0 applicable from breakpoint MD.
-}
px0Md : Attribute msg
px0Md =
    class "px-md-0"


{-| Set padding left and right to 1 applicable from breakpoint MD.
-}
px1Md : Attribute msg
px1Md =
    class "px-md-1"


{-| Set padding left and right to 2 applicable from breakpoint MD.
-}
px2Md : Attribute msg
px2Md =
    class "px-md-2"


{-| Set padding left and right to 3 applicable from breakpoint MD.
-}
px3Md : Attribute msg
px3Md =
    class "px-md-3"


{-| Set padding left and right to 4 applicable from breakpoint MD.
-}
px4Md : Attribute msg
px4Md =
    class "px-md-4"


{-| Set padding left and right to 5 applicable from breakpoint MD.
-}
px5Md : Attribute msg
px5Md =
    class "px-md-5"


{-| Set padding top and bottom to 0 applicable from breakpoint MD.
-}
py0Md : Attribute msg
py0Md =
    class "py-md-0"


{-| Set padding top and bottom to 1 applicable from breakpoint MD.
-}
py1Md : Attribute msg
py1Md =
    class "py-md-1"


{-| Set padding top and bottom to 2 applicable from breakpoint MD.
-}
py2Md : Attribute msg
py2Md =
    class "py-md-2"


{-| Set padding top and bottom to 3 applicable from breakpoint MD.
-}
py3Md : Attribute msg
py3Md =
    class "py-md-3"


{-| Set padding top and bottom to 4 applicable from breakpoint MD.
-}
py4Md : Attribute msg
py4Md =
    class "py-md-4"


{-| Set padding top and bottom to 5 applicable from breakpoint MD.
-}
py5Md : Attribute msg
py5Md =
    class "py-md-5"


{-| Set padding to 0 applicable from breakpoint LG.
-}
p0Lg : Attribute msg
p0Lg =
    class "p-lg-0"


{-| Set padding to 1 applicable from breakpoint LG.
-}
p1Lg : Attribute msg
p1Lg =
    class "p-lg-1"


{-| Set padding to 2 applicable from breakpoint LG.
-}
p2Lg : Attribute msg
p2Lg =
    class "p-lg-2"


{-| Set padding to 3 applicable from breakpoint LG.
-}
p3Lg : Attribute msg
p3Lg =
    class "p-lg-3"


{-| Set padding to 4 applicable from breakpoint LG.
-}
p4Lg : Attribute msg
p4Lg =
    class "p-lg-4"


{-| Set padding to 5 applicable from breakpoint LG.
-}
p5Lg : Attribute msg
p5Lg =
    class "p-lg-5"


{-| Set padding top to 0 applicable from breakpoint LG.
-}
pt0Lg : Attribute msg
pt0Lg =
    class "pt-lg-0"


{-| Set padding top to 1 applicable from breakpoint LG.
-}
pt1Lg : Attribute msg
pt1Lg =
    class "pt-lg-1"


{-| Set padding top to 2 applicable from breakpoint LG.
-}
pt2Lg : Attribute msg
pt2Lg =
    class "pt-lg-2"


{-| Set padding top to 3 applicable from breakpoint LG.
-}
pt3Lg : Attribute msg
pt3Lg =
    class "pt-lg-3"


{-| Set padding top to 4 applicable from breakpoint LG.
-}
pt4Lg : Attribute msg
pt4Lg =
    class "pt-lg-4"


{-| Set padding top to 5 applicable from breakpoint LG.
-}
pt5Lg : Attribute msg
pt5Lg =
    class "pt-lg-5"


{-| Set padding bottom to 0 applicable from breakpoint LG.
-}
pb0Lg : Attribute msg
pb0Lg =
    class "pb-lg-0"


{-| Set padding bottom to 1 applicable from breakpoint LG.
-}
pb1Lg : Attribute msg
pb1Lg =
    class "pb-lg-1"


{-| Set padding bottom to 2 applicable from breakpoint LG.
-}
pb2Lg : Attribute msg
pb2Lg =
    class "pb-lg-2"


{-| Set padding bottom to 3 applicable from breakpoint LG.
-}
pb3Lg : Attribute msg
pb3Lg =
    class "pb-lg-3"


{-| Set padding bottom to 4 applicable from breakpoint LG.
-}
pb4Lg : Attribute msg
pb4Lg =
    class "pb-lg-4"


{-| Set padding bottom to 5 applicable from breakpoint LG.
-}
pb5Lg : Attribute msg
pb5Lg =
    class "pb-lg-5"


{-| Set padding left to 0 applicable from breakpoint LG.
-}
pl0Lg : Attribute msg
pl0Lg =
    class "pl-lg-0"


{-| Set padding left to 1 applicable from breakpoint LG.
-}
pl1Lg : Attribute msg
pl1Lg =
    class "pl-lg-1"


{-| Set padding left to 2 applicable from breakpoint LG.
-}
pl2Lg : Attribute msg
pl2Lg =
    class "pl-lg-2"


{-| Set padding left to 3 applicable from breakpoint LG.
-}
pl3Lg : Attribute msg
pl3Lg =
    class "pl-lg-3"


{-| Set padding left to 4 applicable from breakpoint LG.
-}
pl4Lg : Attribute msg
pl4Lg =
    class "pl-lg-4"


{-| Set padding left to 5 applicable from breakpoint LG.
-}
pl5Lg : Attribute msg
pl5Lg =
    class "pl-lg-5"


{-| Set padding right to 0 applicable from breakpoint LG.
-}
pr0Lg : Attribute msg
pr0Lg =
    class "pr-lg-0"


{-| Set padding right to 1 applicable from breakpoint LG.
-}
pr1Lg : Attribute msg
pr1Lg =
    class "pr-lg-1"


{-| Set padding right to 2 applicable from breakpoint LG.
-}
pr2Lg : Attribute msg
pr2Lg =
    class "pr-lg-2"


{-| Set padding right to 3 applicable from breakpoint LG.
-}
pr3Lg : Attribute msg
pr3Lg =
    class "pr-lg-3"


{-| Set padding right to 4 applicable from breakpoint LG.
-}
pr4Lg : Attribute msg
pr4Lg =
    class "pr-lg-4"


{-| Set padding right to 5 applicable from breakpoint LG.
-}
pr5Lg : Attribute msg
pr5Lg =
    class "pr-lg-5"


{-| Set padding left and right to 0 applicable from breakpoint LG.
-}
px0Lg : Attribute msg
px0Lg =
    class "px-lg-0"


{-| Set padding left and right to 1 applicable from breakpoint LG.
-}
px1Lg : Attribute msg
px1Lg =
    class "px-lg-1"


{-| Set padding left and right to 2 applicable from breakpoint LG.
-}
px2Lg : Attribute msg
px2Lg =
    class "px-lg-2"


{-| Set padding left and right to 3 applicable from breakpoint LG.
-}
px3Lg : Attribute msg
px3Lg =
    class "px-lg-3"


{-| Set padding left and right to 4 applicable from breakpoint LG.
-}
px4Lg : Attribute msg
px4Lg =
    class "px-lg-4"


{-| Set padding left and right to 5 applicable from breakpoint LG.
-}
px5Lg : Attribute msg
px5Lg =
    class "px-lg-5"


{-| Set padding top and bottom to 0 applicable from breakpoint LG.
-}
py0Lg : Attribute msg
py0Lg =
    class "py-lg-0"


{-| Set padding top and bottom to 1 applicable from breakpoint LG.
-}
py1Lg : Attribute msg
py1Lg =
    class "py-lg-1"


{-| Set padding top and bottom to 2 applicable from breakpoint LG.
-}
py2Lg : Attribute msg
py2Lg =
    class "py-lg-2"


{-| Set padding top and bottom to 3 applicable from breakpoint LG.
-}
py3Lg : Attribute msg
py3Lg =
    class "py-lg-3"


{-| Set padding top and bottom to 4 applicable from breakpoint LG.
-}
py4Lg : Attribute msg
py4Lg =
    class "py-lg-4"


{-| Set padding top and bottom to 5 applicable from breakpoint LG.
-}
py5Lg : Attribute msg
py5Lg =
    class "py-lg-5"


{-| Set padding to 0 applicable from breakpoint XL.
-}
p0Xl : Attribute msg
p0Xl =
    class "p-xl-0"


{-| Set padding to 1 applicable from breakpoint XL.
-}
p1Xl : Attribute msg
p1Xl =
    class "p-xl-1"


{-| Set padding to 2 applicable from breakpoint XL.
-}
p2Xl : Attribute msg
p2Xl =
    class "p-xl-2"


{-| Set padding to 3 applicable from breakpoint XL.
-}
p3Xl : Attribute msg
p3Xl =
    class "p-xl-3"


{-| Set padding to 4 applicable from breakpoint XL.
-}
p4Xl : Attribute msg
p4Xl =
    class "p-xl-4"


{-| Set padding to 5 applicable from breakpoint XL.
-}
p5Xl : Attribute msg
p5Xl =
    class "p-xl-5"


{-| Set padding top to 0 applicable from breakpoint XL.
-}
pt0Xl : Attribute msg
pt0Xl =
    class "pt-xl-0"


{-| Set padding top to 1 applicable from breakpoint XL.
-}
pt1Xl : Attribute msg
pt1Xl =
    class "pt-xl-1"


{-| Set padding top to 2 applicable from breakpoint XL.
-}
pt2Xl : Attribute msg
pt2Xl =
    class "pt-xl-2"


{-| Set padding top to 3 applicable from breakpoint XL.
-}
pt3Xl : Attribute msg
pt3Xl =
    class "pt-xl-3"


{-| Set padding top to 4 applicable from breakpoint XL.
-}
pt4Xl : Attribute msg
pt4Xl =
    class "pt-xl-4"


{-| Set padding top to 5 applicable from breakpoint XL.
-}
pt5Xl : Attribute msg
pt5Xl =
    class "pt-xl-5"


{-| Set padding bottom to 0 applicable from breakpoint XL.
-}
pb0Xl : Attribute msg
pb0Xl =
    class "pb-xl-0"


{-| Set padding bottom to 1 applicable from breakpoint XL.
-}
pb1Xl : Attribute msg
pb1Xl =
    class "pb-xl-1"


{-| Set padding bottom to 2 applicable from breakpoint XL.
-}
pb2Xl : Attribute msg
pb2Xl =
    class "pb-xl-2"


{-| Set padding bottom to 3 applicable from breakpoint XL.
-}
pb3Xl : Attribute msg
pb3Xl =
    class "pb-xl-3"


{-| Set padding bottom to 4 applicable from breakpoint XL.
-}
pb4Xl : Attribute msg
pb4Xl =
    class "pb-xl-4"


{-| Set padding bottom to 5 applicable from breakpoint XL.
-}
pb5Xl : Attribute msg
pb5Xl =
    class "pb-xl-5"


{-| Set padding left to 0 applicable from breakpoint XL.
-}
pl0Xl : Attribute msg
pl0Xl =
    class "pl-xl-0"


{-| Set padding left to 1 applicable from breakpoint XL.
-}
pl1Xl : Attribute msg
pl1Xl =
    class "pl-xl-1"


{-| Set padding left to 2 applicable from breakpoint XL.
-}
pl2Xl : Attribute msg
pl2Xl =
    class "pl-xl-2"


{-| Set padding left to 3 applicable from breakpoint XL.
-}
pl3Xl : Attribute msg
pl3Xl =
    class "pl-xl-3"


{-| Set padding left to 4 applicable from breakpoint XL.
-}
pl4Xl : Attribute msg
pl4Xl =
    class "pl-xl-4"


{-| Set padding left to 5 applicable from breakpoint XL.
-}
pl5Xl : Attribute msg
pl5Xl =
    class "pl-xl-5"


{-| Set padding right to 0 applicable from breakpoint XL.
-}
pr0Xl : Attribute msg
pr0Xl =
    class "pr-xl-0"


{-| Set padding right to 1 applicable from breakpoint XL.
-}
pr1Xl : Attribute msg
pr1Xl =
    class "pr-xl-1"


{-| Set padding right to 2 applicable from breakpoint XL.
-}
pr2Xl : Attribute msg
pr2Xl =
    class "pr-xl-2"


{-| Set padding right to 3 applicable from breakpoint XL.
-}
pr3Xl : Attribute msg
pr3Xl =
    class "pr-xl-3"


{-| Set padding right to 4 applicable from breakpoint XL.
-}
pr4Xl : Attribute msg
pr4Xl =
    class "pr-xl-4"


{-| Set padding right to 5 applicable from breakpoint XL.
-}
pr5Xl : Attribute msg
pr5Xl =
    class "pr-xl-5"


{-| Set padding left and right to 0 applicable from breakpoint XL.
-}
px0Xl : Attribute msg
px0Xl =
    class "px-xl-0"


{-| Set padding left and right to 1 applicable from breakpoint XL.
-}
px1Xl : Attribute msg
px1Xl =
    class "px-xl-1"


{-| Set padding left and right to 2 applicable from breakpoint XL.
-}
px2Xl : Attribute msg
px2Xl =
    class "px-xl-2"


{-| Set padding left and right to 3 applicable from breakpoint XL.
-}
px3Xl : Attribute msg
px3Xl =
    class "px-xl-3"


{-| Set padding left and right to 4 applicable from breakpoint XL.
-}
px4Xl : Attribute msg
px4Xl =
    class "px-xl-4"


{-| Set padding left and right to 5 applicable from breakpoint XL.
-}
px5Xl : Attribute msg
px5Xl =
    class "px-xl-5"


{-| Set padding top and bottom to 0 applicable from breakpoint XL.
-}
py0Xl : Attribute msg
py0Xl =
    class "py-xl-0"


{-| Set padding top and bottom to 1 applicable from breakpoint XL.
-}
py1Xl : Attribute msg
py1Xl =
    class "py-xl-1"


{-| Set padding top and bottom to 2 applicable from breakpoint XL.
-}
py2Xl : Attribute msg
py2Xl =
    class "py-xl-2"


{-| Set padding top and bottom to 3 applicable from breakpoint XL.
-}
py3Xl : Attribute msg
py3Xl =
    class "py-xl-3"


{-| Set padding top and bottom to 4 applicable from breakpoint XL.
-}
py4Xl : Attribute msg
py4Xl =
    class "py-xl-4"


{-| Set padding top and bottom to 5 applicable from breakpoint XL.
-}
py5Xl : Attribute msg
py5Xl =
    class "py-xl-5"
