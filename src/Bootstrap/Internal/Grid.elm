module Bootstrap.Internal.Grid exposing
    ( colWidthOption
    , offsetOption
    , screenSizeOption
    , columnCountOption
    , vAlignOption
    , hAlignOption
    , ColumnWidth
    , ScreenSize (..)
    , ColumnCount (..)
    , HAlign(..)
    , VAlign(..)
    )



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


type alias ColumnWidth =
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




colWidthOption : ColumnWidth -> String
colWidthOption {size, columns} =
    ["col", screenSizeOption size, columnCountOption columns]
        |> List.filter (\s -> String.isEmpty s == False )
        |> String.join "-"

offsetOption : ColumnWidth -> String
offsetOption {size, columns} =
    case columns of
        None ->
            ""
        _ ->
          "offset-" ++ screenSizeOption size ++ "-" ++ columnCountOption columns


columnCountOption : ColumnCount -> String
columnCountOption size =
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


screenSizeOption : ScreenSize -> String
screenSizeOption size =
    case size of
        ExtraSmall ->
            "xs"

        Small ->
            "sm"

        Medium ->
            "md"

        Large ->
            "lg"
