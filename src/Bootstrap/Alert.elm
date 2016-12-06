module Bootstrap.Alert
    exposing
        ( success
        , info
        , warning
        , danger
        , link
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        )

import Html
import Html.Attributes exposing (class)


type Role
    = Success
    | Info
    | Warning
    | Danger


success : List (Html.Html msg) -> Html.Html msg
success children =
    alertCustom Success children


info : List (Html.Html msg) -> Html.Html msg
info children =
    alertCustom Info children


warning : List (Html.Html msg) -> Html.Html msg
warning children =
    alertCustom Warning children


danger : List (Html.Html msg) -> Html.Html msg
danger children =
    alertCustom Danger children


alertCustom : Role -> List (Html.Html msg) -> Html.Html msg
alertCustom role children =
    Html.div
        [ class <| "alert " ++ roleClass role ]
        children


link : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
link attributes children =
    Html.a
        (class "alert-link" :: attributes)
        children


h1 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h1 attributes children =
    heading Html.h1 attributes children

h2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h2 attributes children =
    heading Html.h2 attributes children

h3 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h3 attributes children =
    heading Html.h3 attributes children

h4 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h4 attributes children =
    heading Html.h4 attributes children

h5 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h5 attributes children =
    heading Html.h5 attributes children

h6 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h6 attributes children =
    heading Html.h6 attributes children



heading :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
heading elemFn attributes children =
    elemFn
        (class "alert-header" :: attributes)
        children


roleClass : Role -> String
roleClass role =
    case role of
        Success ->
            "alert-success"

        Info ->
            "alert-info"

        Warning ->
            "alert-warning"

        Danger ->
            "alert-danger"
