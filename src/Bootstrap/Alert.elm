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

{-| Provide contextual feedback messages for typical user actions with the handful of available and flexible alert messages.


    Alert.info
        [ Alert.h4 "For your information"
        , p [] [ text "An information message of sorts"]
        , Alert.link [ href "/somelink" ] [ text "link"]
        ]

# Contextual alerts
@docs success, info, warning, danger


## Styled content
@docs link, h1, h2, h3, h4, h5, h6

-}

import Html
import Html.Attributes exposing (class)


type Role
    = Success
    | Info
    | Warning
    | Danger


{-| Alert signaling success

* `children` List of child elements

-}
success : List (Html.Html msg) -> Html.Html msg
success children =
    alertCustom Success children


{-| Alert information

* `children` List of child elements

-}
info : List (Html.Html msg) -> Html.Html msg
info children =
    alertCustom Info children


{-| Alert signaling a warning of sorts

* `children` List of child elements

-}
warning : List (Html.Html msg) -> Html.Html msg
warning children =
    alertCustom Warning children


{-| Alert signaling an error

* `children` List of child elements

-}
danger : List (Html.Html msg) -> Html.Html msg
danger children =
    alertCustom Danger children


alertCustom : Role -> List (Html.Html msg) -> Html.Html msg
alertCustom role children =
    Html.div
        [ class <| "alert " ++ roleClass role ]
        children


{-| To get proper link colors for `a` elements use this function

* `attributes` List of attributes for the link element
* `children` List of child elements

-}
link : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
link attributes children =
    Html.a
        (class "alert-link" :: attributes)
        children


{-| Alert h1 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h1 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h1 attributes children =
    heading Html.h1 attributes children


{-| Alert h2 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h2 attributes children =
    heading Html.h2 attributes children


{-| Alert h3 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h3 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h3 attributes children =
    heading Html.h3 attributes children


{-| Alert h3 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h4 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h4 attributes children =
    heading Html.h4 attributes children


{-| Alert h5 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h5 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h5 attributes children =
    heading Html.h5 attributes children


{-| Alert h6 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
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
