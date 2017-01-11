module Bootstrap.Grid
    exposing
        ( container
        , containerFluid
        , simpleRow
        , row
        , col
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
        , ColumnWidth
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
        )

import Html exposing (Html, div, Attribute)
import Html.Attributes exposing (class, classList)
import Bootstrap.Internal.Grid as GridInternal exposing (ScreenSize(..), Align(..), ColumnCount(..))


-- TODO: flex-around, flex-between


type FlexRowOption
    = FlexRowHAlign Align
    | FlexRowVAlign Align


type FlexColOption
    = FlexColVAlign Align
    | FlexColWidth ColumnWidth
    | FlexColOffset ColumnWidth



type alias ColumnWidth =
    GridInternal.ColumnWidth


type FlexColumn msg
    = FlexColumn
        { options : List FlexColOption
        , attributes : List (Html.Attribute msg)
        , children : List (Html msg)
        }


container : List (Attribute msg) -> List (Html msg) -> Html msg
container attributes children =
    div ([ class "container" ] ++ attributes) children


containerFluid : List (Attribute msg) -> List (Html msg) -> Html msg
containerFluid attributes children =
    div ([ class "container-fluid" ] ++ attributes ) children


simpleRow : List (FlexColumn msg) -> Html msg
simpleRow cols =
    row
        { cols = cols
        , options = []
        , attributes = []
        }


row :
    { cols : List (FlexColumn msg)
    , options : List FlexRowOption
    , attributes : List (Html.Attribute msg)
    }
    -> Html msg
row { cols, options, attributes } =
    div
        (attributes ++ flexRowAttributes options )
        (List.map renderFlexCol cols)


col :
    { options : List FlexColOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html msg)
    }
    -> FlexColumn msg
col { options, attributes, children } =
    FlexColumn
        { options = options
        , attributes = attributes
        , children = children
        }


rowTop : FlexRowOption
rowTop =
    FlexRowVAlign Start

rowMiddle : FlexRowOption
rowMiddle =
    FlexRowVAlign Center


rowBottom : FlexRowOption
rowBottom =
    FlexRowVAlign End


rowLeft : FlexRowOption
rowLeft =
    FlexRowHAlign Start

rowCenter : FlexRowOption
rowCenter =
    FlexRowHAlign Center

rowRight : FlexRowOption
rowRight =
    FlexRowHAlign End


colTop : FlexColOption
colTop =
    FlexColVAlign Start


colMiddle : FlexColOption
colMiddle =
    FlexColVAlign Center


colBottom : FlexColOption
colBottom =
    FlexColVAlign End


colWidth : ColumnWidth -> FlexColOption
colWidth columnWidth =
    FlexColWidth columnWidth


colOffset : ScreenSize -> ColumnCount -> FlexColOption
colOffset size columns =
    FlexColOffset
        { size = size
        , columns = columns
        }


colXsOne : ColumnWidth
colXsOne =
    colXs One


colXsTwo : ColumnWidth
colXsTwo =
    colXs Two


colXsThree : ColumnWidth
colXsThree =
    colXs Three


colXsFour : ColumnWidth
colXsFour =
    colXs Four


colXsFive : ColumnWidth
colXsFive =
    colXs Five


colXsSix : ColumnWidth
colXsSix =
    colXs Six


colXsSeven : ColumnWidth
colXsSeven =
    colXs Seven


colXsEight : ColumnWidth
colXsEight =
    colXs Eight


colXsNine : ColumnWidth
colXsNine =
    colXs Nine


colXsTen : ColumnWidth
colXsTen =
    colXs Ten


colXsEleven : ColumnWidth
colXsEleven =
    colXs Eleven


colXsTwelve : ColumnWidth
colXsTwelve =
    colXs Twelve


colXsNone : ColumnWidth
colXsNone =
    colXs None


colXs : ColumnCount -> ColumnWidth
colXs columns =
    { size = ExtraSmall
    , columns = columns
    }


colSmOne : ColumnWidth
colSmOne =
    colSm One


colSmTwo : ColumnWidth
colSmTwo =
    colSm Two


colSmThree : ColumnWidth
colSmThree =
    colSm Three


colSmFour : ColumnWidth
colSmFour =
    colSm Four


colSmFive : ColumnWidth
colSmFive =
    colSm Five


colSmSix : ColumnWidth
colSmSix =
    colSm Six


colSmSeven : ColumnWidth
colSmSeven =
    colSm Seven


colSmEight : ColumnWidth
colSmEight =
    colSm Eight


colSmNine : ColumnWidth
colSmNine =
    colSm Nine


colSmTen : ColumnWidth
colSmTen =
    colSm Ten


colSmEleven : ColumnWidth
colSmEleven =
    colSm Eleven


colSmTwelve : ColumnWidth
colSmTwelve =
    colSm Twelve


colSmNone : ColumnWidth
colSmNone =
    colSm None


colSm : ColumnCount -> ColumnWidth
colSm columns =
    { size = Small
    , columns = columns
    }


colMdOne : ColumnWidth
colMdOne =
    colMd One


colMdTwo : ColumnWidth
colMdTwo =
    colMd Two


colMdThree : ColumnWidth
colMdThree =
    colMd Three


colMdFour : ColumnWidth
colMdFour =
    colMd Four


colMdFive : ColumnWidth
colMdFive =
    colMd Five


colMdSix : ColumnWidth
colMdSix =
    colMd Six


colMdSeven : ColumnWidth
colMdSeven =
    colMd Seven


colMdEight : ColumnWidth
colMdEight =
    colMd Eight


colMdNine : ColumnWidth
colMdNine =
    colMd Nine


colMdTen : ColumnWidth
colMdTen =
    colMd Ten


colMdEleven : ColumnWidth
colMdEleven =
    colMd Eleven


colMdTwelve : ColumnWidth
colMdTwelve =
    colMd Twelve


colMdNone : ColumnWidth
colMdNone =
    colMd None


colMd : ColumnCount -> ColumnWidth
colMd columns =
    { size = Medium
    , columns = columns
    }


colLgOne : ColumnWidth
colLgOne =
    colLg One


colLgTwo : ColumnWidth
colLgTwo =
    colLg Two


colLgThree : ColumnWidth
colLgThree =
    colLg Three


colLgFour : ColumnWidth
colLgFour =
    colLg Four


colLgFive : ColumnWidth
colLgFive =
    colLg Five


colLgSix : ColumnWidth
colLgSix =
    colLg Six


colLgSeven : ColumnWidth
colLgSeven =
    colLg Seven


colLgEight : ColumnWidth
colLgEight =
    colLg Eight


colLgNine : ColumnWidth
colLgNine =
    colLg Nine


colLgTen : ColumnWidth
colLgTen =
    colLg Ten


colLgEleven : ColumnWidth
colLgEleven =
    colLg Eleven


colLgTwelve : ColumnWidth
colLgTwelve =
    colLg Twelve


colLgNone : ColumnWidth
colLgNone =
    colLg None

colLg : ColumnCount -> ColumnWidth
colLg columns =
    { size = Large
    , columns = columns
    }


colXlOne : ColumnWidth
colXlOne =
    colXl One


colXlTwo : ColumnWidth
colXlTwo =
    colXl Two


colXlThree : ColumnWidth
colXlThree =
    colXl Three


colXlFour : ColumnWidth
colXlFour =
    colXl Four


colXlFive : ColumnWidth
colXlFive =
    colXl Five


colXlSix : ColumnWidth
colXlSix =
    colXl Six


colXlSeven : ColumnWidth
colXlSeven =
    colXl Seven


colXlEight : ColumnWidth
colXlEight =
    colXl Eight


colXlNine : ColumnWidth
colXlNine =
    colXl Nine


colXlTen : ColumnWidth
colXlTen =
    colXl Ten


colXlEleven : ColumnWidth
colXlEleven =
    colXl Eleven


colXlTwelve : ColumnWidth
colXlTwelve =
    colXl Twelve


colXlNone : ColumnWidth
colXlNone =
    colXl None


colXl : ColumnCount -> ColumnWidth
colXl columns =
    { size = ExtraLarge
    , columns = columns
    }


flexRowAttributes : List FlexRowOption -> List (Html.Attribute msg)
flexRowAttributes options =
    class "row" :: List.map flexRowClass options


flexRowClass : FlexRowOption -> Html.Attribute msg
flexRowClass option =
    class <|
        case option of
            FlexRowHAlign hAlign ->
                flexHAlignOption "justify-content" hAlign

            FlexRowVAlign vAlign ->
                flexVAlignOption "align-items" vAlign


renderFlexCol : FlexColumn msg -> Html msg
renderFlexCol (FlexColumn { options, attributes, children }) =
    div
        (attributes ++ flexColAttributes options )
        children


flexColAttributes : List FlexColOption -> List (Html.Attribute msg)
flexColAttributes options =
    List.map flexColClass options
        |> List.filterMap identity


flexColClass : FlexColOption -> Maybe (Html.Attribute msg)
flexColClass option =

        case option of
            FlexColVAlign vAlign ->
                Just <| class <| flexVAlignOption "align-self" vAlign

            FlexColWidth width ->
                Just <| GridInternal.colWidthClass width

            FlexColOffset offset ->
                GridInternal.offsetClass offset


flexVAlignOption : String -> Align -> String
flexVAlignOption prefix align =
    prefix ++ "-" ++ GridInternal.alignOption align


flexHAlignOption : String -> Align -> String
flexHAlignOption prefix align =
    prefix ++ "-" ++ GridInternal.alignOption align
