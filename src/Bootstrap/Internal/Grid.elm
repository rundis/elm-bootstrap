module Bootstrap.Internal.Grid exposing
    ( colWidthClass
    , offsetClass
    , screenSizeOption
    , alignOption
    , ColumnWidth
    , ScreenSize (..)
    , ColumnCount (..)
    , Align(..)
    )



import Html
import Html.Attributes exposing (class)

type ScreenSize
    = ExtraSmall
    | Small
    | Medium
    | Large
    | ExtraLarge


type Align
    = Start
    | Center
    | End



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




colWidthClass : ColumnWidth -> Html.Attribute msg
colWidthClass { size, columns } =
    "col"
        ++ (Maybe.map (\v -> "-" ++ v) (screenSizeOption size)
                |> Maybe.withDefault ""
           )
        ++ (Maybe.map (\v -> "-" ++ v) (columnCountOption columns)
                |> Maybe.withDefault ""
           )
        |> class


offsetClass : ColumnWidth -> Maybe (Html.Attribute msg)
offsetClass {size, columns} =
    case columns of
        None ->
            Nothing
        _ ->
          "offset"
            ++ (Maybe.map (\v -> "-" ++ v ) (screenSizeOption size)
                    |> Maybe.withDefault "")
            ++ (Maybe.map (\v -> "-" ++ v ) (columnCountOption columns)
                    |> Maybe.withDefault "")
            |> class
            |> Just


columnCountOption : ColumnCount -> Maybe String
columnCountOption size =
    case size of
        One -> Just "1"
        Two -> Just "2"
        Three -> Just "3"
        Four -> Just "4"
        Five -> Just "5"
        Six -> Just "6"
        Seven -> Just "7"
        Eight -> Just "8"
        Nine -> Just "9"
        Ten -> Just "10"
        Eleven -> Just "11"
        Twelve -> Just "12"
        None -> Nothing



alignOption : Align -> String
alignOption align =
    case align of
        Start ->
            "start"

        Center ->
            "center"

        End ->
            "end"





screenSizeOption : ScreenSize -> Maybe String
screenSizeOption size =
    case size of
        ExtraSmall ->
            Nothing

        Small ->
            Just "sm"

        Medium ->
            Just "md"

        Large ->
            Just "lg"

        ExtraLarge ->
            Just "xl"

