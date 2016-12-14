module Bootstrap.Form exposing (form)

import Html
import Html.Attributes exposing (class, type_)


type InputType
    = Text
    | Password
    | DatetimeLocal
    | Date
    | Month
    | Time
    | Week
    | Number
    | Email
    | Url
    | Search
    | Tel
    | Color


type Size
    = ExtraSmall
    | Small
    | Medium
    | Large

type Validation
    = Success
    | Warning
    | Danger


type FormGroupClass
    = FormGroupValidation Validation
    | Row


form =
    ""


type Option msg
    = Option (Html.Html msg)


type FormControl msg
    = Select (Html.Html msg)
    | Input (Html.Html msg)







formGroupClasses : List FormGroupClass -> String
formGroupClasses classes =
    List.foldl
        (\class classString ->
            String.join " " [ classString, formGroupClass  class])
        "form-group"
        classes


formGroupClass : FormGroupClass -> String
formGroupClass class =
    case class of
        FormGroupValidation v ->
            validationClass v

        Row ->
            "row"


select :
    Maybe Size
    -> List (Html.Attribute msg)
    -> List (Option msg)
    -> FormControl msg
select size attributes options =
    Select <| selectStandalone size attributes options


selectStandalone :
    Maybe Size
    -> List (Html.Attribute msg)
    -> List (Option msg)
    -> Html.Html msg
selectStandalone size attributes options =
    Html.select
        ([ class <| inputClass size ] ++ attributes)
        (List.map (\(Option opt) -> opt) options)


option : List (Html.Attribute msg) -> List (Html.Html msg) -> Option msg
option attributes children =
    Option <| Html.option attributes children


input : Maybe Size -> InputType -> List (Html.Attribute msg) -> FormControl msg
input size inputType attributes =
    Input <| inputStandalone size inputType attributes


inputStandalone : Maybe Size -> InputType -> List (Html.Attribute msg) -> Html.Html msg
inputStandalone size inputType attributes =
    Html.input
        ([ type_ <| inputTypeToString inputType
         , class <| inputClass size
         ]
            ++ attributes
        )
        []


inputClass : Maybe Size -> String
inputClass size =
    "form-control "
        ++ (Maybe.map (\v -> sizeClass v) size
                |> Maybe.withDefault ""
           )


inputTypeToString : InputType -> String
inputTypeToString inputType =
    case inputType of
        Text ->
            "text"

        Password ->
            "password"

        DatetimeLocal ->
            "datetime-local"

        Date ->
            "date"

        Month ->
            "month"

        Time ->
            "time"

        Week ->
            "week"

        Number ->
            "number"

        Email ->
            "email"

        Url ->
            "url"

        Search ->
            "search"

        Tel ->
            "tel"

        Color ->
            "color"


sizeClass : Size -> String
sizeClass size =
    case size of
        ExtraSmall ->
            "form-control-xs"

        Small ->
            "form-control-sm"

        Medium ->
            "form-control-md"

        Large ->
            "form-control-lg"



validationClass : Validation -> String
validationClass validation =
    case validation of
        Success ->
            "has-success"
        Warning ->
            "has-warning"
        Danger ->
            "has-danger"
