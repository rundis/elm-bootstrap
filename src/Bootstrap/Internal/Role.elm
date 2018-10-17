module Bootstrap.Internal.Role exposing (Role(..), toClass)

import Html
import Html.Attributes exposing (class)


type Role
    = Primary
    | Secondary
    | Success
    | Info
    | Warning
    | Danger
    | Light
    | Dark


toClass : String -> Role -> Html.Attribute msg
toClass prefix role =
    class <|
        prefix
            ++ "-"
            ++ (case role of
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

                    Light ->
                        "light"

                    Dark ->
                        "dark"
               )
