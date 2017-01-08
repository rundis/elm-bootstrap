module Bootstrap.Internal.Button exposing
    (buttonAttributes
    , ButtonOption (..)
    , Role (..)
    )


import Bootstrap.Internal.Grid as GridInternal
import Html
import Html.Attributes as Attributes exposing (class)



type ButtonOption
    = SizeButton GridInternal.ScreenSize
    | RoleButton Role
    | OutlineButton Role
    | BlockButton


type Role
    = Primary
    | Secondary
    | Success
    | Info
    | Warning
    | Danger
    | Link


buttonAttributes : List ButtonOption -> List (Html.Attribute msg)
buttonAttributes options =
    class "btn" :: List.map buttonClass options



buttonClass : ButtonOption -> Html.Attribute msg
buttonClass style =
    class <|
        case style of
            RoleButton role ->
                "btn-" ++ roleClass role

            SizeButton size ->
                "btn-" ++ GridInternal.screenSizeOption size

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
