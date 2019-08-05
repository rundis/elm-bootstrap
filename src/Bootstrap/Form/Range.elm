module Bootstrap.Form.Range exposing
    ( range, Range
    , id, min, max, step, value, disabled, onInput, attrs, Option
    )

{-| This module allows you to create Bootstrap styled range inputs.


# Creating

@docs range, Range


# Options

@docs id, min, max, step, value, disabled, onInput, disabled, attrs, Option

-}

import Bootstrap.Form.FormInternal as FormInternal
import Html
import Html.Attributes as Attributes
import Html.Events as Events


{-| Opaque composable type representing a Range.
-}
type Range msg
    = Range (List (Option msg))


{-| Opaque type representing valid customization options for a radio
-}
type Option msg
    = Id String
    | Min String
    | Max String
    | Value String
    | Step String
    | OnInput (Maybe (String -> msg))
    | Disabled Bool
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { id : Maybe String
    , min : Maybe String
    , max : Maybe String
    , value : Maybe String
    , step : Maybe String
    , disabled : Bool
    , onInput : Maybe (String -> msg)
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
    Range options


view : Range msg -> Html.Html msg
view (Range options) =
    let
        opts =
            List.foldl applyModifier defaultOptions options
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


{-| Option to set the value for the range.
-}
value : String -> Option msg
value val =
    Value val


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


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Id val ->
            { options | id = Just val }

        Min val ->
            { options | min = Just val }

        Max val ->
            { options | max = Just val }

        Value val ->
            { options | value = Just val }

        Step val ->
            { options | step = Just val }

        OnInput toMsg ->
            { options | onInput = toMsg }

        Disabled val ->
            { options | disabled = val }

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
            , Maybe.map Attributes.value options.value
            ]
                |> List.filterMap identity
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { id = Nothing
    , min = Nothing
    , max = Nothing
    , value = Nothing
    , step = Nothing
    , disabled = False
    , onInput = Nothing
    , attributes = []
    }
