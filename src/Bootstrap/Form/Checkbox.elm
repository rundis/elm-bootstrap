module Bootstrap.Form.Checkbox
    exposing
        ( checkbox
        , custom
        , checked
        , inline
        , indeterminate
        , disabled
        , onCheck
        , attrs
        , success
        , warning
        , danger
        , Option
        )

{-| This module allows you to create Bootstrap styled checkboxes.


# Creating
@docs checkbox, custom

# Options
@docs checked, inline, indeterminate, disabled, onCheck, attrs, success, warning, danger, Option


-}

import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Bootstrap.Form.FormInternal as FormInternal


{-| Opaque composable type represetning a Checkbox.
-}
type Checkbox msg
    = Checkbox
        { options : List (Option msg)
        , label : String
        }


{-| Opaque type representing valid customization options for a checkbox
-}
type Option msg
    = Value CheckValue
    | Inline
    | OnChecked (Bool -> msg)
    | Custom
    | Disabled Bool
    | Validation FormInternal.Validation
    | Attrs (List (Html.Attribute msg))


type CheckValue
    = On
    | Off
    | Indeterminate


type alias Options msg =
    { state : CheckValue
    , inline : Bool
    , custom : Bool
    , disabled : Bool
    , onChecked : Maybe (Bool -> msg)
    , validation : Maybe FormInternal.Validation
    , attributes : List (Html.Attribute msg)
    }


{-| Create a checkbox element

    Checkbox.checkbox
        [ Checkbox.checked True
        , Checkbox.onCheck MyCheckMsg
        ]

-}
checkbox : List (Option msg) -> String -> Html.Html msg
checkbox options label =
    create options label |> view


{-| Create a composable Bootstrap custom styled checkbox

    Checkbox.custom
        [ Checkbox.checked True
        , Checkbox.onCheck MyCheckMsg
        ]

-}
custom : List (Option msg) -> String -> Html.Html msg
custom options =
    view << create (Custom :: options)


create : List (Option msg) -> String -> Checkbox msg
create options label =
    Checkbox
        { options = options
        , label = label
        }


view : Checkbox msg -> Html.Html msg
view (Checkbox chk) =
    let
        opts =
            List.foldl applyModifier defaultOptions chk.options

        validationAttrs =
            case opts.validation of
                Just validation ->
                    [ FormInternal.validationWrapperAttribute validation ]

                Nothing ->
                    []
    in
        if opts.custom then
            Html.div
                ([ Attributes.classList
                    [ ( "custom-controls-stacked", not opts.inline )
                    , ( "d-inline-block", opts.inline )
                    ]
                 ]
                    ++ validationAttrs
                )
                [ Html.label
                    ([ Attributes.class "custom-control custom-checkbox" ]
                        ++ validationAttrs
                    )
                    [ Html.input (toAttributes opts) []
                    , Html.span [ Attributes.class "custom-control-indicator" ] []
                    , Html.span
                        [ Attributes.class "custom-control-description" ]
                        [ Html.text chk.label ]
                    ]
                ]
        else
            Html.div
                ([ Attributes.classList
                    [ ( "form-check", True )
                    , ( "form-check-inline", opts.inline )
                    , ( "disabled", opts.disabled )
                    ]
                 ]
                    ++ validationAttrs
                )
                [ Html.label
                    [ Attributes.class "form-check-label" ]
                    [ Html.input (toAttributes opts) []
                    , Html.text <| " " ++ chk.label
                      -- ugly hack to provide left spacing
                    ]
                ]


{-| Shorthand for assigning an onCheck handler for a checkbox.
-}
onCheck : (Bool -> msg) -> Option msg
onCheck toMsg =
    OnChecked toMsg


{-| Option to toggle the checkbox checked property on off.
-}
checked : Bool -> Option msg
checked isCheck =
    Value <|
        if isCheck then
            On
        else
            Off


{-| Option to set the indeterminate property of a checkbox

**Note**: A checkbox can't be both indeterminate and checked, so if you set both
the last one provided in the list of options to the checkbox function "wins".
-}
indeterminate : Option msg
indeterminate =
    Value Indeterminate


{-| Option to disable the checkbox
-}
disabled : Bool -> Option msg
disabled disabled =
    Disabled disabled


{-| Use this option to display checkboxes inline.
-}
inline : Option msg
inline =
    Inline


{-| Option to color a checkbox with success.
-}
success : Option msg
success =
    Validation FormInternal.Success


{-| Option to color a checkbox with warning.
-}
warning : Option msg
warning =
    Validation FormInternal.Warning


{-| Option to color a checkbox with danger.
-}
danger : Option msg
danger =
    Validation FormInternal.Danger


{-| Use this function to handle any Html.Attribute option you wish for your select
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs =
    Attrs attrs


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Value val ->
            { options | state = val }

        Inline ->
            { options | inline = True }

        OnChecked toMsg ->
            { options | onChecked = Just toMsg }

        Custom ->
            { options | custom = True }

        Disabled val ->
            { options | disabled = val }

        Validation validation ->
            { options | validation = Just validation }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }


toAttributes : Options msg -> List (Html.Attribute msg)
toAttributes options =
    [ Attributes.class <|
        if options.custom then
            "custom-control-input"
        else
            "form-check-input"
    , Attributes.type_ "checkbox"
    , Attributes.disabled options.disabled
    , stateAttribute options.state
    ]
        ++ ([ Maybe.map Events.onCheck options.onChecked ]
                |> List.filterMap identity
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { state = Off
    , inline = False
    , custom = False
    , disabled = False
    , onChecked = Nothing
    , validation = Nothing
    , attributes = []
    }


stateAttribute : CheckValue -> Html.Attribute msg
stateAttribute state =
    case state of
        On ->
            Attributes.checked True

        Off ->
            Attributes.checked False

        Indeterminate ->
            Attributes.attribute "indeterminate" "true"
