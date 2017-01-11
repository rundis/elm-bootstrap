module Bootstrap.Navbar
    exposing
        ( navbar
        , fixTop
        , fixBottom
        , faded
        , primary
        , success
        , info
        , warning
        , danger
        , inverse
        , brand
        , itemLink
        , customItem
        , NavbarOption
        , NavItem
        , NavBrand
        )

import Html
import Html.Attributes exposing (class)


type NavbarOption
    = NavbarFix Fix
    | NavbarScheme Scheme


type Fix
    = Top
    | Bottom


type alias Scheme =
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

type NavBrand msg
    = NavBrand (Html.Html msg)

navbar :
    { options : List NavbarOption
    , attributes : List (Html.Attribute msg)
    , brand : Maybe (NavBrand msg)
    , items : List (NavItem msg)
    }
    -> Html.Html msg
navbar {options, attributes, brand, items} =
    Html.nav
        (navbarAttributes options ++ attributes ++ [class "navbar-toggleable-md"])
        (maybeBrand brand ++ [renderNav items])


maybeBrand : Maybe (NavBrand msg) -> List (Html.Html msg)
maybeBrand brand =
    case brand of
        Just (NavBrand b) ->
            [b]
        Nothing ->
            []


renderNav : List (NavItem msg) -> Html.Html msg
renderNav navItems =
    Html.ul
        [ class "navbar-nav" ]
        (List.map (\(NavItem item) -> item) navItems)


brand : List (Html.Attribute msg) -> List (Html.Html msg) -> NavBrand msg
brand attributes children =
    NavBrand <|
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


fixTop : NavbarOption
fixTop =
    NavbarFix Top


fixBottom : NavbarOption
fixBottom =
    NavbarFix Bottom




inverse : NavbarOption
inverse =
    scheme Dark Inverse


faded : NavbarOption
faded =
    scheme Light Faded

primary : NavbarOption
primary =
    scheme Dark Primary

success : NavbarOption
success =
    scheme Dark Success

info : NavbarOption
info =
     scheme Dark Info

warning : NavbarOption
warning =
    scheme Dark Warning


danger : NavbarOption
danger =
    scheme Dark Danger


scheme : LinkModifier -> BackgroundColor -> NavbarOption
scheme modifier bgColor =
        { modifier = modifier
        , bgColor = bgColor
        }
            |> NavbarScheme


navbarAttributes : List NavbarOption -> List (Html.Attribute msg)
navbarAttributes options =
    class "navbar" :: List.map navbarClass options


navbarClass : NavbarOption -> Html.Attribute msg
navbarClass option =
    class <|
        case option of
            NavbarFix fix ->
                fixOption fix

            NavbarScheme scheme ->
                schemeOption scheme


fixOption : Fix -> String
fixOption fix =
    case fix of
        Top ->
            "fixed-top"

        Bottom ->
            "fixed-bottom"


schemeOption : Scheme -> String
schemeOption { modifier, bgColor } =
    linkModifierOption
        modifier
        ++ " "
        ++ backgroundColorOption bgColor


linkModifierOption : LinkModifier -> String
linkModifierOption modifier =
    case modifier of
        Dark ->
            "navbar-inverse"

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
