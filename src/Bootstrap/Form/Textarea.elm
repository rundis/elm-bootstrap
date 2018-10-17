module Bootstrap.Form.Textarea exposing
    ( textarea
    , id, rows, value, disabled, onInput, attrs, Option
    , success, danger
    )

{-| This module allows you to create textarea elements.


# Creating

@docs textarea


# Options

@docs id, rows, value, disabled, onInput, attrs, Option


# Validation

@docs success, danger

-}

import Bootstrap.Form.FormInternal as FormInternal
import Html
import Html.Attributes as Attributes
import Html.Events as Events


{-| Opaque type representing a composable input
-}
type Textarea msg
    = Textarea { options : List (Option msg) }


{-| Opaque type representing legal textarea configuration options
-}
type Option msg
    = Id String
    | Rows Int
    | Disabled
    | Value String
    | OnInput (String -> msg)
    | Validation FormInternal.Validation
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { id : Maybe String
    , rows : Maybe Int
    , disabled : Bool
    , value : Maybe String
    , onInput : Maybe (String -> msg)
    , validation : Maybe FormInternal.Validation
    , attributes : List (Html.Attribute msg)
    }


{-| Create a textarea element.

    Textarea.textarea
        [ Textarea.id "myarea"
        , Textarea.rows 4
        , Textarea.onInput MyTextareaMsg
        ]

-}
textarea : List (Option msg) -> Html.Html msg
textarea =
    view << create


{-| Options/shorthand for setting the id of a textarea
-}
id : String -> Option msg
id id_ =
    Id id_


{-| Option/shorthand to set the rows attribute of a textarea
-}
rows : Int -> Option msg
rows rows_ =
    Rows rows_


{-| Use this function to handle any Html.Attribute option you wish for your textarea
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    Attrs attrs_


{-| Shorthand for setting the value attribute of a textarea
-}
value : String -> Option msg
value value_ =
    Value value_


{-| Shorthand for assigning an onInput handler for a textarea
-}
onInput : (String -> msg) -> Option msg
onInput toMsg =
    OnInput toMsg


{-| Shorthand for setting the disabled attribute of a textarea
-}
disabled : Option msg
disabled =
    Disabled


{-| Option to add a success marker icon for your textarea.
-}
success : Option msg
success =
    Validation FormInternal.Success


{-| Option to add a danger marker icon for your textarea.
-}
danger : Option msg
danger =
    Validation FormInternal.Danger


view : Textarea msg -> Html.Html msg
view (Textarea { options }) =
    Html.textarea
        (toAttributes options)
        []


create : List (Option msg) -> Textarea msg
create options =
    Textarea { options = options }


toAttributes : List (Option msg) -> List (Html.Attribute msg)
toAttributes modifiers =
    let
        options =
            List.foldl applyModifier defaultOptions modifiers
    in
    [ Attributes.class "form-control"
    , Attributes.disabled options.disabled
    ]
        ++ ([ Maybe.map Attributes.id options.id
            , Maybe.map Attributes.rows options.rows
            , Maybe.map Attributes.value options.value
            , Maybe.map Events.onInput options.onInput
            , Maybe.map validationAttribute options.validation
            ]
                |> List.filterMap identity
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { id = Nothing
    , rows = Nothing
    , disabled = False
    , value = Nothing
    , onInput = Nothing
    , validation = Nothing
    , attributes = []
    }


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Id id_ ->
            { options | id = Just id_ }

        Rows rows_ ->
            { options | rows = Just rows_ }

        Disabled ->
            { options | disabled = True }

        Value value_ ->
            { options | value = Just value_ }

        OnInput onInput_ ->
            { options | onInput = Just onInput_ }

        Validation validation ->
            { options | validation = Just validation }

        Attrs attrs_ ->
            { options | attributes = options.attributes ++ attrs_ }


validationAttribute : FormInternal.Validation -> Html.Attribute msg
validationAttribute validation =
    Attributes.class <| FormInternal.validationToString validation
