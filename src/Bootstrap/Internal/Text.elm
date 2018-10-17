module Bootstrap.Internal.Text exposing
    ( Color(..)
    , HAlign
    , TextAlignDir(..)
    , textAlignClass
    , textColorClass
    )

import Bootstrap.General.Internal exposing (ScreenSize(..), screenSizeOption)
import Bootstrap.Internal.Role as Role
import Html
import Html.Attributes


type alias HAlign =
    { dir : TextAlignDir
    , size : ScreenSize
    }


type TextAlignDir
    = Left
    | Center
    | Right


type Color
    = Role Role.Role
    | White


textAlignClass : HAlign -> Html.Attribute msg
textAlignClass { dir, size } =
    "text"
        ++ (Maybe.map (\s -> "-" ++ s ++ "-") (screenSizeOption size)
                |> Maybe.withDefault "-"
           )
        ++ textAlignDirOption dir
        |> Html.Attributes.class


textAlignDirOption : TextAlignDir -> String
textAlignDirOption dir =
    case dir of
        Center ->
            "center"

        Left ->
            "left"

        Right ->
            "right"


textColorClass : Color -> Html.Attribute msg
textColorClass color =
    case color of
        White ->
            Html.Attributes.class "text-white"

        Role role ->
            Role.toClass "text" role
