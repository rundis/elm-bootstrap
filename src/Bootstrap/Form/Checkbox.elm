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
        , id
        , success
        , danger
        , Option
        )

{-| This module allows you to create Bootstrap styled checkboxes.


# Creating
@docs checkbox, custom

# Options
@docs id, checked, inline, indeterminate, disabled, onCheck, attrs, success, danger, Option


-}

import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Bootstrap.Form.FormInternal as FormInternal


{-| Opaque composable type representing a Checkbox.
-}
type Checkbox msg
    = Checkbox
        { options : List (Option msg)
        , label : String
        }


{-| Opaque type representing valid customization options for a checkbox
-}
type Option msg
    = Id String
    | Value CheckValue
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
    { id : Maybe String
    , state : CheckValue
    , inline : Bool
    , custom : Bool
    , disabled : Bool
    , onChecked : Maybe (Bool -> msg)
    , validation : Maybe FormInternal.Validation
    , attributes : List (Html.Attribute msg)
    }


{-| Create a checkbox element

    Checkbox.checkbox
        [ Checkbox.id "myChk"
        , Checkbox.checked True
        , Checkbox.onCheck MyCheckMsg
        ]

-}
checkbox : List (Option msg) -> String -> Html.Html msg
checkbox options label =
    create options label |> view


{-| Create a composable Bootstrap custom styled checkbox

    Checkbox.custom
        [ Checkbox.id "myCustomChk"
        , Checkbox.checked True
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
    in
        Html.div
            [ Attributes.classList
                [ ( "form-check", not opts.custom )
                , ( "form-check-inline", not opts.custom && opts.inline )
                , ( "custom-control", opts.custom )
                , ( "custom-checkbox", opts.custom )
                , ( "custom-control-inline", opts.inline && opts.custom )
                ]
            ]
            [ Html.input (toAttributes opts) []
            , Html.label
                ([ Attributes.classList
                    [ ( "form-check-label", not opts.custom )
                    , ( "custom-control-label", opts.custom )
                    ]
                 ]
                    ++ case opts.id of
                        Just v ->
                            [ Attributes.for v ]

                        Nothing ->
                            []
                )
                [ Html.text chk.label ]
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



{-| Option to color a checkbox with danger.
-}
danger : Option msg
danger =
    Validation FormInternal.Danger


{-| Set the id for the checkbox. Will automatically set the for attribute for the label

NOTE: You have to use this for custom checkboxes.

-}
id : String -> Option msg
id theId =
    Id theId


{-| Use this function to handle any Html.Attribute option you wish for your select
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs =
    Attrs attrs


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Id val ->
            { options | id = Just val }

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
    [ Attributes.classList
        [ ( "form-check-input", not options.custom )
        , ( "custom-control-input", options.custom )
        ]
    , Attributes.type_ "checkbox"
    , Attributes.disabled options.disabled
    , stateAttribute options.state
    ]
        ++ ([ Maybe.map Events.onCheck options.onChecked
            , Maybe.map Attributes.id options.id
            ]
                |> List.filterMap identity
           )
        ++ (case options.validation of
                Just v ->
                    [ Attributes.class <| FormInternal.validationToString v ]

                Nothing ->
                    []
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { id = Nothing
    , state = Off
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
