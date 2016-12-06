module Bootstrap.Tag
    exposing
        ( tag
        , pill
        , tagRoled
        , pillRoled
        , tagCustom
        , pillCustom
        , Role (..)
        , Float (..)
        , Size (..)
        , TagClass
        )

import Html
import Html.Attributes exposing (class)


type Role
    = Default
    | Primary
    | Success
    | Info
    | Warning
    | Danger


type Float
    = Left
    | Right

type Size
    = ExtraSmall
    | Small
    | Medium
    | Large



type TagClass
    = Roled Role
    | Floated Float Size
    | Pill



tag : List (Html.Html msg) -> Html.Html msg
tag children =
    tagRoled Default children


tagRoled : Role -> List (Html.Html msg) -> Html.Html msg
tagRoled role children =
    tagCustom [Roled role] children


tagCustom : List TagClass -> List (Html.Html msg) -> Html.Html msg
tagCustom classes children =
    Html.span
        [ class <| tagClasses classes]
        children


pill : List (Html.Html msg) -> Html.Html msg
pill children =
    pillRoled Default children


pillRoled : Role -> List (Html.Html msg) -> Html.Html msg
pillRoled role children =
    pillCustom [Roled role] children


pillCustom : List TagClass -> List (Html.Html msg) -> Html.Html msg
pillCustom classes children =
    tagCustom (Pill :: classes) children


roled : Role -> TagClass
roled rl =
    Roled rl


floated : Float -> Size -> TagClass
floated float size =
    Floated float size


tagClasses : List TagClass -> String
tagClasses classes =
    List.foldl
        (\class classString ->
            String.join " " [classString, tagClass class]
        )
        "tag"
        classes


tagClass : TagClass -> String
tagClass class =
    case class of
        Pill ->
            "tag-pill"

        Roled role ->
            roleClass role

        Floated float size ->
            "float-" ++ sizeClass size ++ "-" ++ floatClass float



roleClass : Role -> String
roleClass role =
    case role of
        Default ->
            "tag-default"

        Primary ->
            "tag-primary"

        Success ->
            "tag-success"

        Info ->
            "tag-info"

        Warning ->
            "tag-warning"

        Danger ->
            "tag-danger"


floatClass : Float -> String
floatClass float =
    case float of
        Left ->
            "left"

        Right ->
            "right"


sizeClass : Size -> String
sizeClass size =
    case size of
        ExtraSmall ->
            "xs"

        Small ->
            "sm"

        Medium ->
            "md"

        Large ->
            "lg"
