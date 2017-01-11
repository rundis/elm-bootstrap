module Bootstrap.Badge
    exposing
        ( simpleBadge
        , simplePill
        , badge
        , pill
        , roleDefault
        , rolePrimary
        , roleSuccess
        , roleInfo
        , roleWarning
        , roleDanger
        , BadgeOption
        )

{-| Small and adaptive badge for adding context to just about any content.

# Tags
@docs simpleBadge, badge


# Pills
@docs simplePill, pill

# Options

@docs BadgeOption

## Roles
@docs roleDefault, rolePrimary, roleSuccess, roleInfo, roleWarning, roleDanger

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



{-| Opaque type representing a badge styling option -}
type BadgeOption
    = Roled Role
    | Pill

{-| Create a badge with default styling

* `children` List of child elements

-}
simpleBadge : List (Html.Html msg) -> Html.Html msg
simpleBadge children =
    badgeRoled Default children


badgeRoled : Role -> List (Html.Html msg) -> Html.Html msg
badgeRoled role children =
    badge [ Roled role ] children



{-| Create a badge with potential several styling options

    div
        []
        [ Badge.badge [Badge.rolePrimary] [Html.text "1"] ]


* `options` List of options to style the badge
* `children` List of child elements

-}
badge : List BadgeOption -> List (Html.Html msg) -> Html.Html msg
badge options children =
    Html.span
        (badgeAttributes options)
        children


{-| Create a pill (badge with rounded corners) using default coloring

* `children` List of child elements

-}
simplePill : List (Html.Html msg) -> Html.Html msg
simplePill children =
    pillRoled Default children


pillRoled : Role -> List (Html.Html msg) -> Html.Html msg
pillRoled role children =
    pill [ Roled role ] children


{-| Create a pill with potential several styling options

    div
        []
        [ Badge.pill [Badge.rolePrimary] [Html.text "1"] ]


* `options` List of options to style the badge
* `children` List of child elements

-}
pill : List BadgeOption -> List (Html.Html msg) -> Html.Html msg
pill classes children =
    badge (Pill :: classes) children



{-| Option for Default colored badge/pill -}
roleDefault : BadgeOption
roleDefault =
    Roled Default


{-| Option for Primary colored badge/pill -}
rolePrimary : BadgeOption
rolePrimary =
    Roled Primary


{-| Option for Success colored badge/pill -}
roleSuccess : BadgeOption
roleSuccess =
    Roled Success

{-| Option for Info colored badge/pill -}
roleInfo : BadgeOption
roleInfo =
    Roled Info

{-| Option for Warning colored badge/pill -}
roleWarning : BadgeOption
roleWarning =
    Roled Warning


{-| Option for Danger colored badge/pill -}
roleDanger : BadgeOption
roleDanger =
    Roled Danger





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
