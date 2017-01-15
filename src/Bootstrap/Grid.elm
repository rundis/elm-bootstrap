module Bootstrap.Grid
    exposing
        ( container
        , containerFluid
        , simpleRow
        , row
        , col
        , colAttr
        , rowAttr
        , colWidth
        , colOffset
        , colTop
        , colMiddle
        , colBottom
        , rowTop
        , rowMiddle
        , rowBottom
        , rowLeft
        , rowCenter
        , rowRight
        , colXsOne
        , colXsTwo
        , colXsThree
        , colXsFour
        , colXsFive
        , colXsSix
        , colXsSeven
        , colXsEight
        , colXsNine
        , colXsTen
        , colXsEleven
        , colXsTwelve
        , colXsNone
        , colSmOne
        , colSmTwo
        , colSmThree
        , colSmFour
        , colSmFive
        , colSmSix
        , colSmSeven
        , colSmEight
        , colSmNine
        , colSmTen
        , colSmEleven
        , colSmTwelve
        , colSmNone
        , colMdOne
        , colMdTwo
        , colMdThree
        , colMdFour
        , colMdFive
        , colMdSix
        , colMdSeven
        , colMdEight
        , colMdNine
        , colMdTen
        , colMdEleven
        , colMdTwelve
        , colMdNone
        , colLgOne
        , colLgTwo
        , colLgThree
        , colLgFour
        , colLgFive
        , colLgSix
        , colLgSeven
        , colLgEight
        , colLgNine
        , colLgTen
        , colLgEleven
        , colLgTwelve
        , colLgNone
        , colXlOne
        , colXlTwo
        , colXlThree
        , colXlFour
        , colXlFive
        , colXlSix
        , colXlSeven
        , colXlEight
        , colXlNine
        , colXlTen
        , colXlEleven
        , colXlTwelve
        , colXlNone
        , ColumnWidth
        , Column
        , ColOption
        , RowOption
        )

{-| Bootstrap includes a powerful mobile-first flexbox grid system for building layouts of all shapes and sizes. It’s based on a 12 column layout and has multiple tiers, one for each media query range.

    Grid.container
        [ Grid.row
            [ Grid.rowBottom ]
            [ Grid.col
                [ Grid.colWidth Grid.colXs4 ]
                [ text "col1-row1"]

            , Grid.col
                [ Grid.colWidth Grid.colXs8 ]
                [ text "col2-row1"]
            ]
        , Grid.simpleRow
            [ Grid.col
                [ Grid.colWidth Grid.colXs4 ]
                [ text "col1-row1"]

            , Grid.col
                [ Grid.colWidth Grid.colXs8 ]
                [ text "col2-row1"]

            ]

        ]

# Containers
@docs container, containerFluid

# Rows
@docs row, simpleRow

## Options
@docs rowTop, rowMiddle, rowBottom, rowLeft, rowCenter, rowRight, rowAttr, RowOption


# Columns
@docs col, Column

## Options
@docs colWidth, colOffset, colTop, colMiddle, colBottom, colAttr, ColOption



# Column widths
@docs ColumnWidth, colXsOne, colXsTwo, colXsThree, colXsFour, colXsFive, colXsSix, colXsSeven, colXsEight, colXsNine, colXsTen, colXsEleven, colXsTwelve, colXsNone, colSmOne, colSmTwo, colSmThree, colSmFour, colSmFive, colSmSix, colSmSeven, colSmEight, colSmNine, colSmTen, colSmEleven, colSmTwelve, colSmNone, colMdOne, colMdTwo, colMdThree, colMdFour, colMdFive, colMdSix, colMdSeven, colMdEight, colMdNine, colMdTen, colMdEleven, colMdTwelve, colMdNone, colLgOne, colLgTwo, colLgThree, colLgFour, colLgFive, colLgSix, colLgSeven, colLgEight, colLgNine, colLgTen, colLgEleven, colLgTwelve, colLgNone, colXlOne, colXlTwo, colXlThree, colXlFour, colXlFive, colXlSix, colXlSeven, colXlEight, colXlNine, colXlTen, colXlEleven, colXlTwelve, colXlNone


-}

import Html exposing (Html, div, Attribute)
import Html.Attributes exposing (class, classList)
import Bootstrap.Internal.Grid as GridInternal exposing (ScreenSize(..), Align(..), ColumnCount(..))


{-| Opaque type represening possible row configuration options
-}
type RowOption msg
    = RowHAlign Align
    | RowVAlign Align
    | RowAttr (Html.Attribute msg)


{-| Opaque type represening possible column configuration options
-}
type ColOption msg
    = ColVAlign Align
    | ColWidth ColumnWidth
    | ColOffset ColumnWidth
    | ColAttr (Html.Attribute msg)


{-| Opaque type represetning a column width
-}
type alias ColumnWidth =
    GridInternal.ColumnWidth


{-| Opaque type represetning a column element
-}
type Column msg
    = Column
        { options : List (ColOption msg)
        , children : List (Html msg)
        }


{-| Responsive fixed width container, which changes it's maz-width at breakpoint
-}
container : List (Attribute msg) -> List (Html msg) -> Html msg
container attributes children =
    div ([ class "container" ] ++ attributes) children


{-| Full width contaienr spanning the entire viewport
-}
containerFluid : List (Attribute msg) -> List (Html msg) -> Html msg
containerFluid attributes children =
    div ([ class "container-fluid" ] ++ attributes) children


{-| Create a row with no configuration options
-}
simpleRow : List (Column msg) -> Html msg
simpleRow cols =
    row [] cols


{-| Create a row

* `options` List of row options
* `cols` List of columns
-}
row : List (RowOption msg) -> List (Column msg) -> Html msg
row options cols =
    div
        (rowAttributes options)
        (List.map renderCol cols)


{-| Create a column

* `options` List of column options
* `cols` List of child elments
-}
col : List (ColOption msg) -> List (Html msg) -> Column msg
col options children =
    Column
        { options = options
        , children = children
        }


{-| Use this option to add custom Html.Attribute attributes to your column
-}
colAttr : Attribute msg -> ColOption msg
colAttr attr =
    ColAttr attr


{-| Use this option to add custom Html.Attribute attributes to your row
-}
rowAttr : Attribute msg -> RowOption msg
rowAttr attr =
    RowAttr attr


{-| Align items in a row to the top
-}
rowTop : RowOption msg
rowTop =
    RowVAlign Start


{-| Align items in a row to the middle
-}
rowMiddle : RowOption msg
rowMiddle =
    RowVAlign Center


{-| Align items in a row to the bottom
-}
rowBottom : RowOption msg
rowBottom =
    RowVAlign End


{-| Align items in a row to the left
-}
rowLeft : RowOption msg
rowLeft =
    RowHAlign Start


{-| Align items in a row to the center (horizontally)
-}
rowCenter : RowOption msg
rowCenter =
    RowHAlign Center


{-| Align items in a row to the right
-}
rowRight : RowOption msg
rowRight =
    RowHAlign End


{-| Align items in a column to the top
-}
colTop : ColOption msg
colTop =
    ColVAlign Start


{-| Align items in a column to the middle
-}
colMiddle : ColOption msg
colMiddle =
    ColVAlign Center


{-| Align items in a column to the bottom
-}
colBottom : ColOption msg
colBottom =
    ColVAlign End


{-| Option to specify the widht of a column
-}
colWidth : ColumnWidth -> ColOption msg
colWidth columnWidth =
    ColWidth columnWidth


{-| Option to speficy the offset for a column
-}
colOffset : ScreenSize -> ColumnCount -> ColOption msg
colOffset size columns =
    ColOffset
        { size = size
        , columns = columns
        }


{-| -}
colXsOne : ColumnWidth
colXsOne =
    colXs One


{-| -}
colXsTwo : ColumnWidth
colXsTwo =
    colXs Two


{-| -}
colXsThree : ColumnWidth
colXsThree =
    colXs Three


{-| -}
colXsFour : ColumnWidth
colXsFour =
    colXs Four


{-| -}
colXsFive : ColumnWidth
colXsFive =
    colXs Five


{-| -}
colXsSix : ColumnWidth
colXsSix =
    colXs Six


{-| -}
colXsSeven : ColumnWidth
colXsSeven =
    colXs Seven


{-| -}
colXsEight : ColumnWidth
colXsEight =
    colXs Eight


{-| -}
colXsNine : ColumnWidth
colXsNine =
    colXs Nine


{-| -}
colXsTen : ColumnWidth
colXsTen =
    colXs Ten


{-| -}
colXsEleven : ColumnWidth
colXsEleven =
    colXs Eleven


{-| -}
colXsTwelve : ColumnWidth
colXsTwelve =
    colXs Twelve


{-| -}
colXsNone : ColumnWidth
colXsNone =
    colXs None


colXs : ColumnCount -> ColumnWidth
colXs columns =
    { size = ExtraSmall
    , columns = columns
    }


{-| -}
colSmOne : ColumnWidth
colSmOne =
    colSm One


{-| -}
colSmTwo : ColumnWidth
colSmTwo =
    colSm Two


{-| -}
colSmThree : ColumnWidth
colSmThree =
    colSm Three


{-| -}
colSmFour : ColumnWidth
colSmFour =
    colSm Four


{-| -}
colSmFive : ColumnWidth
colSmFive =
    colSm Five


{-| -}
colSmSix : ColumnWidth
colSmSix =
    colSm Six


{-| -}
colSmSeven : ColumnWidth
colSmSeven =
    colSm Seven


{-| -}
colSmEight : ColumnWidth
colSmEight =
    colSm Eight


{-| -}
colSmNine : ColumnWidth
colSmNine =
    colSm Nine


{-| -}
colSmTen : ColumnWidth
colSmTen =
    colSm Ten


{-| -}
colSmEleven : ColumnWidth
colSmEleven =
    colSm Eleven


{-| -}
colSmTwelve : ColumnWidth
colSmTwelve =
    colSm Twelve


{-| -}
colSmNone : ColumnWidth
colSmNone =
    colSm None


colSm : ColumnCount -> ColumnWidth
colSm columns =
    { size = Small
    , columns = columns
    }


{-| -}
colMdOne : ColumnWidth
colMdOne =
    colMd One


{-| -}
colMdTwo : ColumnWidth
colMdTwo =
    colMd Two


{-| -}
colMdThree : ColumnWidth
colMdThree =
    colMd Three


{-| -}
colMdFour : ColumnWidth
colMdFour =
    colMd Four


{-| -}
colMdFive : ColumnWidth
colMdFive =
    colMd Five


{-| -}
colMdSix : ColumnWidth
colMdSix =
    colMd Six


{-| -}
colMdSeven : ColumnWidth
colMdSeven =
    colMd Seven


{-| -}
colMdEight : ColumnWidth
colMdEight =
    colMd Eight


{-| -}
colMdNine : ColumnWidth
colMdNine =
    colMd Nine


{-| -}
colMdTen : ColumnWidth
colMdTen =
    colMd Ten


{-| -}
colMdEleven : ColumnWidth
colMdEleven =
    colMd Eleven


{-| -}
colMdTwelve : ColumnWidth
colMdTwelve =
    colMd Twelve


{-| -}
colMdNone : ColumnWidth
colMdNone =
    colMd None


colMd : ColumnCount -> ColumnWidth
colMd columns =
    { size = Medium
    , columns = columns
    }


{-| -}
colLgOne : ColumnWidth
colLgOne =
    colLg One


{-| -}
colLgTwo : ColumnWidth
colLgTwo =
    colLg Two


{-| -}
colLgThree : ColumnWidth
colLgThree =
    colLg Three


{-| -}
colLgFour : ColumnWidth
colLgFour =
    colLg Four


{-| -}
colLgFive : ColumnWidth
colLgFive =
    colLg Five


{-| -}
colLgSix : ColumnWidth
colLgSix =
    colLg Six


{-| -}
colLgSeven : ColumnWidth
colLgSeven =
    colLg Seven


{-| -}
colLgEight : ColumnWidth
colLgEight =
    colLg Eight


{-| -}
colLgNine : ColumnWidth
colLgNine =
    colLg Nine


{-| -}
colLgTen : ColumnWidth
colLgTen =
    colLg Ten


{-| -}
colLgEleven : ColumnWidth
colLgEleven =
    colLg Eleven


{-| -}
colLgTwelve : ColumnWidth
colLgTwelve =
    colLg Twelve


{-| -}
colLgNone : ColumnWidth
colLgNone =
    colLg None


colLg : ColumnCount -> ColumnWidth
colLg columns =
    { size = Large
    , columns = columns
    }


{-| -}
colXlOne : ColumnWidth
colXlOne =
    colXl One


{-| -}
colXlTwo : ColumnWidth
colXlTwo =
    colXl Two


{-| -}
colXlThree : ColumnWidth
colXlThree =
    colXl Three


{-| -}
colXlFour : ColumnWidth
colXlFour =
    colXl Four


{-| -}
colXlFive : ColumnWidth
colXlFive =
    colXl Five


{-| -}
colXlSix : ColumnWidth
colXlSix =
    colXl Six


{-| -}
colXlSeven : ColumnWidth
colXlSeven =
    colXl Seven


{-| -}
colXlEight : ColumnWidth
colXlEight =
    colXl Eight


{-| -}
colXlNine : ColumnWidth
colXlNine =
    colXl Nine


{-| -}
colXlTen : ColumnWidth
colXlTen =
    colXl Ten


{-| -}
colXlEleven : ColumnWidth
colXlEleven =
    colXl Eleven


{-| -}
colXlTwelve : ColumnWidth
colXlTwelve =
    colXl Twelve


{-| -}
colXlNone : ColumnWidth
colXlNone =
    colXl None


colXl : ColumnCount -> ColumnWidth
colXl columns =
    { size = ExtraLarge
    , columns = columns
    }


rowAttributes : List (RowOption msg) -> List (Html.Attribute msg)
rowAttributes options =
    class "row" :: List.map rowAttribute options


rowAttribute : RowOption msg -> Html.Attribute msg
rowAttribute option =
    case option of
        RowHAlign hAlign ->
            class <| hAlignOption "justify-content" hAlign

        RowVAlign vAlign ->
            class <| vAlignOption "align-items" vAlign

        RowAttr attr ->
            attr


renderCol : Column msg -> Html msg
renderCol (Column { options, children }) =
    div
        (colAttributes options)
        children


colAttributes : List (ColOption msg) -> List (Html.Attribute msg)
colAttributes options =
    List.map colAttribute options
        |> List.filterMap identity


colAttribute : ColOption msg -> Maybe (Html.Attribute msg)
colAttribute option =
    case option of
        ColVAlign vAlign ->
            Just <| class <| vAlignOption "align-self" vAlign

        ColWidth width ->
            Just <| GridInternal.colWidthClass width

        ColOffset offset ->
            GridInternal.offsetClass offset

        ColAttr attr ->
            Just attr


vAlignOption : String -> Align -> String
vAlignOption prefix align =
    prefix ++ "-" ++ GridInternal.alignOption align


hAlignOption : String -> Align -> String
hAlignOption prefix align =
    prefix ++ "-" ++ GridInternal.alignOption align
