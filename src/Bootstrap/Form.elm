module Bootstrap.Form
    exposing
        ( form
        , inlineForm
        , group
        , groupSimple
        , groupRow
        , groupRowSimple
        , validationResult
        , textLabelControl
        , labelControl
        , labelSmall
        , labelMedium
        , labelLarge
        , textControl
        , passwordControl
        , datetimeLocalControl
        , dateControl
        , monthControl
        , timeControl
        , weekControl
        , numberControl
        , emailControl
        , urlControl
        , searchControl
        , telControl
        , colorControl
        , inputSmall
        , inputMedium
        , inputLarge
        , selectControl
        , selectItem
        , checkbox
        , checkboxRow
        , radioGroup
        , radioGroupRow
        , radioControl
        , checkDisabled
        , Validation(..)
        , FormCheckOption
        , Label
        , FormControl
        , InputOption
        , SelectItem
        )

import Html
import Html.Attributes exposing (class, classList, type_)
import Bootstrap.Grid as Grid
import Bootstrap.Internal.Grid as GridInternal


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


type Validation
    = Success
    | Warning
    | Danger


type ValidationResult
    = ValidationResult
        { validation : Validation
        , feedback : String
        }


type Label msg
    = Label
        { options : List LabelOption
        , attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


type LabelOption
    = FormLabel
    | ColumnLabel
    | LabelSize GridInternal.ScreenSize
    | LabelWidth Grid.ColumnWidth


type FormControl msg
    = InputControl (Input msg)
    | SelectControl (Select msg)


type Input msg
    = Input
        { id : Maybe String
        , tipe : InputType
        , options : List InputOption
        , attributes : List (Html.Attribute msg)
        }


type InputOption
    = InputSize GridInternal.ScreenSize


type Select msg
    = Select
        { id : Maybe String
        , items : List (SelectItem msg)
        , options : List InputOption
        , attributes : List (Html.Attribute msg)
        }


type SelectItem msg
    = SelectItem (Html.Html msg)


type Radio msg
    = Radio
        { label : Label msg
        , options : List FormCheckOption
        , attributes : List (Html.Attribute msg)
        }


type FormCheckOption
    = Disabled


inlineForm : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
inlineForm attributes children =
    form
        (attributes ++ [ class "form-inline" ])
        children


form : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
form attributes children =
    Html.form attributes children


groupSimple :
    { label : Label msg
    , control : FormControl msg
    }
    -> Html.Html msg
groupSimple { label, control } =
    group
        { label = label
        , control = control
        , validationResult = Nothing
        }


group :
    { label : Label msg
    , control : FormControl msg
    , validationResult : Maybe ValidationResult
    }
    -> Html.Html msg
group { label, control, validationResult } =
    let
        updLabel =
            maybeAddLabelFor (getFormControlId control) label
                |> addLabelOptions [ FormLabel ]
    in
        Html.div
            [ groupOptions validationResult False ]
            ([ renderLabel updLabel
             , renderControl control
             ]
                ++ maybeValidation validationResult
            )


disableWhen : Bool -> Html.Html msg -> Html.Html msg
disableWhen isDisabled element =
    if isDisabled then
        Html.fieldset
            [ Html.Attributes.disabled isDisabled ]
            [ element ]
    else
        element


groupRowSimple :
    { label : Label msg
    , labelWidth : Grid.ColumnWidth
    , control : FormControl msg
    , controlWidth : Grid.ColumnWidth
    }
    -> Html.Html msg
groupRowSimple { label, labelWidth, control, controlWidth } =
    groupRow
        { label = label
        , labelWidth = labelWidth
        , control = control
        , controlWidth = controlWidth
        , validationResult = Nothing
        }


groupRow :
    { label : Label msg
    , labelWidth : Grid.ColumnWidth
    , control : FormControl msg
    , controlWidth : Grid.ColumnWidth
    , validationResult : Maybe ValidationResult
    }
    -> Html.Html msg
groupRow { label, labelWidth, control, controlWidth, validationResult } =
    let
        updLabel =
            maybeAddLabelFor (getFormControlId control) label
                |> addLabelOptions [ FormLabel, ColumnLabel, LabelWidth labelWidth ]
    in
        Html.div
            [ groupOptions validationResult True ]
            [ renderLabel updLabel
            , Html.div
                [ class <| GridInternal.colWidthOption controlWidth ]
                ([ renderControl control ]
                    ++ maybeValidation validationResult
                )
            ]


groupOptions : Maybe ValidationResult -> Bool -> Html.Attribute msg
groupOptions validationResult isRow =
    classList <|
        [ ( "form-group", True )
        , ( "row", isRow )
        ]
            ++ (case validationResult of
                    Nothing ->
                        []

                    Just (ValidationResult res) ->
                        [ ( validationOption res.validation, True ) ]
               )


maybeValidation : Maybe ValidationResult -> List (Html.Html msg)
maybeValidation validationResult =
    case validationResult of
        Nothing ->
            []

        Just (ValidationResult res) ->
            [ Html.div
                [ class "form-control-feedback" ]
                [ Html.text res.feedback ]
            ]


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
                | attributes =
                    label.attributes ++ [ Html.Attributes.for id ]
            }
    )
        |> Label


addLabelOptions : List LabelOption -> Label msg -> Label msg
addLabelOptions options (Label label) =
    { label | options = label.options ++ options }
        |> Label


getFormControlId : FormControl msg -> Maybe String
getFormControlId control =
    case control of
        InputControl (Input input) ->
            input.id

        SelectControl (Select select) ->
            select.id


textLabelControl : String -> Label msg
textLabelControl text =
    Label
        { options = []
        , attributes = []
        , children = [ Html.text text ]
        }


labelControl :
    { text : String
    , options : List LabelOption
    , attributes : List (Html.Attribute msg)
    }
    -> Label msg
labelControl { text, options, attributes } =
    Label
        { options = options
        , attributes = attributes
        , children = [ Html.text text ]
        }


labelSmall : LabelOption
labelSmall =
    LabelSize GridInternal.Small


labelMedium : LabelOption
labelMedium =
    LabelSize GridInternal.Medium


labelLarge : LabelOption
labelLarge =
    LabelSize GridInternal.Large


textControl :
    { id : Maybe String
    , options : List InputOption
    , attributes : List (Html.Attribute msg)
    }
    -> FormControl msg
textControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Text
        , options = options
        , attributes = attributes
        }


passwordControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
passwordControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Password
        , options = options
        , attributes = attributes
        }

datetimeLocalControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
datetimeLocalControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = DatetimeLocal
        , options = options
        , attributes = attributes
        }

dateControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
dateControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Date
        , options = options
        , attributes = attributes
        }

monthControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
monthControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Month
        , options = options
        , attributes = attributes
        }

timeControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
timeControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Time
        , options = options
        , attributes = attributes
        }

weekControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
weekControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Week
        , options = options
        , attributes = attributes
        }

numberControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
numberControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Number
        , options = options
        , attributes = attributes
        }

emailControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
emailControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Email
        , options = options
        , attributes = attributes
        }

urlControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
urlControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Url
        , options = options
        , attributes = attributes
        }

searchControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
searchControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Search
        , options = options
        , attributes = attributes
        }

telControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
telControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Tel
        , options = options
        , attributes = attributes
        }

colorControl
    : { a
          | attributes : List (Html.Attribute msg)
          , id : Maybe String
          , options : List InputOption
    }
    -> FormControl msg
colorControl { id, options, attributes } =
    inputControl
        { id = id
        , tipe = Color
        , options = options
        , attributes = attributes
        }



inputSmall : InputOption
inputSmall =
    InputSize GridInternal.Small


inputMedium : InputOption
inputMedium =
    InputSize GridInternal.Medium


inputLarge : InputOption
inputLarge =
    InputSize GridInternal.Large


inputControl :
    { id : Maybe String
    , tipe : InputType
    , options : List InputOption
    , attributes : List (Html.Attribute msg)
    }
    -> FormControl msg
inputControl { id, tipe, options, attributes } =
    InputControl <|
        Input
            { tipe = tipe
            , id = id
            , options = options
            , attributes = attributes
            }


selectControl :
    { id : Maybe String
    , items : List (SelectItem msg)
    , options : List InputOption
    , attributes : List (Html.Attribute msg)
    }
    -> FormControl msg
selectControl { id, items, options, attributes } =
    SelectControl <|
        Select
            { id = id
            , items = items
            , options = options
            , attributes = attributes
            }


selectItem : List (Html.Attribute msg) -> List (Html.Html msg) -> SelectItem msg
selectItem attributes children =
    SelectItem <| Html.option attributes children


checkbox :
    { label : Label msg
    , attributes : List (Html.Attribute msg)
    , options : List FormCheckOption
    }
    -> Html.Html msg
checkbox { label, attributes, options } =
    Html.div
        [ classList
            [ ( "form-check", True )
            , ( "disabled", isDisabled options )
            ]
        ]
        [ Html.label
            [ class "form-check-label" ]
            [ Html.input
                ([ class "form-check-input"
                 , type_ "checkbox"
                 , Html.Attributes.disabled <| isDisabled options
                 ]
                    ++ attributes
                )
                []
            , renderLabel label
            ]
        ]


checkboxRow :
    { label : Label msg
    , options : List FormCheckOption
    , offset : Grid.ColumnWidth
    , controlWidth : Grid.ColumnWidth
    , attributes : List (Html.Attribute msg)
    }
    -> Html.Html msg
checkboxRow { label, options, attributes, offset, controlWidth } =
    Html.div
        [ class "form-group row" ]
        [ Html.div
            [ class <| GridInternal.offsetOption offset ++ " " ++ GridInternal.colWidthOption controlWidth ]
            [ checkbox
                { label = label
                , attributes = attributes
                , options = options
                }
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
    , labelWidth : Grid.ColumnWidth
    , name : String
    , radios : List (Radio msg)
    , controlWidth : Grid.ColumnWidth
    }
    -> Html.Html msg
radioGroupRow { label, name, radios, labelWidth, controlWidth } =
    let
        updLabel =
            addLabelOptions [ FormLabel, ColumnLabel, LabelWidth labelWidth ] label
    in
        Html.div
            [ class "form-group row" ]
            [ renderLabel updLabel
            , Html.div
                [ class <| GridInternal.colWidthOption controlWidth ]
                (List.map
                    (\r ->
                        addRadioAttribute (Html.Attributes.name name) r
                            |> renderRadio
                    )
                    radios
                )
            ]


radioControl :
    { label : Label msg
    , options : List FormCheckOption
    , attributes : List (Html.Attribute msg)
    }
    -> Radio msg
radioControl { label, options, attributes } =
    Radio
        { label = label
        , options = options
        , attributes = attributes
        }


checkDisabled : FormCheckOption
checkDisabled =
    Disabled


addRadioAttribute : Html.Attribute msg -> Radio msg -> Radio msg
addRadioAttribute attribute (Radio rec) =
    Radio <|
        { rec | attributes = rec.attributes ++ [ attribute ] }


renderRadio : Radio msg -> Html.Html msg
renderRadio (Radio { label, options, attributes }) =
    Html.div
        [ classList
            [ ( "form-check", True )
            , ( "disabled", isDisabled options )
            ]
        ]
        [ Html.label
            [ class "form-check-label" ]
            [ Html.input
                ([ type_ "radio"
                 , class "form-check-input"
                 , Html.Attributes.disabled <| isDisabled options
                 ]
                    ++ attributes
                )
                []
            , renderLabel label
            ]
        ]


isDisabled : List FormCheckOption -> Bool
isDisabled options =
    List.any (\opt -> opt == Disabled) options


renderLabel : Label msg -> Html.Html msg
renderLabel (Label { options, attributes, children }) =
    Html.label
        (labelAttributes options ++ attributes)
        children


renderControl : FormControl msg -> Html.Html msg
renderControl control =
    case control of
        InputControl input ->
            renderInput input

        SelectControl select ->
            renderSelect select


renderInput : Input msg -> Html.Html msg
renderInput (Input { tipe, id, options, attributes }) =
    Html.input
        (inputAttributes options
            ++ [ type_ <| inputTypeToString tipe ]
            ++ maybeId id
            ++ attributes
        )
        []


renderSelect : Select msg -> Html.Html msg
renderSelect (Select { id, items, options, attributes }) =
    Html.select
        (inputAttributes options
            ++ maybeId id
            ++ attributes
        )
        (List.map (\(SelectItem item) -> item) items)


maybeId : Maybe String -> List (Html.Attribute msg)
maybeId id =
    case id of
        Just x ->
            [ Html.Attributes.id x ]

        Nothing ->
            []


inputAttributes : List InputOption -> List (Html.Attribute msg)
inputAttributes options =
    class "form-control" :: List.map inputClass options


inputClass : InputOption -> Html.Attribute msg
inputClass option =
    class <|
        case option of
            InputSize size ->
                inputSizeOption size


labelAttributes : List LabelOption -> List (Html.Attribute msg)
labelAttributes options =
    List.map labelClass options


labelClass : LabelOption -> Html.Attribute msg
labelClass option =
    class <|
        case option of
            FormLabel ->
                "form-control-label"

            LabelSize size ->
                labelSizeOption size

            LabelWidth columnWidth ->
                GridInternal.colWidthOption columnWidth

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


inputSizeOption : GridInternal.ScreenSize -> String
inputSizeOption size =
    "form-control-" ++ GridInternal.screenSizeOption size


labelSizeOption : GridInternal.ScreenSize -> String
labelSizeOption size =
    "col-form-label-" ++ GridInternal.screenSizeOption size


validationOption : Validation -> String
validationOption validation =
    case validation of
        Success ->
            "has-success"

        Warning ->
            "has-warning"

        Danger ->
            "has-danger"
