module Bootstrap.Internal.Text
    exposing
        ( textAlignClass
        , TextAlignDir(..)
        , HAlign
        )

import Html
import Html.Attributes
import Bootstrap.Internal.Grid as GridInternal


type alias HAlign =
    { dir : TextAlignDir
    , size : GridInternal.ScreenSize
    }


type TextAlignDir
    = Left
    | Center
    | Right


textAlignClass : HAlign -> Html.Attribute msg
textAlignClass { dir, size } =
    Html.Attributes.class <| "text-" ++ GridInternal.screenSizeOption size ++ "-" ++ textAlignDirOption dir


textAlignDirOption : TextAlignDir -> String
textAlignDirOption dir =
    case dir of
        Center ->
            "center"

        Left ->
            "left"

        Right ->
            "right"
