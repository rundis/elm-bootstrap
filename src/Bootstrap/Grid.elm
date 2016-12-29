module Bootstrap.Grid
    exposing
        ( container
        , containerFluid
        , row
        , flexRow
        , flexCol
        , flexColWidth
        , flexColOffset
        , flexRowHAlign
        , flexRowVAlign
        , flexColVAlign
        , colWidthClassString -- TODO: Find away to make this less exposed ?
        , offsetClassString   -- TODO: Find away to make this less exposed ?
        , screenSizeString    -- TODO: Find away to make this less exposed ?
        , columnCountString   -- TODO: Find away to make this less exposed ?
        , ScreenSize(..)
        , ColumnCount(..)
        , ColumnWidth
        , VAlign(..)
        , HAlign(..)
        , colXsOne, colXsTwo, colXsThree, colXsFour, colXsFive, colXsSix, colXsSeven, colXsEight, colXsNine, colXsTen, colXsEleven, colXsTwelve, colXsNone
        , colSmOne, colSmTwo, colSmThree, colSmFour, colSmFive, colSmSix, colSmSeven, colSmEight, colSmNine, colSmTen, colSmEleven, colSmTwelve, colSmNone
        , colMdOne, colMdTwo, colMdThree, colMdFour, colMdFive, colMdSix, colMdSeven, colMdEight, colMdNine, colMdTen, colMdEleven, colMdTwelve, colMdNone
        , colLgOne, colLgTwo, colLgThree, colLgFour, colLgFive, colLgSix, colLgSeven, colLgEight, colLgNine, colLgTen, colLgEleven, colLgTwelve, colLgNone
        )

import Html exposing (Html, div, Attribute)
import Html.Attributes exposing (class, classList)


type ScreenSize
    = ExtraSmall
    | Small
    | Medium
    | Large


type VAlign
    = Top
    | Middle
    | Bottom


type HAlign
    = Left
    | Center
    | Right

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

type ColumnWidth =
    ColumnWidth
        { size : ScreenSize
        , columns : ColumnCount
        }

type ColumnCount
    = One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Eleven
    | Twelve
    | None


type FlexColumn msg
    = FlexColumn
        { options : List FlexColOption
        , attributes : List (Html.Attribute msg)
        , children : List (Html msg)
        }


container : List (Html msg) -> Html msg
container children =
    div [ class "container" ] children


containerFluid : List (Html msg) -> Html msg
containerFluid children =
    div [ class "container-fluid" ] children


row : List (FlexColumn msg) -> Html msg
row cols =
    flexRow
        { cols = cols
        , options = []
        , attributes = []
        }


flexRow :
    { cols : List (FlexColumn msg)
    , options : List FlexRowOption
    , attributes : List (Html.Attribute msg)
    }
    -> Html msg
flexRow {cols, options, attributes} =
    div
        (attributes ++ [class <| flexRowOptions options])
        (List.map renderFlexCol cols)


flexCol :
    { options : List FlexColOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html msg)
    }
    -> FlexColumn msg
flexCol {options, attributes, children} =
    FlexColumn
        { options = options
        , attributes = attributes
        , children = children
        }


flexRowVAlign : ScreenSize -> VAlign ->  FlexRowOption
flexRowVAlign size align =
    FlexRowVAlign <| FlexVAlign size align


flexRowHAlign : ScreenSize -> HAlign ->  FlexRowOption
flexRowHAlign size align =
    FlexRowHAlign <| FlexHAlign size align




flexColVAlign : ScreenSize -> VAlign -> FlexColOption
flexColVAlign size align  =
    FlexColVAlign <| FlexVAlign size align


flexColWidth : ColumnWidth -> FlexColOption
flexColWidth columnWidth =
    FlexColWidth columnWidth

flexColOffset : ScreenSize -> ColumnCount -> FlexColOption
flexColOffset size columns =
    FlexColOffset <|
        ColumnWidth
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
    ColumnWidth
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
    ColumnWidth
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
    ColumnWidth
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
    ColumnWidth
        { size = Large
        , columns = columns
        }





flexRowOptions : List FlexRowOption -> String
flexRowOptions options =
    List.foldl
        (\class classString ->
            String.join " " [classString, flexRowOption class])
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
renderFlexCol (FlexColumn {options, attributes, children}) =
    div
        (attributes ++ [class <| flexColOptions options])
        children


flexColOptions : List FlexColOption -> String
flexColOptions options =
    List.foldl
        (\class classString ->
            String.join " " [classString, flexColOption class])
        ""
        options


flexColOption : FlexColOption -> String
flexColOption class =
    case class of
        FlexColVAlign vAlign ->
            flexVAlignOption "flex" vAlign

        FlexColWidth width ->
            colWidthClassString width

        FlexColOffset offset ->
            offsetClassString offset



flexVAlignOption : String -> FlexVAlign -> String
flexVAlignOption prefix { size, align } =
    prefix ++ "-" ++ screenSizeString size ++ "-" ++ vAlignOption align


flexHAlignOption : String -> FlexHAlign -> String
flexHAlignOption prefix { size, align } =
    prefix ++ "-" ++ screenSizeString size ++ "-" ++ hAlignOption align


colWidthClassString : ColumnWidth -> String
colWidthClassString (ColumnWidth {size, columns}) =
    ["col", screenSizeString size, columnCountString columns]
        |> List.filter (\s -> String.isEmpty s == False )
        |> String.join "-"

offsetClassString : ColumnWidth -> String
offsetClassString (ColumnWidth {size, columns}) =
    case columns of
        None ->
            ""
        _ ->
          "offset-" ++ screenSizeString size ++ "-" ++ columnCountString columns


columnCountString : ColumnCount -> String
columnCountString size =
    case size of
        One -> "1"
        Two -> "2"
        Three -> "3"
        Four -> "4"
        Five -> "5"
        Six -> "6"
        Seven -> "7"
        Eight -> "8"
        Nine -> "9"
        Ten -> "10"
        Eleven -> "11"
        Twelve -> "12"
        None -> ""


screenSizeString : ScreenSize -> String
screenSizeString size =
    case size of
        ExtraSmall ->
            "xs"

        Small ->
            "sm"

        Medium ->
            "md"

        Large ->
            "lg"


vAlignOption : VAlign -> String
vAlignOption align =
    case align of
        Top ->
            "top"

        Middle ->
            "middle"

        Bottom ->
            "bottom"


hAlignOption : HAlign -> String
hAlignOption align =
    case align of
        Left ->
            "left"

        Center ->
            "center"

        Right ->
            "right"
