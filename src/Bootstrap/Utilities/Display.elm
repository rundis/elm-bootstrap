module Bootstrap.Utilities.Display exposing (..)

{-| Quickly and responsively toggle the display value of components and more with these display utilities.


# Flexibily responsive display
You may combine hiding and display functions to control when an element is displayed accross breakposints.


** To hide only for xs:**

    div [ Display.none, Display.blockSm ] [ text "Can't see me in XS" ]

** To show only for sm:**

    div [ Display.none, Display.blockSm, Display.noneMd ] [ text "Only see me in MD" ]



# Hiding elements
@docs none, noneSm, noneMd, noneLg, noneXl

# Displaying elements
@docs block, blockSm, blockMd, blockLg, blockXl, inline, inlineSm, inlineMd, inlineLg, inlineXl, inlineBlock, inlineBlockSm, inlineBlockMd, inlineBlockLg, inlineBlockXl, table, tableSm, tableMd, tableLg, tableXl, tableCell, tableCellSm, tableCellMd, tableCellLg, tableCellXl, tableRow, tableRowSm, tableRowMd, tableRowLg, tableRowXl

-}

import Html exposing (Attribute)
import Html.Attributes exposing (class)




{-| Display as block element. -}
block : Attribute msg
block =
    class "d-block"


{-| Display as block element from SM breakpoint and up.
-}
blockSm : Attribute msg
blockSm =
    class "d-sm-block"

{-| Display as block element from MD breakpoint and up.
-}
blockMd : Attribute msg
blockMd =
    class "d-md-block"


{-| Display as block element from LG breakpoint and up.
-}
blockLg : Attribute msg
blockLg =
    class "d-lg-block"


{-| Display as block element from XL breakpoint and up.
-}
blockXl : Attribute msg
blockXl =
    class "d-xl-block"


{-| Display as inline element. -}
inline : Attribute msg
inline =
    class "d-inline"


{-| Display as inline element from SM breakpoint and up.
-}
inlineSm : Attribute msg
inlineSm =
    class "d-sm-inline"

{-| Display as inline element from MD breakpoint and up.
-}
inlineMd : Attribute msg
inlineMd =
    class "d-md-inline"


{-| Display as inline element from LG breakpoint and up.
-}
inlineLg : Attribute msg
inlineLg =
    class "d-lg-inline"


{-| Display as inline element from XL breakpoint and up.
-}
inlineXl : Attribute msg
inlineXl =
    class "d-xl-inline"


{-| Display as inline block element. -}
inlineBlock : Attribute msg
inlineBlock =
    class "d-inline-block"


{-| Display as inline block element from SM breakpoint and up.
-}
inlineBlockSm : Attribute msg
inlineBlockSm =
    class "d-sm-inline-block"

{-| Display as inline block element from MD breakpoint and up.
-}
inlineBlockMd : Attribute msg
inlineBlockMd =
    class "d-md-inline-block"


{-| Display as inline block element from LG breakpoint and up.
-}
inlineBlockLg : Attribute msg
inlineBlockLg =
    class "d-lg-inline-block"


{-| Display as inline block element from XL breakpoint and up.
-}
inlineBlockXl : Attribute msg
inlineBlockXl =
    class "d-xl-inline-block"



{-| Display as table element. -}
table : Attribute msg
table =
    class "d-table"


{-| Display as table element from SM breakpoint and up.
-}
tableSm : Attribute msg
tableSm =
    class "d-sm-table"

{-| Display as table element from MD breakpoint and up.
-}
tableMd : Attribute msg
tableMd =
    class "d-md-table"


{-| Display as table element from LG breakpoint and up.
-}
tableLg : Attribute msg
tableLg =
    class "d-lg-table"


{-| Display as table element from XL breakpoint and up.
-}
tableXl : Attribute msg
tableXl =
    class "d-xl-table"


{-| Display as table cell element. -}
tableCell : Attribute msg
tableCell =
    class "d-table-cell"


{-| Display as table cell element from SM breakpoint and up.
-}
tableCellSm : Attribute msg
tableCellSm =
    class "d-sm-table-cell"

{-| Display as table cell element from MD breakpoint and up.
-}
tableCellMd : Attribute msg
tableCellMd =
    class "d-md-table-cell"


{-| Display as table cell element from LG breakpoint and up.
-}
tableCellLg : Attribute msg
tableCellLg =
    class "d-lg-table-cell"


{-| Display as table cell element from XL breakpoint and up.
-}
tableCellXl : Attribute msg
tableCellXl =
    class "d-xl-table-cell"

{-| Display as table row element. -}
tableRow : Attribute msg
tableRow =
    class "d-table-row"


{-| Display as table row element from SM breakpoint and up.
-}
tableRowSm : Attribute msg
tableRowSm =
    class "d-sm-table-row"

{-| Display as table row element from MD breakpoint and up.
-}
tableRowMd : Attribute msg
tableRowMd =
    class "d-md-table-row"


{-| Display as table row element from LG breakpoint and up.
-}
tableRowLg : Attribute msg
tableRowLg =
    class "d-lg-table-row"


{-| Display as table row element from XL breakpoint and up.
-}
tableRowXl : Attribute msg
tableRowXl =
    class "d-xl-table-row"


{-| Hide element. -}
none : Attribute msg
none =
    class "d-none"


{-| Hidden from SM breakpoint and up.
-}
noneSm : Attribute msg
noneSm =
    class "d-sm-none"

{-| Hidden from MD breakpoint and up.
-}
noneMd : Attribute msg
noneMd =
    class "d-md-none"


{-| Hidden from LG breakpoint and up.
-}
noneLg : Attribute msg
noneLg =
    class "d-lg-none"


{-| Hidden from XL breakpoint and up.
-}
noneXl : Attribute msg
noneXl =
    class "d-xl-none"
