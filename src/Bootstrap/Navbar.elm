module Bootstrap.Navbar
    exposing
        ( navbar
        , fix
        , scheme
        , brand
        , itemLink
        , customItem
        , NavbarOption
        , Fix(..)
        , LinkModifier(..)
        , BackgroundColor(..)
        , NavItem
        )

import Html
import Html.Attributes exposing (class)


type NavbarOption
    = NavbarFix Fix
    | NavbarScheme Scheme


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




type NavItem msg
    = NavItem (Html.Html msg)

navbar :
    { options : List NavbarOption
    , attributes : List (Html.Attribute msg)
    , items : List (NavItem msg)
    }
    -> Html.Html msg
navbar {options, attributes, items} =
    Html.nav
        ([ class <| navbarOptions options ] ++ attributes)
        [renderNav items]


renderNav : List (NavItem msg) -> Html.Html msg
renderNav navItems =
    Html.ul
        [class "nav navbar-nav"]
        (List.map (\(NavItem item) -> item) navItems)


brand : List (Html.Attribute msg) -> List (Html.Html msg) -> NavItem msg
brand attributes children =
    NavItem <|
        Html.a
            ([class "navbar-brand"] ++ attributes)
            children

itemLink : List (Html.Attribute msg) -> List (Html.Html msg) -> NavItem msg
itemLink attributes children =
    NavItem <|
        Html.li
            [class "nav-item"]
            [ Html.a
                ([class "nav-link"] ++ attributes)
                children
            ]



customItem : Html.Html msg -> NavItem msg
customItem elem =
    NavItem elem



fix : Fix -> NavbarOption
fix f =
    NavbarFix f


scheme : LinkModifier -> BackgroundColor -> NavbarOption
scheme modifier bgColor =
    NavbarScheme <|
        Scheme
            { modifier = modifier
            , bgColor = bgColor
            }


navbarOptions : List NavbarOption -> String
navbarOptions options =
    List.foldl
        (\option classString ->
            String.join " " [ classString, navbarOption option ]
        )
        "navbar"
        options


navbarOption : NavbarOption -> String
navbarOption option =
    case option of
        NavbarFix fix ->
            fixOption fix

        NavbarScheme scheme ->
            schemeOption scheme


fixOption : Fix -> String
fixOption fix =
    case fix of
        FixTop ->
            "navbar-fixed-top"

        FixBottom ->
            "navbar-fixed-bottom"


schemeOption : Scheme -> String
schemeOption (Scheme { modifier, bgColor }) =
    linkModifierOption
        modifier
        ++ " "
        ++ backgroundColorOption bgColor


linkModifierOption : LinkModifier -> String
linkModifierOption modifier =
    case modifier of
        Dark ->
            "navbar-dark"

        Light ->
            "navbar-light"


backgroundColorOption : BackgroundColor -> String
backgroundColorOption bgClass =
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
