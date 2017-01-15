module Bootstrap.Checkbox exposing
    ( checkbox
    , attr
    , disabled
    , inline
    , FormCheckOption
    )

{-| Create standalone checkboxes using this module

@docs checkbox, disabled, inline, attr, FormCheckOption
-}
import Html
import Bootstrap.Internal.Form as FormInternal exposing (FormCheckOption(..))


{-| Opaque type representing configuration options for a checkbox
-}
type alias FormCheckOption msg = FormInternal.FormCheckOption msg


{-| Create as input type="checkbox"

    Checkbox.checkbox [] "My check"

-}
checkbox :
    List (FormCheckOption msg)
    -> String
    -> Html.Html msg
checkbox =
    FormInternal.checkbox


{-| Option to create a std Html.Attribute option
-}
attr : Html.Attribute msg -> FormCheckOption msg
attr attr =
    CheckAttr attr


{-| Option to disable a checkbox.
-}
disabled : FormCheckOption msg
disabled =
    CheckDisabled

{-| Option to align checkboxes horizontally. Handy when you want to place checkboxes next to eachother
-}
inline : FormCheckOption msg
inline =
    CheckInline
