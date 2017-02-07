module Bootstrap.Badge
    exposing
        ( badge
        , badgePrimary
        , badgeSuccess
        , badgeInfo
        , badgeWarning
        , badgeDanger
        , pill
        , pillPrimary
        , pillSuccess
        , pillInfo
        , pillWarning
        , pillDanger
        )

{-| Small and adaptive badge for adding context to just about any content.

# Tags
@docs badge, badgePrimary, badgeSuccess, badgeInfo, badgeWarning, badgeDanger


# Pills
@docs pill, pillPrimary, pillSuccess, pillInfo, pillWarning, pillDanger

-}

import Html
import Html.Attributes exposing (class)


type Role
    = Default
    | Primary
    | Success
    | Info
    | Warning
    | Danger


{-| Opaque type representing a badge styling option
-}
type BadgeOption
    = Roled Role
    | Pill


{-| Create a badge with default styling

* `attributes` List of attributes
* `children` List of child elements

-}
badge : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
badge =
    badgeInternal [ Roled Default ]


{-| Create a badge with primary colors

* `attributes` List of attributes
* `children` List of child elements

-}
badgePrimary :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
badgePrimary =
    badgeInternal [ Roled Primary ]


{-| Create a badge with success colors

* `attributes` List of attributes
* `children` List of child elements

-}
badgeSuccess :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
badgeSuccess =
    badgeInternal [ Roled Success ]


{-| Create a badge with info colors

* `attributes` List of attributes
* `children` List of child elements

-}
badgeInfo : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
badgeInfo =
    badgeInternal [ Roled Info ]


{-| Create a badge with warning colors

* `attributes` List of attributes
* `children` List of child elements

-}
badgeWarning :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
badgeWarning =
    badgeInternal [ Roled Warning ]


{-| Create a badge with danger colors

* `attributes` List of attributes
* `children` List of child elements

-}
badgeDanger : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
badgeDanger =
    badgeInternal [ Roled Danger ]


{-| Create a pill (badge with rounded corners) using default coloring

* `attributes` List of attributes
* `children` List of child elements

-}
pill : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
pill =
    badgeInternal [ Roled Default, Pill ]


{-| Create a pill with primary colors

* `attributes` List of attributes
* `children` List of child elements

-}
pillPrimary :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
pillPrimary =
    badgeInternal [ Roled Primary, Pill ]


{-| Create a pill with success colors

* `attributes` List of attributes
* `children` List of child elements

-}
pillSuccess :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
pillSuccess =
    badgeInternal [ Roled Success, Pill ]


{-| Create a pill with info colors

* `attributes` List of attributes
* `children` List of child elements

-}
pillInfo : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
pillInfo =
    badgeInternal [ Roled Info, Pill ]


{-| Create a pill with warning colors

* `attributes` List of attributes
* `children` List of child elements

-}
pillWarning :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
pillWarning =
    badgeInternal [ Roled Warning, Pill ]


{-| Create a pill with danger colors

* `attributes` List of attributes
* `children` List of child elements

-}
pillDanger : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
pillDanger =
    badgeInternal [ Roled Danger, Pill ]




badgeInternal :
    List BadgeOption
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
badgeInternal options attributes children =
    Html.span
        (badgeAttributes options ++ attributes)
        children



badgeAttributes : List BadgeOption -> List (Html.Attribute msg)
badgeAttributes options =
    class "badge" :: List.map badgeClass options


badgeClass : BadgeOption -> Html.Attribute msg
badgeClass option =
    class <|
        case option of
            Pill ->
                "badge-pill"

            Roled role ->
                roleOption role


roleOption : Role -> String
roleOption role =
    case role of
        Default ->
            "badge-default"

        Primary ->
            "badge-primary"

        Success ->
            "badge-success"

        Info ->
            "badge-info"

        Warning ->
            "badge-warning"

        Danger ->
            "badge-danger"
