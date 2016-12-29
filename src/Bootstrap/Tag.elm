module Bootstrap.Tag
    exposing
        ( tag
        , pill
        , tagRoled
        , pillRoled
        , tagCustom
        , pillCustom
        , floatDefault
        , float
        , roleDefault
        , role
        , Role(..)
        , Float(..)
        , TagOption
        )

import Html
import Html.Attributes exposing (class)
import Bootstrap.Grid as Grid


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



type TagOption
    = Roled Role
    | Floated Float Grid.ScreenSize
    | Pill


tag : List (Html.Html msg) -> Html.Html msg
tag children =
    tagRoled Default children


tagRoled : Role -> List (Html.Html msg) -> Html.Html msg
tagRoled role children =
    tagCustom [ Roled role ] children


tagCustom : List TagOption -> List (Html.Html msg) -> Html.Html msg
tagCustom classes children =
    Html.span
        [ class <| tagOptions classes ]
        children


pill : List (Html.Html msg) -> Html.Html msg
pill children =
    pillRoled Default children


pillRoled : Role -> List (Html.Html msg) -> Html.Html msg
pillRoled role children =
    pillCustom [ Roled role ] children


pillCustom : List TagOption -> List (Html.Html msg) -> Html.Html msg
pillCustom classes children =
    tagCustom (Pill :: classes) children


roleDefault : TagOption
roleDefault =
    Roled Default


role : Role -> TagOption
role rl =
    Roled rl


float : Float -> Grid.ScreenSize -> TagOption
float float size =
    Floated float size


floatDefault : TagOption
floatDefault =
    Floated Right Grid.ExtraSmall


tagOptions : List TagOption -> String
tagOptions options =
    List.foldl
        (\option optionString ->
            String.join " " [ optionString, tagOption option ]
        )
        "tag"
        options


tagOption : TagOption -> String
tagOption option =
    case option of
        Pill ->
            "tag-pill"

        Roled role ->
            roleOption role

        Floated float size ->
            "float-" ++ Grid.screenSizeString size ++ "-" ++ floatOption float


roleOption : Role -> String
roleOption role =
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


floatOption : Float -> String
floatOption float =
    case float of
        Left ->
            "left"

        Right ->
            "right"

