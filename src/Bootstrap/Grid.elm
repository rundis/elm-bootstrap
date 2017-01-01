module Bootstrap.Grid
    exposing
        ( container
        , containerFluid
        , simpleRow
        , row
        , col
        , colWidth
        , colOffset
        , rowXsBottom
        , rowXsCenter
        , rowXsTop
        , rowXsLeft
        , rowXsMiddle
        , rowXsRight
        , rowSmBottom
        , rowSmCenter
        , rowSmTop
        , rowSmLeft
        , rowSmMiddle
        , rowSmRight
        , rowMdBottom
        , rowMdCenter
        , rowMdTop
        , rowMdLeft
        , rowMdMiddle
        , rowMdRight
        , rowLgBottom
        , rowLgCenter
        , rowLgTop
        , rowLgLeft
        , rowLgMiddle
        , rowLgRight
        , colXsBottom
        , colXsMiddle
        , colXsTop
        , colSmBottom
        , colSmMiddle
        , colSmTop
        , colMdBottom
        , colMdMiddle
        , colMdTop
        , colLgBottom
        , colLgMiddle
        , colLgTop
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
        )

import Html exposing (Html, div, Attribute)
import Html.Attributes exposing (class, classList)
import Bootstrap.Internal.Grid as GridInternal exposing (ScreenSize(..), VAlign(..), HAlign(..), ColumnCount(..))


-- TODO: flex-around, flex-between


type FlexRowOption
    = FlexRowHAlign FlexHAlign
    | FlexRowVAlign FlexVAlign


type FlexColOption
    = FlexColVAlign FlexVAlign
    | FlexColWidth ColumnWidth
    | FlexColOffset ColumnWidth


type alias FlexVAlign =
    { size : ScreenSize
    , align : VAlign
    }


type alias FlexHAlign =
    { size : ScreenSize
    , align : HAlign
    }


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
        (attributes ++ [ class <| flexRowOptions options ])
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


rowXsTop : FlexRowOption
rowXsTop =
    FlexVAlign ExtraSmall Top
        |> FlexRowVAlign


rowXsMiddle : FlexRowOption
rowXsMiddle =
    FlexVAlign ExtraSmall Middle
        |> FlexRowVAlign


rowXsBottom : FlexRowOption
rowXsBottom =
    FlexVAlign ExtraSmall Bottom
        |> FlexRowVAlign


rowSmTop : FlexRowOption
rowSmTop =
    FlexVAlign Small Top
        |> FlexRowVAlign


rowSmMiddle : FlexRowOption
rowSmMiddle =
    FlexVAlign Small Middle
        |> FlexRowVAlign


rowSmBottom : FlexRowOption
rowSmBottom =
    FlexVAlign Small Bottom
        |> FlexRowVAlign


rowMdTop : FlexRowOption
rowMdTop =
    FlexVAlign Medium Top
        |> FlexRowVAlign


rowMdMiddle : FlexRowOption
rowMdMiddle =
    FlexVAlign Medium Middle
        |> FlexRowVAlign


rowMdBottom : FlexRowOption
rowMdBottom =
    FlexVAlign Medium Bottom
        |> FlexRowVAlign


rowLgTop : FlexRowOption
rowLgTop =
    FlexVAlign Large Top
        |> FlexRowVAlign


rowLgMiddle : FlexRowOption
rowLgMiddle =
    FlexVAlign Large Middle
        |> FlexRowVAlign


rowLgBottom : FlexRowOption
rowLgBottom =
    FlexVAlign Large Bottom
        |> FlexRowVAlign


rowXsLeft : FlexRowOption
rowXsLeft =
    FlexHAlign ExtraSmall Left
        |> FlexRowHAlign


rowXsCenter : FlexRowOption
rowXsCenter =
    FlexHAlign ExtraSmall Center
        |> FlexRowHAlign


rowXsRight : FlexRowOption
rowXsRight =
    FlexHAlign ExtraSmall Right
        |> FlexRowHAlign


rowSmLeft : FlexRowOption
rowSmLeft =
    FlexHAlign Small Left
        |> FlexRowHAlign


rowSmCenter : FlexRowOption
rowSmCenter =
    FlexHAlign Small Center
        |> FlexRowHAlign


rowSmRight : FlexRowOption
rowSmRight =
    FlexHAlign Small Right
        |> FlexRowHAlign


rowMdLeft : FlexRowOption
rowMdLeft =
    FlexHAlign Medium Left
        |> FlexRowHAlign


rowMdCenter : FlexRowOption
rowMdCenter =
    FlexHAlign Medium Center
        |> FlexRowHAlign


rowMdRight : FlexRowOption
rowMdRight =
    FlexHAlign Medium Right
        |> FlexRowHAlign


rowLgLeft : FlexRowOption
rowLgLeft =
    FlexHAlign Large Left
        |> FlexRowHAlign


rowLgCenter : FlexRowOption
rowLgCenter =
    FlexHAlign Large Center
        |> FlexRowHAlign


rowLgRight : FlexRowOption
rowLgRight =
    FlexHAlign Large Right
        |> FlexRowHAlign


colXsTop : FlexColOption
colXsTop =
    FlexVAlign ExtraSmall Top
        |> FlexColVAlign


colXsMiddle : FlexColOption
colXsMiddle =
    FlexVAlign ExtraSmall Middle
        |> FlexColVAlign


colXsBottom : FlexColOption
colXsBottom =
    FlexVAlign ExtraSmall Bottom
        |> FlexColVAlign


colSmTop : FlexColOption
colSmTop =
    FlexVAlign Small Top
        |> FlexColVAlign


colSmMiddle : FlexColOption
colSmMiddle =
    FlexVAlign Small Middle
        |> FlexColVAlign


colSmBottom : FlexColOption
colSmBottom =
    FlexVAlign Small Bottom
        |> FlexColVAlign


colMdTop : FlexColOption
colMdTop =
    FlexVAlign Medium Top
        |> FlexColVAlign


colMdMiddle : FlexColOption
colMdMiddle =
    FlexVAlign Medium Middle
        |> FlexColVAlign


colMdBottom : FlexColOption
colMdBottom =
    FlexVAlign Medium Bottom
        |> FlexColVAlign


colLgTop : FlexColOption
colLgTop =
    FlexVAlign Large Top
        |> FlexColVAlign


colLgMiddle : FlexColOption
colLgMiddle =
    FlexVAlign Large Middle
        |> FlexColVAlign


colLgBottom : FlexColOption
colLgBottom =
    FlexVAlign Large Bottom
        |> FlexColVAlign


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


flexRowOptions : List FlexRowOption -> String
flexRowOptions options =
    List.foldl
        (\class classString ->
            String.join " " [ classString, flexRowOption class ]
        )
        "row"
        options


flexRowOption : FlexRowOption -> String
flexRowOption class =
    case class of
        FlexRowHAlign hAlign ->
            flexHAlignOption "flex-items" hAlign

        FlexRowVAlign vAlign ->
            flexVAlignOption "flex-items" vAlign


renderFlexCol : FlexColumn msg -> Html msg
renderFlexCol (FlexColumn { options, attributes, children }) =
    div
        (attributes ++ [ class <| flexColOptions options ])
        children


flexColOptions : List FlexColOption -> String
flexColOptions options =
    List.foldl
        (\class classString ->
            String.join " " [ classString, flexColOption class ]
        )
        ""
        options


flexColOption : FlexColOption -> String
flexColOption class =
    case class of
        FlexColVAlign vAlign ->
            flexVAlignOption "flex" vAlign

        FlexColWidth width ->
            GridInternal.colWidthOption width

        FlexColOffset offset ->
            GridInternal.offsetOption offset


flexVAlignOption : String -> FlexVAlign -> String
flexVAlignOption prefix { size, align } =
    prefix ++ "-" ++ GridInternal.screenSizeOption size ++ "-" ++ GridInternal.vAlignOption align


flexHAlignOption : String -> FlexHAlign -> String
flexHAlignOption prefix { size, align } =
    prefix ++ "-" ++ GridInternal.screenSizeOption size ++ "-" ++ GridInternal.hAlignOption align
