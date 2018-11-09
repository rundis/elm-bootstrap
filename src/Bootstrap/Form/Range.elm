module Bootstrap.Form.Range exposing
    ( range, Range
    , id, min, max, step, disabled, onInput, attrs, Option
    , success, danger
    )

{-| This module allows you to create Bootstrap styled range inputs.


# Creating

@docs range, Range


# Options

@docs id, min, max, step, disabled, onInput, disabled, attrs, Option


# Validation

@docs success, danger

-}

import Bootstrap.Form.FormInternal as FormInternal
import Html
import Html.Attributes as Attributes
import Html.Events as Events


{-| Opaque composable type representing a Radio.
-}
type Range msg
    = Range
        { options : List (Option msg)
        }


{-| Opaque type representing valid customization options for a radio
-}
type Option msg
    = Id String
    | Min String
    | Max String
    | Step String
    | OnInput (Maybe (String -> msg))
    | Disabled Bool
    | Validation FormInternal.Validation
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { id : Maybe String
    , min : Maybe String
    , max : Maybe String
    , step : Maybe String
    , disabled : Bool
    , onInput : Maybe (String -> msg)
    , validation : Maybe FormInternal.Validation
    , attributes : List (Html.Attribute msg)
    }


{-| Create a range input.

    Range.range
        [ Range.id "myRange"
        , Range.min "-10"
        , Range.max "10"
        , Radio.onInput MyRangeMsg
        ]

-}
range : List (Option msg) -> Html.Html msg
range options =
    create options |> view


create : List (Option msg) -> Range msg
create options =
    Range
        { options = options
        }


addOption : Option msg -> Range msg -> Range msg
addOption opt (Range ({ options } as range_)) =
    Range { range_ | options = opt :: options }


view : Range msg -> Html.Html msg
view (Range range_) =
    let
        opts =
            List.foldl applyModifier defaultOptions range_.options
    in
    Html.input (toAttributes opts) []


{-| Shorthand for assigning an onInput handler for a range.
-}
onInput : Maybe (String -> msg) -> Option msg
onInput toMsg =
    OnInput toMsg


{-| Option to set the min value for the range.
-}
min : String -> Option msg
min val =
    Min val


{-| Option to set the max value for the range.
-}
max : String -> Option msg
max val =
    Max val


{-| Option to set the step value for the range.
-}
step : String -> Option msg
step val =
    Step val


{-| Option to disable the range
-}
disabled : Bool -> Option msg
disabled disabled_ =
    Disabled disabled_


{-| Use this function to handle any Html.Attribute option you wish for your range
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    Attrs attrs_


{-| Set the id for the range.
-}
id : String -> Option msg
id theId =
    Id theId


{-| Option to color a range with success.
-}
success : Option msg
success =
    Validation FormInternal.Success


{-| Option to color a range with danger.
-}
danger : Option msg
danger =
    Validation FormInternal.Danger


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Id val ->
            { options | id = Just val }

        Min val ->
            { options | min = Just val }

        Max val ->
            { options | max = Just val }

        Step val ->
            { options | step = Just val }

        OnInput toMsg ->
            { options | onInput = toMsg }

        Disabled val ->
            { options | disabled = val }

        Validation validation ->
            { options | validation = Just validation }

        Attrs attrs_ ->
            { options | attributes = options.attributes ++ attrs_ }


toAttributes : Options msg -> List (Html.Attribute msg)
toAttributes options =
    [ Attributes.class "form-control-range"
    , Attributes.type_ "range"
    , Attributes.disabled options.disabled
    ]
        ++ ([ Maybe.map Events.onInput options.onInput
            , Maybe.map Attributes.id options.id
            , Maybe.map Attributes.min options.min
            , Maybe.map Attributes.max options.max
            , Maybe.map Attributes.step options.step
            ]
                |> List.filterMap identity
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { id = Nothing
    , min = Nothing
    , max = Nothing
    , step = Nothing
    , disabled = False
    , onInput = Nothing
    , validation = Nothing
    , attributes = []
    }
