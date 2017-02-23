module Bootstrap.Form.FormInternal exposing (..)


import Html
import Html.Attributes as Attributes

type Validation
    = Success
    | Warning
    | Danger


validationWrapperAttribute : Validation -> Html.Attribute msg
validationWrapperAttribute validation =
    Attributes.class <| "has-" ++ validationToString validation


validationToString : Validation -> String
validationToString validation =
    case validation of
        Success ->
            "success"

        Warning ->
            "warning"

        Danger ->
            "danger"
