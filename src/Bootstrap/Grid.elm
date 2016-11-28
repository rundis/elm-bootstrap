module Bootstrap.Grid
    exposing
        ( container
        , containerFluid
        , row
        , flexRow
        , flexCol
        , flexColSize
        , flexVAlign
        , flexHAlign
        , ScreenSize(..)
        , ColumnSize(..)
        , VAlign(..)
        , HAlign(..)
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


type FlexStyle
    = FlexStyleHAlign FlexHAlign
    | FlexStyleVAlign FlexVAlign
    | FlexStyleColumn Column

type alias FlexVAlign =
    { size : ScreenSize
    , align : VAlign
    }


type alias FlexHAlign =
    { size : ScreenSize
    , align : HAlign
    }

type alias Column =
    { screenSize : ScreenSize
    , columnSize : ColumnSize
    }

type ColumnSize
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


container : List (Html msg) -> Html msg
container children =
    div [ class "container" ] children


containerFluid : List (Html msg) -> Html msg
containerFluid children =
    div [ class "container-fluid" ] children


row : List (Html msg) -> Html msg
row children =
    div [ class "row" ] children


flexRow :
    List FlexStyle
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
flexRow flexStyles attributes children =
    div
        ([ class <| flexStylesClass "row" "flex-items" flexStyles ] ++ attributes)
        children

flexCol :
    List FlexStyle
    -> List (Attribute msg)
    -> List (Html msg)
    -> Html msg
flexCol flexStyles attributes children =
    div
        ([ class <| flexStylesClass "" "flex" flexStyles ] ++ attributes)
        children


flexVAlign : ScreenSize -> VAlign ->  FlexStyle
flexVAlign size align =
    FlexStyleVAlign <| FlexVAlign size align


flexHAlign : ScreenSize -> HAlign -> FlexStyle
flexHAlign size align  =
    FlexStyleHAlign <| FlexHAlign size align


flexColSize : ScreenSize -> ColumnSize -> FlexStyle
flexColSize screenSize columnSize =
    FlexStyleColumn <| Column screenSize columnSize



flexStylesClass :  String -> String -> List FlexStyle -> String
flexStylesClass defaultClass prefix styles =
    List.foldl
        (\style classString ->
            String.join " " [ classString, flexStyleClass prefix style ])
        defaultClass
        styles


flexStyleClass : String -> FlexStyle -> String
flexStyleClass prefix style =
    case style of
        FlexStyleHAlign v ->
            flexHAlignClass prefix v

        FlexStyleVAlign v ->
            flexVAlignClass prefix v

        FlexStyleColumn v ->
            flexColumnClass v


flexVAlignClass : String -> FlexVAlign -> String
flexVAlignClass prefix { size, align } =
    prefix ++ "-" ++ screenSizeClass size ++ "-" ++ vAlignClass align


flexHAlignClass : String -> FlexHAlign -> String
flexHAlignClass prefix { size, align } =
    prefix ++ "-" ++ screenSizeClass size ++ "-" ++ hAlignClass align


flexColumnClass : Column -> String
flexColumnClass ({screenSize, columnSize}) =
    ["col", screenSizeClass screenSize, columnSizeClass columnSize]
        |> List.filter (\s -> String.isEmpty s == False )
        |> String.join "-"


columnSizeClass : ColumnSize -> String
columnSizeClass size =
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


screenSizeClass : ScreenSize -> String
screenSizeClass size =
    case size of
        ExtraSmall ->
            "xs"

        Small ->
            "sm"

        Medium ->
            "md"

        Large ->
            "lg"


vAlignClass : VAlign -> String
vAlignClass align =
    case align of
        Top ->
            "top"

        Middle ->
            "middle"

        Bottom ->
            "bottom"


hAlignClass : HAlign -> String
hAlignClass align =
    case align of
        Left ->
            "left"

        Center ->
            "center"

        Right ->
            "right"
