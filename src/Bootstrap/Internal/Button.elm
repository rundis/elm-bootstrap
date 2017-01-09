module Bootstrap.Internal.Button exposing
    (buttonAttributes
    , ButtonOption (..)
    , Role (..)
    )


import Bootstrap.Internal.Grid as GridInternal
import Html
import Html.Attributes as Attributes exposing (class)



type ButtonOption msg
    = SizeButton GridInternal.ScreenSize
    | RoleButton Role
    | OutlineButton Role
    | BlockButton
    | ButtonAttr (Html.Attribute msg)


type Role
    = Primary
    | Secondary
    | Success
    | Info
    | Warning
    | Danger
    | Link


buttonAttributes : List (ButtonOption msg)  -> List (Html.Attribute msg)
buttonAttributes options =
    class "btn" :: List.map buttonAttribute options



buttonAttribute : ButtonOption msg -> Html.Attribute msg
buttonAttribute style =

        case style of
            RoleButton role ->
                class <| "btn-" ++ roleClass role

            SizeButton size ->
                class <| "btn-" ++ GridInternal.screenSizeOption size

            OutlineButton role ->
                class <| "btn-outline-" ++ roleClass role

            BlockButton ->
                class <| "btn-block"

            ButtonAttr attr ->
                attr



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
