module Bootstrap.Form
    exposing
        ( form
        , formGroup
        , formGroupSimple
        , formGroupRow
        , formGroupRowSimple
        , columnWidth
        , validationResult
        , textLabel
        , label
        , labelSize
        , inputText
        , inputSize
        , select
        , option
        , checkbox
        , checkboxRow
        , radioGroup
        , radioGroupRow
        , radio
        , Validation(..)
        , Size(..)
        , ColumnCount(..)
        )

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


type ColumnWidth
    = ColumnWidth
        { size : Size
        , columns : ColumnCount
        }


type ColumnCount
    = One
    | Two
    | Three
    | Four
    | Five
    | Six
    | Seven
    | Eight
    | Nine
    | Ten
    | Eleven
    | Twelve


type ValidationResult
    = ValidationResult
        { validation : Validation
        , feedback : String
        }


type FormGroupClass
    = FormGroupValidation Validation
    | Row


type Label msg
    = Label
        { classes : List LabelClass
        , customAttributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


type LabelClass
    = FormLabel
    | ColumnLabel
    | LabelSize Size
    | LabelWidth ColumnWidth


type FormControl msg
    = InputControl (Input msg)
    | SelectControl (Select msg)


type Input msg
    = Input
        { id : Maybe String
        , tipe : InputType
        , classes : List InputClass
        , customAttributes : List (Html.Attribute msg)
        }


type InputClass
    = InputSize Size


type Select msg
    = Select
        { id : Maybe String
        , options : List (Option msg)
        , classes : List InputClass
        , customAttributes : List (Html.Attribute msg)
        }


type Option msg
    = Option (Html.Html msg)


type Radio msg
    = Radio
        { label : Label msg
        , classes : List InputClass
        , customAttributes : List (Html.Attribute msg)
        }


form =
    ""


formGroupSimple :
    { label : Label msg
    , control : FormControl msg
    }
    -> Html.Html msg
formGroupSimple {label, control} =
    formGroup
        { label = label
        , control = control
        , validationResult = Nothing
        , disabled = False
        }

formGroup :
    { label : Label msg
    , control : FormControl msg
    , validationResult : Maybe ValidationResult
    , disabled : Bool
    }
    -> Html.Html msg
formGroup { label, control, validationResult, disabled } =
    let
        groupClasses =
            "form-group "
                ++ (case validationResult of
                        Nothing ->
                            ""

                        Just (ValidationResult res) ->
                            validationClass res.validation
                   )

        updLabel =
            maybeAddLabelFor (getFormControlId control) label
                |> addLabelClasses [ FormLabel ]
    in
        disableWhen disabled <|
            Html.div
                [ class groupClasses ]
                ([ renderLabel updLabel
                 , renderControl control
                 ]
                    ++ (case validationResult of
                            Nothing ->
                                []

                            Just (ValidationResult res) ->
                                [ Html.div
                                    [ class "form-control-feedback" ]
                                    [ Html.text res.feedback ]
                                ]
                       )
                )

disableWhen : Bool -> Html.Html msg -> Html.Html msg
disableWhen isDisabled element =
    if isDisabled then
        Html.fieldset
            [Html.Attributes.disabled isDisabled]
            [element]
    else
        element



formGroupRowSimple :
    { label : Label msg
    , labelWidth : ColumnWidth
    , control : FormControl msg
    , controlWidth : ColumnWidth
    }
    -> Html.Html msg
formGroupRowSimple { label, labelWidth, control, controlWidth} =
    formGroupRow
        {label = label
        , labelWidth = labelWidth
        , control = control
        , controlWidth = controlWidth
        , validationResult = Nothing
        , disabled = False
        }

formGroupRow :
    { label : Label msg
    , labelWidth : ColumnWidth
    , control : FormControl msg
    , controlWidth : ColumnWidth
    , validationResult : Maybe ValidationResult
    , disabled : Bool
    }
    -> Html.Html msg
formGroupRow { label, labelWidth, control, controlWidth, validationResult, disabled } =
    let
        groupClasses =
            "form-group row "
                ++ (case validationResult of
                        Nothing ->
                            ""

                        Just (ValidationResult res) ->
                            validationClass res.validation
                   )

        updLabel =
            maybeAddLabelFor (getFormControlId control) label
                |> addLabelClasses [ FormLabel, ColumnLabel, LabelWidth labelWidth ]
    in
        disableWhen disabled <|
            Html.div
                [ class groupClasses ]
                [ renderLabel updLabel
                , Html.div
                    [ class <| columnWidthClass controlWidth ]
                    ([ renderControl control ]
                        ++ (case validationResult of
                                Nothing ->
                                    []

                                Just (ValidationResult res) ->
                                    [ Html.div
                                        [ class "form-control-feedback" ]
                                        [ Html.text res.feedback ]
                                    ]
                           )
                    )
                ]


columnWidth : Size -> ColumnCount -> ColumnWidth
columnWidth size columns =
    ColumnWidth
        { size = size
        , columns = columns
        }


validationResult : Validation -> String -> ValidationResult
validationResult validation feedback =
    ValidationResult
        { validation = validation
        , feedback = feedback
        }


maybeAddLabelFor : Maybe String -> Label msg -> Label msg
maybeAddLabelFor maybeId (Label label) =
    (case maybeId of
        Nothing ->
            label

        Just id ->
            { label
                | customAttributes =
                    label.customAttributes ++ [ Html.Attributes.for id ]
            }
    )
        |> Label


addLabelClasses : List LabelClass -> Label msg -> Label msg
addLabelClasses classes (Label label) =
    { label | classes = label.classes ++ classes }
        |> Label


getFormControlId : FormControl msg -> Maybe String
getFormControlId control =
    case control of
        InputControl (Input input) ->
            input.id

        SelectControl (Select select) ->
            select.id


textLabel : String -> Label msg
textLabel text =
    Label
        { classes = []
        , customAttributes = []
        , children = [ Html.text text ]
        }


label :
    { text : String
    , classes : List LabelClass
    , customAttributes : List (Html.Attribute msg)
    }
    -> Label msg
label { text, classes, customAttributes } =
    Label
        { classes = classes
        , customAttributes = customAttributes
        , children = [ Html.text text ]
        }


labelSize : Size -> LabelClass
labelSize size =
    LabelSize size


inputText :
    { id : Maybe String
    , classes : List InputClass
    , customAttributes : List (Html.Attribute msg)
    }
    -> FormControl msg
inputText { id, classes, customAttributes } =
    input
        { id = id
        , tipe = Text
        , classes = classes
        , customAttributes = customAttributes
        }


inputSize : Size -> InputClass
inputSize size =
    InputSize size


input :
    { id : Maybe String
    , tipe : InputType
    , classes : List InputClass
    , customAttributes : List (Html.Attribute msg)
    }
    -> FormControl msg
input { id, tipe, classes, customAttributes } =
    InputControl <|
        Input
            { tipe = tipe
            , id = id
            , classes = classes
            , customAttributes = customAttributes
            }


select :
    { id : Maybe String
    , options : List (Option msg)
    , classes : List InputClass
    , customAttributes : List (Html.Attribute msg)
    }
    -> FormControl msg
select { id, options, classes, customAttributes } =
    SelectControl <|
        Select
            { id = id
            , options = options
            , classes = classes
            , customAttributes = customAttributes
            }


option : List (Html.Attribute msg) -> List (Html.Html msg) -> Option msg
option attributes children =
    Option <| Html.option attributes children


checkbox :
    { label : Label msg
    , customAttributes : List (Html.Attribute msg)
    }
    -> Html.Html msg
checkbox { label, customAttributes } =
    Html.div
        [ class "form-check" ]
        [ Html.label
            [ class "form-check-label" ]
            [ Html.input
                ([ class "form-check-input"
                 , type_ "checkbox"
                 ]
                    ++ customAttributes
                )
                []
            , renderLabel label
            ]
        ]


checkboxRow :
    { label : Label msg
    , offset : ColumnWidth
    , controlWidth : ColumnWidth
    , customAttributes : List (Html.Attribute msg)
    }
    -> Html.Html msg
checkboxRow { label, customAttributes, offset, controlWidth } =
    Html.div
        [ class "form-group row" ]
        [ Html.div
            [ class <| offsetClass offset ++ " " ++ columnWidthClass controlWidth ]
            [ Html.div
                [ class "form-check" ]
                [ Html.label
                    [ class "form-check-label" ]
                    [ Html.input
                        ([ class "form-check-input"
                         , type_ "checkbox"
                         ]
                            ++ customAttributes
                        )
                        []
                    , renderLabel label
                    ]
                ]
            ]
        ]


radioGroup :
    { label : Label msg
    , name : String
    , radios : List (Radio msg)
    }
    -> Html.Html msg
radioGroup { label, name, radios } =
    Html.fieldset
        [ class "form-group" ]
        ([ Html.legend
            []
            [ renderLabel label ]
         ]
            ++ List.map
                (\r ->
                    addRadioAttribute (Html.Attributes.name name) r
                        |> renderRadio
                )
                radios
        )


radioGroupRow :
    { label : Label msg
    , labelWidth : ColumnWidth
    , name : String
    , radios : List (Radio msg)
    , controlWidth : ColumnWidth
    }
    -> Html.Html msg
radioGroupRow { label, name, radios, labelWidth, controlWidth } =
    Html.fieldset
        [ class "form-group row" ]
        [ Html.legend
            [ class <| "col-form-legend " ++ columnWidthClass labelWidth ]
            [ renderLabel label ]
        , Html.div
            [ class <| columnWidthClass controlWidth ]
            (List.map
                (\r ->
                    addRadioAttribute (Html.Attributes.name name) r
                        |> renderRadio
                )
                radios
            )
        ]


radio :
    { label : Label msg
    , classes : List InputClass
    , customAttributes : List (Html.Attribute msg)
    }
    -> Radio msg
radio { label, classes, customAttributes } =
    Radio
        { label = label
        , classes = classes
        , customAttributes = customAttributes
        }


addRadioAttribute : Html.Attribute msg -> Radio msg -> Radio msg
addRadioAttribute attribute (Radio rec) =
    Radio <|
        { rec | customAttributes = rec.customAttributes ++ [ attribute ] }


renderRadio : Radio msg -> Html.Html msg
renderRadio (Radio { label, classes, customAttributes }) =
    Html.div
        [ class "form-check" ]
        [ Html.label
            [ class "form-check-label" ]
            [ Html.input
                ([ type_ "radio"
                 , class "form-check-input"
                 ]
                    ++ customAttributes
                )
                []
            , renderLabel label
            ]
        ]


renderLabel : Label msg -> Html.Html msg
renderLabel (Label { classes, customAttributes, children }) =
    Html.label
        ([ class <| labelClasses classes ]
            ++ customAttributes
        )
        children


renderControl : FormControl msg -> Html.Html msg
renderControl control =
    case control of
        InputControl input ->
            renderInput input

        SelectControl select ->
            renderSelect select


renderInput : Input msg -> Html.Html msg
renderInput (Input { tipe, id, classes, customAttributes }) =
    Html.input
        ([ type_ <| inputTypeToString tipe
         , class <| inputClasses "form-control" classes
         ]
            ++ (case id of
                    Just x ->
                        [ Html.Attributes.id x ]

                    Nothing ->
                        []
               )
            ++ customAttributes
        )
        []


renderSelect : Select msg -> Html.Html msg
renderSelect (Select { id, options, classes, customAttributes }) =
    Html.select
        ([ class <| inputClasses "form-control" classes ]
            ++ (case id of
                    Just x ->
                        [ Html.Attributes.id x ]

                    Nothing ->
                        []
               )
            ++ customAttributes
        )
        (List.map (\(Option opt) -> opt) options)


formGroupClasses : List FormGroupClass -> String
formGroupClasses classes =
    List.foldl
        (\class classString ->
            String.join " " [ classString, formGroupClass class ]
        )
        "form-group"
        classes


formGroupClass : FormGroupClass -> String
formGroupClass class =
    case class of
        FormGroupValidation v ->
            validationClass v

        Row ->
            "row"


inputClasses : String -> List InputClass -> String
inputClasses prefix classes =
    List.foldl
        (\class classString ->
            String.join " " [ classString, inputClass class ]
        )
        prefix
        classes


inputClass : InputClass -> String
inputClass class =
    case class of
        InputSize size ->
            inputSizeClass size


labelClasses : List LabelClass -> String
labelClasses classes =
    List.foldl
        (\class classString ->
            String.join " " [ classString, labelClass class ]
        )
        ""
        classes


labelClass : LabelClass -> String
labelClass class =
    case class of
        FormLabel ->
            "form-control-label"

        LabelSize size ->
            labelSizeClass size

        LabelWidth columnWidth ->
            columnWidthClass columnWidth

        ColumnLabel ->
            "col-form-label"



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


inputSizeClass : Size -> String
inputSizeClass size =
    "form-control-" ++ sizeClass size


labelSizeClass : Size -> String
labelSizeClass size =
    "col-form-label-" ++ sizeClass size


columnWidthClass : ColumnWidth -> String
columnWidthClass (ColumnWidth { size, columns }) =
    "col-" ++ sizeClass size ++ "-" ++ columnCountClass columns

offsetClass : ColumnWidth -> String
offsetClass (ColumnWidth { size, columns }) =
    "offset-" ++ sizeClass size ++ "-" ++ columnCountClass columns


sizeClass : Size -> String
sizeClass size =
    case size of
        ExtraSmall ->
            "xs"

        Small ->
            "sm"

        Medium ->
            "md"

        Large ->
            "lg"


validationClass : Validation -> String
validationClass validation =
    case validation of
        Success ->
            "has-success"

        Warning ->
            "has-warning"

        Danger ->
            "has-danger"


columnCountClass : ColumnCount -> String
columnCountClass count =
    case count of
        One ->
            "1"

        Two ->
            "2"

        Three ->
            "3"

        Four ->
            "4"

        Five ->
            "5"

        Six ->
            "6"

        Seven ->
            "7"

        Eight ->
            "8"

        Nine ->
            "9"

        Ten ->
            "10"

        Eleven ->
            "11"

        Twelve ->
            "12"
