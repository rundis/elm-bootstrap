module Bootstrap.General.Internal exposing (HAlign, HorizontalAlign(..), ScreenSize(..), hAlignClass, horizontalAlignOption, screenSizeOption)

import Html
import Html.Attributes exposing (class)


type alias HAlign =
    { screenSize : ScreenSize
    , align : HorizontalAlign
    }


type HorizontalAlign
    = Left
    | Center
    | Right
    | Around
    | Between


type ScreenSize
    = XS
    | SM
    | MD
    | LG
    | XL


hAlignClass : HAlign -> Html.Attribute msg
hAlignClass { align, screenSize } =
    class <|
        ("justify-content-"
            ++ (Maybe.map (\v -> v ++ "-") (screenSizeOption screenSize)
                    |> Maybe.withDefault ""
               )
            ++ horizontalAlignOption align
        )


horizontalAlignOption : HorizontalAlign -> String
horizontalAlignOption align =
    case align of
        Left ->
            "start"

        Center ->
            "center"

        Right ->
            "end"

        Around ->
            "around"

        Between ->
            "between"


screenSizeOption : ScreenSize -> Maybe String
screenSizeOption size =
    case size of
        XS ->
            Nothing

        SM ->
            Just "sm"

        MD ->
            Just "md"

        LG ->
            Just "lg"

        XL ->
            Just "xl"
