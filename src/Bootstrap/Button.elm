module Bootstrap.Button
    exposing
        ( button
        , linkButton
        , size
        , role
        , block
        , outline
        , buttonOptionsString
        , ButtonOption
        , Role(..)
        , ButtonConfig
        )

import Html
import Html.Attributes as Attributes exposing (class)
import Bootstrap.Grid as Grid


type alias ButtonConfig msg =
    { options : List ButtonOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type Role
    = Primary
    | Secondary
    | Success
    | Info
    | Warning
    | Danger
    | Link


type ButtonOption
    = SizeButton Grid.ScreenSize
    | RoleButton Role
    | OutlineButton Role
    | BlockButton


button : ButtonConfig msg -> Html.Html msg
button { options, attributes, children } =
    Html.button
        ([ class <| buttonOptionsString options ] ++ attributes)
        children


linkButton : ButtonConfig msg -> Html.Html msg
linkButton { options, attributes, children } =
    Html.a
        ([ class <| buttonOptionsString options
         , Attributes.attribute "role" "button"
         ]
            ++ attributes
        )
        children


size : Grid.ScreenSize -> ButtonOption
size s =
    SizeButton s


role : Role -> ButtonOption
role r =
    RoleButton r


outline : Role -> ButtonOption
outline role =
    OutlineButton role


block : ButtonOption
block =
    BlockButton


buttonOptionsString : List ButtonOption -> String
buttonOptionsString options =
    List.foldl
        (\option classString ->
            String.join " " [ classString, buttonOption option ]
        )
        "btn"
        options


buttonOption : ButtonOption -> String
buttonOption style =
    case style of
        RoleButton role ->
            "btn-" ++ roleClass role

        SizeButton size ->
            sizeClass size

        OutlineButton role ->
            "btn-outline-" ++ roleClass role

        BlockButton ->
            "btn-block"


roleClass : Role -> String
roleClass role =
    case role of
        Primary ->
            "primary"

        Secondary ->
            "secondary"

        Success ->
            "success"

        Info ->
            "info"

        Warning ->
            "warning"

        Danger ->
            "danger"

        Link ->
            "link"


sizeClass : Grid.ScreenSize -> String
sizeClass size =
    case size of
        Grid.ExtraSmall ->
            "btn-xs"

        Grid.Small ->
            "btn-sm"

        Grid.Medium ->
            "btn-md"

        Grid.Large ->
            "btn-lg"
