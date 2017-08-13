module Bootstrap.Internal.Text
    exposing
        ( textAlignClass
        , textColorClass
        , TextAlignDir(..)
        , HAlign
        , Color(..)
        )

import Html
import Html.Attributes
import Bootstrap.Grid.Internal as GridInternal
import Bootstrap.Internal.Role as Role


type alias HAlign =
    { dir : TextAlignDir
    , size : GridInternal.ScreenSize
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
        ++ (Maybe.map (\s -> "-" ++ s ++ "-") (GridInternal.screenSizeOption size)
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

