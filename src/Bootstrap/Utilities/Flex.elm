module Bootstrap.Utilities.Flex exposing
    ( block, blockSm, blockMd, blockLg, blockXl
    , inline, inlineSm, inlineMd, inlineLg, inlineXl
    , row, rowSm, rowMd, rowLg, rowXl, rowReverse, rowReverseSm, rowReverseMd, rowReverseLg, rowReverseXl, col, colSm, colMd, colLg, colXl, colReverse, colReverseSm, colReverseMd, colReverseLg, colReverseXl
    , justifyStart, justifyStartSm, justifyStartMd, justifyStartLg, justifyStartXl, justifyEnd, justifyEndSm, justifyEndMd, justifyEndLg, justifyEndXl, justifyCenter, justifyCenterSm, justifyCenterMd, justifyCenterLg, justifyCenterXl, justifyBetween, justifyBetweenSm, justifyBetweenMd, justifyBetweenLg, justifyBetweenXl, justifyAround, justifyAroundSm, justifyAroundMd, justifyAroundLg, justifyAroundXl
    , alignItemsStart, alignItemsStartSm, alignItemsStartMd, alignItemsStartLg, alignItemsStartXl, alignItemsEnd, alignItemsEndSm, alignItemsEndMd, alignItemsEndLg, alignItemsEndXl, alignItemsCenter, alignItemsCenterSm, alignItemsCenterMd, alignItemsCenterLg, alignItemsCenterXl, alignItemsBaseline, alignItemsBaselineSm, alignItemsBaselineMd, alignItemsBaselineLg, alignItemsBaselineXl, alignItemsStretch, alignItemsStretchSm, alignItemsStretchMd, alignItemsStretchLg, alignItemsStretchXl
    , wrap, wrapSm, wrapMd, wrapLg, wrapXl, wrapReverse, wrapReverseSm, wrapReverseMd, wrapReverseLg, wrapReverseXl, nowrap, nowrapSm, nowrapMd, nowrapLg, nowrapXl
    , alignSelfStart, alignSelfStartSm, alignSelfStartMd, alignSelfStartLg, alignSelfStartXl, alignSelfEnd, alignSelfEndSm, alignSelfEndMd, alignSelfEndLg, alignSelfEndXl, alignSelfCenter, alignSelfCenterSm, alignSelfCenterMd, alignSelfCenterLg, alignSelfCenterXl, alignSelfBaseline, alignSelfBaselineSm, alignSelfBaselineMd, alignSelfBaselineLg, alignSelfBaselineXl, alignSelfStretch, alignSelfStretchSm, alignSelfStretchMd, alignSelfStretchLg, alignSelfStretchXl
    )

{-| Quickly manage the layout, alignment, and sizing of grid columns, navigation, components, and more with a full suite of responsive flexbox utilities. For more complex implementations, custom CSS may be necessary.


# Flex containers


## Block containers

@docs block, blockSm, blockMd, blockLg, blockXl


## Inline containers

@docs inline, inlineSm, inlineMd, inlineLg, inlineXl


## Direction

@docs row, rowSm, rowMd, rowLg, rowXl, rowReverse, rowReverseSm, rowReverseMd, rowReverseLg, rowReverseXl, col, colSm, colMd, colLg, colXl, colReverse, colReverseSm, colReverseMd, colReverseLg, colReverseXl


## Justify content

Use justify-content utilities on flexbox containers to change the alignment of flex items on the main axis (the x-axis to start y-axis if flex-direction: column). Choose from start (browser default)/ end / center / between / or around.

@docs justifyStart, justifyStartSm, justifyStartMd, justifyStartLg, justifyStartXl, justifyEnd, justifyEndSm, justifyEndMd, justifyEndLg, justifyEndXl, justifyCenter, justifyCenterSm, justifyCenterMd, justifyCenterLg, justifyCenterXl, justifyBetween, justifyBetweenSm, justifyBetweenMd, justifyBetweenLg, justifyBetweenXl, justifyAround, justifyAroundSm, justifyAroundMd, justifyAroundLg, justifyAroundXl


## Align items

Use align-items utilities on flexbox containers to change the alignment of flex items on the cross axis (the y-axis to start or x-axis if flex-direction: column). Choose from start / end / center / baseline / or stretch (browser default).

@docs alignItemsStart, alignItemsStartSm, alignItemsStartMd, alignItemsStartLg, alignItemsStartXl, alignItemsEnd, alignItemsEndSm, alignItemsEndMd, alignItemsEndLg, alignItemsEndXl, alignItemsCenter, alignItemsCenterSm, alignItemsCenterMd, alignItemsCenterLg, alignItemsCenterXl, alignItemsBaseline, alignItemsBaselineSm, alignItemsBaselineMd, alignItemsBaselineLg, alignItemsBaselineXl, alignItemsStretch, alignItemsStretchSm, alignItemsStretchMd, alignItemsStretchLg, alignItemsStretchXl


## Wrapping

Change how flex items wrap in a flex container. Choose from no wrapping at all (the browser default) with nowrap / wrap or reverse wrapping.

@docs wrap, wrapSm, wrapMd, wrapLg, wrapXl, wrapReverse, wrapReverseSm, wrapReverseMd, wrapReverseLg, wrapReverseXl, nowrap, nowrapSm, nowrapMd, nowrapLg, nowrapXl


# Item level


## Align self

Use align-self utilities on flexbox items to individually change their alignment on the cross axis (the y-axis to start or x-axis if flex-direction: column). Choose from the same options as align-items: start / end / center / baseline / or stretch (browser default).

@docs alignSelfStart, alignSelfStartSm, alignSelfStartMd, alignSelfStartLg, alignSelfStartXl, alignSelfEnd, alignSelfEndSm, alignSelfEndMd, alignSelfEndLg, alignSelfEndXl, alignSelfCenter, alignSelfCenterSm, alignSelfCenterMd, alignSelfCenterLg, alignSelfCenterXl, alignSelfBaseline, alignSelfBaselineSm, alignSelfBaselineMd, alignSelfBaselineLg, alignSelfBaselineXl, alignSelfStretch, alignSelfStretchSm, alignSelfStretchMd, alignSelfStretchLg, alignSelfStretchXl

-}

import Html exposing (Attribute)
import Html.Attributes exposing (class)


{-| Make an element become a flex container (whilst being a block level element).
-}
block : Attribute msg
block =
    class "d-flex"


{-| Make an element become a flex container (whilst being a block level element) from SM breakpoint and up.
-}
blockSm : Attribute msg
blockSm =
    class "d-sm-flex"


{-| Make an element become a flex container (whilst being a block level element) from MD breakpoint and up.
-}
blockMd : Attribute msg
blockMd =
    class "d-md-flex"


{-| Make an element become a flex container (whilst being a block level element) from LG breakpoint and up.
-}
blockLg : Attribute msg
blockLg =
    class "d-lg-flex"


{-| Make an element become a flex container (whilst being a block level element) from XL breakpoint and up.
-}
blockXl : Attribute msg
blockXl =
    class "d-xl-flex"


{-| Make and element become a flex container (whilst being an inline element).
-}
inline : Attribute msg
inline =
    class "d-inline-flex"


{-| Make and element become a flex container (whilst being an inline element) from SM breakpoint and up.
-}
inlineSm : Attribute msg
inlineSm =
    class "d-sm-inline-flex"


{-| Make and element become a flex container (whilst being an inline element) from MD breakpoint and up.
-}
inlineMd : Attribute msg
inlineMd =
    class "d-md-inline-flex"


{-| Make and element become a flex container (whilst being an inline element) from LG breakpoint and up.
-}
inlineLg : Attribute msg
inlineLg =
    class "d-lg-inline-flex"


{-| Make and element become a flex container (whilst being an inline element) from XL breakpoint and up.
-}
inlineXl : Attribute msg
inlineXl =
    class "d-xl-inline-flex"


{-| Set flex direction to row.
-}
row : Attribute msg
row =
    class "flex-row"


{-| Set flex direction to row from SM breakpoint and up.
-}
rowSm : Attribute msg
rowSm =
    class "flex-sm-row"


{-| Set flex direction to row from MD breakpoint and up.
-}
rowMd : Attribute msg
rowMd =
    class "flex-md-row"


{-| Set flex direction to row from LG breakpoint and up.
-}
rowLg : Attribute msg
rowLg =
    class "flex-lg-row"


{-| Set flex direction to row from XL breakpoint and up.
-}
rowXl : Attribute msg
rowXl =
    class "flex-xl-row"


{-| Set flex direction to row-reverse (starting from the oposite side).
-}
rowReverse : Attribute msg
rowReverse =
    class "flex-row-reverse"


{-| Set flex direction to row-reverse (starting from the oposite side) from SM breakpoint and up.
-}
rowReverseSm : Attribute msg
rowReverseSm =
    class "flex-sm-row-reverse"


{-| Set flex direction to row-reverse (starting from the oposite side) from MD breakpoint and up.
-}
rowReverseMd : Attribute msg
rowReverseMd =
    class "flex-md-row-reverse"


{-| Set flex direction to row-reverse (starting from the oposite side) from LG breakpoint and up.
-}
rowReverseLg : Attribute msg
rowReverseLg =
    class "flex-lg-row-reverse"


{-| Set flex direction to row-reverse (starting from the oposite side) from XL breakpoint and up.
-}
rowReverseXl : Attribute msg
rowReverseXl =
    class "flex-xl-row-reverse"


{-| Set flex direction to flex-column.
-}
col : Attribute msg
col =
    class "flex-column"


{-| Set flex direction to flex-column from SM breakpoint and up.
-}
colSm : Attribute msg
colSm =
    class "flex-sm-column"


{-| Set flex direction to flex-column from MD breakpoint and up.
-}
colMd : Attribute msg
colMd =
    class "flex-md-column"


{-| Set flex direction to flex-column from LG breakpoint and up.
-}
colLg : Attribute msg
colLg =
    class "flex-lg-column"


{-| Set flex direction to flex-column from XL breakpoint and up.
-}
colXl : Attribute msg
colXl =
    class "flex-xl-column"


{-| Set flex direction to flex-column-reverse.
-}
colReverse : Attribute msg
colReverse =
    class "flex-column-reverse"


{-| Set flex direction to flex-column-reverse from SM breakpoint and up.
-}
colReverseSm : Attribute msg
colReverseSm =
    class "flex-sm-column-reverse"


{-| Set flex direction to flex-column-reverse from MD breakpoint and up.
-}
colReverseMd : Attribute msg
colReverseMd =
    class "flex-md-column-reverse"


{-| Set flex direction to flex-column-reverse from LG breakpoint and up.
-}
colReverseLg : Attribute msg
colReverseLg =
    class "flex-lg-column-reverse"


{-| Set flex direction to flex-column-reverse from XL breakpoint and up.
-}
colReverseXl : Attribute msg
colReverseXl =
    class "flex-xl-column-reverse"


{-| Set main axis alignment for items in flexbox container to start.
-}
justifyStart : Attribute msg
justifyStart =
    class "justify-content-start"


{-| Set main axis alignment for items in flexbox container to start. Applicable from breakpoint SM and up.
-}
justifyStartSm : Attribute msg
justifyStartSm =
    class "justify-content-sm-start"


{-| Set main axis alignment for items in flexbox container to start. Applicable from breakpoint MD and up.
-}
justifyStartMd : Attribute msg
justifyStartMd =
    class "justify-content-md-start"


{-| Set main axis alignment for items in flexbox container to start. Applicable from breakpoint LG and up.
-}
justifyStartLg : Attribute msg
justifyStartLg =
    class "justify-content-lg-start"


{-| Set main axis alignment for items in flexbox container to start. Applicable from breakpoint XL and up.
-}
justifyStartXl : Attribute msg
justifyStartXl =
    class "justify-content-xl-start"


{-| Set main axis alignment for items in flexbox container to end
-}
justifyEnd : Attribute msg
justifyEnd =
    class "justify-content-end"


{-| Set main axis alignment for items in flexbox container to end. Applicable from breakpoint SM and up.
-}
justifyEndSm : Attribute msg
justifyEndSm =
    class "justify-content-sm-end"


{-| Set main axis alignment for items in flexbox container to end. Applicable from breakpoint MD and up.
-}
justifyEndMd : Attribute msg
justifyEndMd =
    class "justify-content-md-end"


{-| Set main axis alignment for items in flexbox container to end. Applicable from breakpoint LG and up.
-}
justifyEndLg : Attribute msg
justifyEndLg =
    class "justify-content-lg-end"


{-| Set main axis alignment for items in flexbox container to end. Applicable from breakpoint XL and up.
-}
justifyEndXl : Attribute msg
justifyEndXl =
    class "justify-content-xl-end"


{-| Set main axis alignment for items in flexbox container to center.
-}
justifyCenter : Attribute msg
justifyCenter =
    class "justify-content-center"


{-| Set main axis alignment for items in flexbox container to center. Applicable from breakpoint SM and up.
-}
justifyCenterSm : Attribute msg
justifyCenterSm =
    class "justify-content-sm-center"


{-| Set main axis alignment for items in flexbox container to center. Applicable from breakpoint MD and up.
-}
justifyCenterMd : Attribute msg
justifyCenterMd =
    class "justify-content-md-center"


{-| Set main axis alignment for items in flexbox container to center. Applicable from breakpoint LG and up.
-}
justifyCenterLg : Attribute msg
justifyCenterLg =
    class "justify-content-lg-center"


{-| Set main axis alignment for items in flexbox container to center. Applicable from breakpoint XL and up.
-}
justifyCenterXl : Attribute msg
justifyCenterXl =
    class "justify-content-xl-center"


{-| Set main axis alignment for items in flexbox container to between.
-}
justifyBetween : Attribute msg
justifyBetween =
    class "justify-content-between"


{-| Set main axis alignment for items in flexbox container to between. Applicable from breakpoint SM and up.
-}
justifyBetweenSm : Attribute msg
justifyBetweenSm =
    class "justify-content-sm-between"


{-| Set main axis alignment for items in flexbox container to between. Applicable from breakpoint MD and up.
-}
justifyBetweenMd : Attribute msg
justifyBetweenMd =
    class "justify-content-md-between"


{-| Set main axis alignment for items in flexbox container to between. Applicable from breakpoint LG and up.
-}
justifyBetweenLg : Attribute msg
justifyBetweenLg =
    class "justify-content-lg-between"


{-| Set main axis alignment for items in flexbox container to between. Applicable from breakpoint XL and up.
-}
justifyBetweenXl : Attribute msg
justifyBetweenXl =
    class "justify-content-xl-between"


{-| Set main axis alignment for items in flexbox container to around.
-}
justifyAround : Attribute msg
justifyAround =
    class "justify-content-around"


{-| Set main axis alignment for items in flexbox container to around. Applicable from breakpoint SM and up.
-}
justifyAroundSm : Attribute msg
justifyAroundSm =
    class "justify-content-sm-around"


{-| Set main axis alignment for items in flexbox container to around. Applicable from breakpoint MD and up.
-}
justifyAroundMd : Attribute msg
justifyAroundMd =
    class "justify-content-md-around"


{-| Set main axis alignment for items in flexbox container to around. Applicable from breakpoint LG and up.
-}
justifyAroundLg : Attribute msg
justifyAroundLg =
    class "justify-content-lg-around"


{-| Set main axis alignment for items in flexbox container to around. Applicable from breakpoint XL and up.
-}
justifyAroundXl : Attribute msg
justifyAroundXl =
    class "justify-content-xl-around"


{-| Set cross axis alignment for items in flexbox container to start.
-}
alignItemsStart : Attribute msg
alignItemsStart =
    class "align-items-start"


{-| Set cross axis alignment for items in flexbox container to start. Applicable from breakpoint SM and up.
-}
alignItemsStartSm : Attribute msg
alignItemsStartSm =
    class "align-items-sm-start"


{-| Set cross axis alignment for items in flexbox container to start. Applicable from breakpoint MD and up.
-}
alignItemsStartMd : Attribute msg
alignItemsStartMd =
    class "align-items-md-start"


{-| Set cross axis alignment for items in flexbox container to start. Applicable from breakpoint LG and up.
-}
alignItemsStartLg : Attribute msg
alignItemsStartLg =
    class "align-items-lg-start"


{-| Set cross axis alignment for items in flexbox container to start. Applicable from breakpoint LG and up.
-}
alignItemsStartXl : Attribute msg
alignItemsStartXl =
    class "align-items-xl-start"


{-| Set cross axis alignment for items in flexbox container to end.
-}
alignItemsEnd : Attribute msg
alignItemsEnd =
    class "align-items-end"


{-| Set cross axis alignment for items in flexbox container to end. Applicable from breakpoint SM and up.
-}
alignItemsEndSm : Attribute msg
alignItemsEndSm =
    class "align-items-sm-end"


{-| Set cross axis alignment for items in flexbox container to end. Applicable from breakpoint MD and up.
-}
alignItemsEndMd : Attribute msg
alignItemsEndMd =
    class "align-items-md-end"


{-| Set cross axis alignment for items in flexbox container to end. Applicable from breakpoint LG and up.
-}
alignItemsEndLg : Attribute msg
alignItemsEndLg =
    class "align-items-lg-end"


{-| Set cross axis alignment for items in flexbox container to end. Applicable from breakpoint LG and up.
-}
alignItemsEndXl : Attribute msg
alignItemsEndXl =
    class "align-items-xl-end"


{-| Set cross axis alignment for items in flexbox container to center.
-}
alignItemsCenter : Attribute msg
alignItemsCenter =
    class "align-items-center"


{-| Set cross axis alignment for items in flexbox container to center. Applicable from breakpoint SM and up.
-}
alignItemsCenterSm : Attribute msg
alignItemsCenterSm =
    class "align-items-sm-center"


{-| Set cross axis alignment for items in flexbox container to center. Applicable from breakpoint MD and up.
-}
alignItemsCenterMd : Attribute msg
alignItemsCenterMd =
    class "align-items-md-center"


{-| Set cross axis alignment for items in flexbox container to center. Applicable from breakpoint LG and up.
-}
alignItemsCenterLg : Attribute msg
alignItemsCenterLg =
    class "align-items-lg-center"


{-| Set cross axis alignment for items in flexbox container to center. Applicable from breakpoint LG and up.
-}
alignItemsCenterXl : Attribute msg
alignItemsCenterXl =
    class "align-items-xl-center"


{-| Set cross axis alignment for items in flexbox container to baseline.
-}
alignItemsBaseline : Attribute msg
alignItemsBaseline =
    class "align-items-baseline"


{-| Set cross axis alignment for items in flexbox container to baseline. Applicable from breakpoint SM and up.
-}
alignItemsBaselineSm : Attribute msg
alignItemsBaselineSm =
    class "align-items-sm-baseline"


{-| Set cross axis alignment for items in flexbox container to baseline. Applicable from breakpoint MD and up.
-}
alignItemsBaselineMd : Attribute msg
alignItemsBaselineMd =
    class "align-items-md-baseline"


{-| Set cross axis alignment for items in flexbox container to baseline. Applicable from breakpoint LG and up.
-}
alignItemsBaselineLg : Attribute msg
alignItemsBaselineLg =
    class "align-items-lg-baseline"


{-| Set cross axis alignment for items in flexbox container to baseline. Applicable from breakpoint LG and up.
-}
alignItemsBaselineXl : Attribute msg
alignItemsBaselineXl =
    class "align-items-xl-baseline"


{-| Set cross axis alignment for items in flexbox container to stretched.
-}
alignItemsStretch : Attribute msg
alignItemsStretch =
    class "align-items-stretched"


{-| Set cross axis alignment for items in flexbox container to stretched. Applicable from breakpoint SM and up.
-}
alignItemsStretchSm : Attribute msg
alignItemsStretchSm =
    class "align-items-sm-stretched"


{-| Set cross axis alignment for items in flexbox container to stretched. Applicable from breakpoint MD and up.
-}
alignItemsStretchMd : Attribute msg
alignItemsStretchMd =
    class "align-items-md-stretched"


{-| Set cross axis alignment for items in flexbox container to stretched. Applicable from breakpoint LG and up.
-}
alignItemsStretchLg : Attribute msg
alignItemsStretchLg =
    class "align-items-lg-stretched"


{-| Set cross axis alignment for items in flexbox container to stretched. Applicable from breakpoint LG and up.
-}
alignItemsStretchXl : Attribute msg
alignItemsStretchXl =
    class "align-items-xl-stretched"


{-| Set cross axis alignment for an individual flex item in a flexbox container to start.
-}
alignSelfStart : Attribute msg
alignSelfStart =
    class "align-self-start"


{-| Set cross axis alignment for an individual flex item in a flexbox container to start. Applicable from breakpoint SM and up.
-}
alignSelfStartSm : Attribute msg
alignSelfStartSm =
    class "align-self-sm-start"


{-| Set cross axis alignment for an individual flex item in a flexbox container to start. Applicable from breakpoint MD and up.
-}
alignSelfStartMd : Attribute msg
alignSelfStartMd =
    class "align-self-md-start"


{-| Set cross axis alignment for an individual flex item in a flexbox container to start. Applicable from breakpoint LG and up.
-}
alignSelfStartLg : Attribute msg
alignSelfStartLg =
    class "align-self-lg-start"


{-| Set cross axis alignment for an individual flex item in a flexbox container to start. Applicable from breakpoint LG and up.
-}
alignSelfStartXl : Attribute msg
alignSelfStartXl =
    class "align-self-xl-start"


{-| Set cross axis alignment for an individual flex item in a flexbox container to end.
-}
alignSelfEnd : Attribute msg
alignSelfEnd =
    class "align-self-end"


{-| Set cross axis alignment for an individual flex item in a flexbox container to end. Applicable from breakpoint SM and up.
-}
alignSelfEndSm : Attribute msg
alignSelfEndSm =
    class "align-self-sm-end"


{-| Set cross axis alignment for an individual flex item in a flexbox container to end. Applicable from breakpoint MD and up.
-}
alignSelfEndMd : Attribute msg
alignSelfEndMd =
    class "align-self-md-end"


{-| Set cross axis alignment for an individual flex item in a flexbox container to end. Applicable from breakpoint LG and up.
-}
alignSelfEndLg : Attribute msg
alignSelfEndLg =
    class "align-self-lg-end"


{-| Set cross axis alignment for an individual flex item in a flexbox container to end. Applicable from breakpoint LG and up.
-}
alignSelfEndXl : Attribute msg
alignSelfEndXl =
    class "align-self-xl-end"


{-| Set cross axis alignment for an individual flex item in a flexbox container to center.
-}
alignSelfCenter : Attribute msg
alignSelfCenter =
    class "align-self-center"


{-| Set cross axis alignment for an individual flex item in a flexbox container to center. Applicable from breakpoint SM and up.
-}
alignSelfCenterSm : Attribute msg
alignSelfCenterSm =
    class "align-self-sm-center"


{-| Set cross axis alignment for an individual flex item in a flexbox container to center. Applicable from breakpoint MD and up.
-}
alignSelfCenterMd : Attribute msg
alignSelfCenterMd =
    class "align-self-md-center"


{-| Set cross axis alignment for an individual flex item in a flexbox container to center. Applicable from breakpoint LG and up.
-}
alignSelfCenterLg : Attribute msg
alignSelfCenterLg =
    class "align-self-lg-center"


{-| Set cross axis alignment for an individual flex item in a flexbox container to center. Applicable from breakpoint LG and up.
-}
alignSelfCenterXl : Attribute msg
alignSelfCenterXl =
    class "align-self-xl-center"


{-| Set cross axis alignment for an individual flex item in a flexbox container to baseline.
-}
alignSelfBaseline : Attribute msg
alignSelfBaseline =
    class "align-self-baseline"


{-| Set cross axis alignment for an individual flex item in a flexbox container to baseline. Applicable from breakpoint SM and up.
-}
alignSelfBaselineSm : Attribute msg
alignSelfBaselineSm =
    class "align-self-sm-baseline"


{-| Set cross axis alignment for an individual flex item in a flexbox container to baseline. Applicable from breakpoint MD and up.
-}
alignSelfBaselineMd : Attribute msg
alignSelfBaselineMd =
    class "align-self-md-baseline"


{-| Set cross axis alignment for an individual flex item in a flexbox container to baseline. Applicable from breakpoint LG and up.
-}
alignSelfBaselineLg : Attribute msg
alignSelfBaselineLg =
    class "align-self-lg-baseline"


{-| Set cross axis alignment for an individual flex item in a flexbox container to baseline. Applicable from breakpoint LG and up.
-}
alignSelfBaselineXl : Attribute msg
alignSelfBaselineXl =
    class "align-self-xl-baseline"


{-| Set cross axis alignment for an individual flex item in a flexbox container to stretch.
-}
alignSelfStretch : Attribute msg
alignSelfStretch =
    class "align-self-stretch"


{-| Set cross axis alignment for an individual flex item in a flexbox container to stretch. Applicable from breakpoint SM and up.
-}
alignSelfStretchSm : Attribute msg
alignSelfStretchSm =
    class "align-self-sm-stretch"


{-| Set cross axis alignment for an individual flex item in a flexbox container to stretch. Applicable from breakpoint MD and up.
-}
alignSelfStretchMd : Attribute msg
alignSelfStretchMd =
    class "align-self-md-stretch"


{-| Set cross axis alignment for an individual flex item in a flexbox container to stretch. Applicable from breakpoint LG and up.
-}
alignSelfStretchLg : Attribute msg
alignSelfStretchLg =
    class "align-self-lg-stretch"


{-| Set cross axis alignment for an individual flex item in a flexbox container to stretch. Applicable from breakpoint LG and up.
-}
alignSelfStretchXl : Attribute msg
alignSelfStretchXl =
    class "align-self-xl-stretch"


{-| Allow flex items in a flex container to break into multiple lines.
-}
wrap : Attribute msg
wrap =
    class "flex-wrap"


{-| Allow flex items in a flex container to break into multiple lines. Applicable from breakpoint SM and up.
-}
wrapSm : Attribute msg
wrapSm =
    class "flex-sm-wrap"


{-| Allow flex items in a flex container to break into multiple lines. Applicable from breakpoint MD and up.
-}
wrapMd : Attribute msg
wrapMd =
    class "flex-md-wrap"


{-| Allow flex items in a flex container to break into multiple lines. Applicable from breakpoint LG and up.
-}
wrapLg : Attribute msg
wrapLg =
    class "flex-lg-wrap"


{-| Allow flex items in a flex container to break into multiple lines. Applicable from breakpoint XL and up.
-}
wrapXl : Attribute msg
wrapXl =
    class "flex-xl-wrap"


{-| Don't allow flex items in a flex container to break into multiple lines.
-}
nowrap : Attribute msg
nowrap =
    class "flex-nowrap"


{-| Don't allow flex items in a flex container to break into multiple lines. Applicable from breakpoint SM and up.
-}
nowrapSm : Attribute msg
nowrapSm =
    class "flex-sm-nowrap"


{-| Don't allow flex items in a flex container to break into multiple lines. Applicable from breakpoint MD and up.
-}
nowrapMd : Attribute msg
nowrapMd =
    class "flex-md-nowrap"


{-| Don't allow flex items in a flex container to break into multiple lines. Applicable from breakpoint LG and up.
-}
nowrapLg : Attribute msg
nowrapLg =
    class "flex-lg-nowrap"


{-| Don't allow flex items in a flex container to break into multiple lines. Applicable from breakpoint XL and up.
-}
nowrapXl : Attribute msg
nowrapXl =
    class "flex-xl-nowrap"


{-| Allow flex items in a flex container to break into multiple lines in reverse order.
-}
wrapReverse : Attribute msg
wrapReverse =
    class "flex-wrap-reverse"


{-| Allow flex items in a flex container to break into multiple lines in reverse order. Applicable from breakpoint SM and up.
-}
wrapReverseSm : Attribute msg
wrapReverseSm =
    class "flex-sm-wrap-reverse"


{-| Allow flex items in a flex container to break into multiple lines in reverse order. Applicable from breakpoint MD and up.
-}
wrapReverseMd : Attribute msg
wrapReverseMd =
    class "flex-md-wrap-reverse"


{-| Allow flex items in a flex container to break into multiple lines in reverse order. Applicable from breakpoint LG and up.
-}
wrapReverseLg : Attribute msg
wrapReverseLg =
    class "flex-lg-wrap-reverse"


{-| Allow flex items in a flex container to break into multiple lines in reverse order. Applicable from breakpoint XL and up.
-}
wrapReverseXl : Attribute msg
wrapReverseXl =
    class "flex-xl-wrap-reverse"
