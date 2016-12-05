module Bootstrap.Tag
    exposing
        ( tag
        , pill
        , tagRoled
        , pillRoled
        , Role (..)
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


tag : List (Html.Html msg) -> Html.Html msg
tag children =
    tagRoled Default children


tagRoled : Role -> List (Html.Html msg) -> Html.Html msg
tagRoled role children =
    Html.span
        [ class <| "tag " ++ tagClassString role ]
        children


pill : List (Html.Html msg) -> Html.Html msg
pill children =
    pillRoled Default children


pillRoled : Role -> List (Html.Html msg) -> Html.Html msg
pillRoled role children =
    Html.span
        [ class <| "tag tag-pill " ++ tagClassString role ]
        children


tagClassString : Role -> String
tagClassString role =
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
