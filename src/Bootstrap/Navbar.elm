module Bootstrap.Navbar
    exposing
        ( navbar
        , fix
        , scheme
        , nav
        , navBrand
        , navItemLink
        , navCustomItem
        , NavbarStyles
        , Fix(..)
        , LinkModifier(..)
        , BackgroundColor(..)
        )

import Html
import Html.Attributes exposing (class)


type NavbarStyles
    = StyleFix Fix
    | StyleScheme Scheme


type Fix
    = FixTop
    | FixBottom


type Scheme
    = Scheme
        { modifier : LinkModifier
        , bgColor : BackgroundColor
        }


type LinkModifier
    = Dark
    | Light


type BackgroundColor
    = Faded
    | Primary
    | Success
    | Info
    | Warning
    | Danger
    | Inverse



type Nav msg
    = Nav (Html.Html msg)

type NavItem msg
    = NavItem (Html.Html msg)

navbar :
    List NavbarStyles
    -> List (Html.Attribute msg)
    -> Nav msg
    -> Html.Html msg
navbar styles attributes (Nav children) =
    Html.nav
        ([ class <| navbarStylesClass styles ] ++ attributes)
        [children]


nav : List (NavItem msg) -> Nav msg
nav navItems =
    Nav <|
        Html.ul
            [class "nav navbar-nav"]
            (List.map (\(NavItem item) -> item) navItems)


navBrand : List (Html.Attribute msg) -> List (Html.Html msg) -> NavItem msg
navBrand attributes children =
    NavItem <|
        Html.a
            ([class "navbar-brand"] ++ attributes)
            children

navItemLink : List (Html.Attribute msg) -> List (Html.Html msg) -> NavItem msg
navItemLink attributes children =
    NavItem <|
        Html.li
            [class "nav-item"]
            [ Html.a
                ([class "nav-link"] ++ attributes)
                children
            ]



navCustomItem : Html.Html msg -> NavItem msg
navCustomItem elem =
    NavItem elem



fix : Fix -> NavbarStyles
fix f =
    StyleFix f


scheme : LinkModifier -> BackgroundColor -> NavbarStyles
scheme modifier bgColor =
    StyleScheme <|
        Scheme
            { modifier = modifier
            , bgColor = bgColor
            }



navbarStylesClass : List NavbarStyles -> String
navbarStylesClass styles =
    List.foldl
        (\style classString ->
            String.join " " [ classString, navbarStyleClass style ]
        )
        "navbar"
        styles


navbarStyleClass : NavbarStyles -> String
navbarStyleClass style =
    case style of
        StyleFix fix ->
            fixClass fix

        StyleScheme scheme ->
            schemeClass scheme


fixClass : Fix -> String
fixClass fix =
    case fix of
        FixTop ->
            "navbar-fixed-top"

        FixBottom ->
            "navbar-fixed-bottom"


schemeClass : Scheme -> String
schemeClass (Scheme { modifier, bgColor }) =
    linkModifierClass
        modifier
        ++ " "
        ++ backgroundColorClass bgColor


linkModifierClass : LinkModifier -> String
linkModifierClass modifier =
    case modifier of
        Dark ->
            "navbar-dark"

        Light ->
            "navbar-light"


backgroundColorClass : BackgroundColor -> String
backgroundColorClass bgClass =
    case bgClass of
        Faded ->
            "bg-faded"

        Primary ->
            "bg-primary"

        Success ->
            "bg-success"

        Info ->
            "bg-info"

        Warning ->
            "bg-warning"

        Danger ->
            "bg-danger"

        Inverse ->
            "bg-inverse"
