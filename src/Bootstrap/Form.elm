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
        , labelSize
        , textControl
        , inputSize
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
    | LabelSize Grid.ScreenSize
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
    = InputSize Grid.ScreenSize


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
                [ class <| Grid.colWidthClassString controlWidth ]
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
                    [ (validationOption res.validation, True) ]
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


labelSize : Grid.ScreenSize -> LabelOption
labelSize size =
    LabelSize size


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


inputSize : Grid.ScreenSize -> InputOption
inputSize size =
    InputSize size


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
            [ class <| Grid.offsetClassString offset ++ " " ++ Grid.colWidthClassString controlWidth ]
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
            [ class "form-group row"]
            [ renderLabel updLabel
            , Html.div
                [ class <| Grid.colWidthClassString controlWidth ]
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
        ([ class <| labelOptions options ]
            ++ attributes
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
renderInput (Input { tipe, id, options, attributes }) =
    Html.input
        ([ type_ <| inputTypeToString tipe
         , class <| inputOptions "form-control" options
         ]
            ++ (case id of
                    Just x ->
                        [ Html.Attributes.id x ]

                    Nothing ->
                        []
               )
            ++ attributes
        )
        []


renderSelect : Select msg -> Html.Html msg
renderSelect (Select { id, items, options, attributes }) =
    Html.select
        ([ class <| inputOptions "form-control" options ]
            ++ (case id of
                    Just x ->
                        [ Html.Attributes.id x ]

                    Nothing ->
                        []
               )
            ++ attributes
        )
        (List.map (\(SelectItem item) -> item) items)




inputOptions : String -> List InputOption -> String
inputOptions prefix options =
    List.foldl
        (\class classString ->
            String.join " " [ classString, inputOption class ]
        )
        prefix
        options


inputOption : InputOption -> String
inputOption class =
    case class of
        InputSize size ->
            inputSizeOption size


labelOptions : List LabelOption -> String
labelOptions options =
    List.foldl
        (\class classString ->
            String.join " " [ classString, labelOption class ]
        )
        ""
        options


labelOption : LabelOption -> String
labelOption class =
    case class of
        FormLabel ->
            "form-control-label"

        LabelSize size ->
            labelSizeOption size

        LabelWidth columnWidth ->
            Grid.colWidthClassString columnWidth

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


inputSizeOption : Grid.ScreenSize -> String
inputSizeOption size =
    "form-control-" ++ Grid.screenSizeString size


labelSizeOption : Grid.ScreenSize -> String
labelSizeOption size =
    "col-form-label-" ++ Grid.screenSizeString size



validationOption : Validation -> String
validationOption validation =
    case validation of
        Success ->
            "has-success"

        Warning ->
            "has-warning"

        Danger ->
            "has-danger"
