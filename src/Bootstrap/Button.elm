module Bootstrap.Button exposing
    ( button
    , linkButton
    , size
    , role
    , block
    , outline
    , buttonStylesClass
    , ButtonStyles
    , Size (..)
    , Role (..)
    )

import Html
import Html.Attributes as Attributes exposing (class)


type Size
    = ExtraSmall
    | Small
    | Medium
    | Large


type Role
    = Primary
    | Secondary
    | Success
    | Info
    | Warning
    | Danger
    | Link


type ButtonStyles
    = SizeButton Size
    | RoleButton Role
    | OutlineButton Role
    | BlockButton


button :
    List ButtonStyles
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
button styles attributes children =
    Html.button
        ([ class <| buttonStylesClass styles ] ++ attributes)
        children


linkButton :
    List ButtonStyles
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
linkButton styles attributes children =
    Html.a
        ([ class <| buttonStylesClass styles
         , Attributes.attribute "role" "button"
         ] ++ attributes)
        children


size : Size -> ButtonStyles
size s =
    SizeButton s


role : Role -> ButtonStyles
role r =
    RoleButton r


outline : Role -> ButtonStyles
outline role =
    OutlineButton role


block : ButtonStyles
block =
    BlockButton



buttonStylesClass : List ButtonStyles -> String
buttonStylesClass styles =
    List.foldl
        (\style classString ->
            String.join " " [ classString, buttonStyleClass style ]
        )
        "btn"
        styles


buttonStyleClass : ButtonStyles -> String
buttonStyleClass style =
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


sizeClass : Size -> String
sizeClass size =
    case size of
        ExtraSmall ->
            "btn-xs"

        Small ->
            "btn-sm"

        Medium ->
            "btn-md"

        Large ->
            "btn-lg"
