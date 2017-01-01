module Bootstrap.Internal.Text
    exposing
        ( textAlignOption
        , TextAlignDir(..)
        , HAlign
        )

import Bootstrap.Internal.Grid as GridInternal


type alias HAlign =
    { dir : TextAlignDir
    , size : GridInternal.ScreenSize
    }


type TextAlignDir
    = Left
    | Center
    | Right


textAlignOption : HAlign -> String
textAlignOption { dir, size } =
    "text-" ++ GridInternal.screenSizeOption size ++ "-" ++ textAlignDirOption dir


textAlignDirOption : TextAlignDir -> String
textAlignDirOption dir =
    case dir of
        Center ->
            "center"

        Left ->
            "left"

        Right ->
            "right"
