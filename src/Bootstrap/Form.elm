module Bootstrap.Form
    exposing
        ( form
        , inlineForm
        , group
        , groupSimple
        , groupRow
        , groupRowSimple
        , validationResult
        , textLabel
        , label
        , labelSmall
        , labelMedium
        , labelLarge
        , text
        , password
        , datetimeLocal
        , date
        , month
        , time
        , week
        , number
        , email
        , url
        , search
        , tel
        , color
        , inputSmall
        , inputMedium
        , inputLarge
        , inputId
        , inputAttr
        , selectControl
        , selectItem
        , renderControl
        , checkbox
        , checkboxRow
        , radioGroup
        , radioGroupSimple
        , radioGroupRow
        , radio
        , renderRadio
        , checkDisabled
        , radioDisabled
        , checkInline
        , radioInline
        , checkAttr
        , radioAttr
        , labelAttr
        , helpText
        , success
        , warning
        , error
        , FormCheckOption
        , Label
        , FormControl
        , InputOption
        , SelectItem
        , FormHelp
        )

import Html
import Html.Attributes exposing (class, classList, type_, style)
import Bootstrap.Internal.Form as FormInternal exposing (InputType(..), Input, Select, SelectItem, InputOption(..), FormCheckOption(..))
import Bootstrap.Grid as Grid
import Bootstrap.Internal.Grid as GridInternal


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
        { options : List (LabelOption msg)
        , children : List (Html.Html msg)
        }


type LabelOption msg
    = FormLabel
    | ColumnLabel
    | LabelSize GridInternal.ScreenSize
    | LabelWidth Grid.ColumnWidth
    | LabelAttr (Html.Attribute msg)


type FormControl msg
    = InputControl (Input msg)
    | SelectControl (Select msg)


type alias InputOption msg =
    FormInternal.InputOption msg


type alias SelectItem msg =
    FormInternal.SelectItem msg


type alias Radio msg =
    FormInternal.Radio msg


type alias FormCheckOption msg =
    FormInternal.FormCheckOption msg


type FormHelp msg
    = FormHelp (Html.Html msg)



-- FORMS


inlineForm : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
inlineForm attributes children =
    form
        (attributes ++ [ class "form-inline" ])
        children


form : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
form attributes children =
    Html.form attributes children



-- FORM GROUPS


groupSimple :
    { label : Label msg
    , control : FormControl msg
    }
    -> Html.Html msg
groupSimple { label, control } =
    group
        { label = label
        , control = control
        , validation = Nothing
        , help = Nothing
        }


group :
    { label : Label msg
    , control : FormControl msg
    , validation : Maybe ValidationResult
    , help : Maybe (FormHelp msg)
    }
    -> Html.Html msg
group { label, control, validation, help } =
    let
        updLabel =
            maybeAddLabelFor (getFormControlId control) label
                |> addLabelOptions [ FormLabel ]
    in
        Html.div
            (groupOptions validation True)
            ([ renderLabel updLabel
             , maybeAddControlValidationSymbol validation control
                |> renderControl
             ]
                ++ maybeValidation validation
                ++ maybeHelp help
            )


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
        , validation = Nothing
        , help = Nothing
        }


groupRow :
    { label : Label msg
    , labelWidth : Grid.ColumnWidth
    , control : FormControl msg
    , controlWidth : Grid.ColumnWidth
    , validation : Maybe ValidationResult
    , help : Maybe (FormHelp msg)
    }
    -> Html.Html msg
groupRow { label, labelWidth, control, controlWidth, validation, help } =
    let
        updLabel =
            maybeAddLabelFor (getFormControlId control) label
                |> addLabelOptions [ FormLabel, ColumnLabel, LabelWidth labelWidth ]
    in
        Html.div
            (groupOptions validation True)
            [ renderLabel updLabel
            , Html.div
                [ GridInternal.colWidthClass controlWidth ]
                ([ maybeAddControlValidationSymbol validation control
                    |> renderControl
                 ]
                    ++ maybeValidation validation
                    ++ maybeHelp help
                )
            ]


groupOptions : Maybe ValidationResult -> Bool -> List (Html.Attribute msg)
groupOptions validationResult isRow =
    [ classList <|
        [ ( "form-group", True )
        , ( "row", isRow )
        ]
    ]
        ++ (case validationResult of
                Nothing ->
                    []

                Just (ValidationResult res) ->
                    [ validationWrapperAttribute res.validation ]
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


maybeHelp : Maybe (FormHelp msg) -> List (Html.Html msg)
maybeHelp help =
    case help of
        Nothing ->
            []

        Just (FormHelp elem) ->
            [ elem ]


error : String -> ValidationResult
error message =
    validationResult Danger message


warning : String -> ValidationResult
warning message =
    validationResult Warning message


success : String -> ValidationResult
success message =
    validationResult Success message


validationResult : Validation -> String -> ValidationResult
validationResult validation feedback =
    ValidationResult
        { validation = validation
        , feedback = feedback
        }


maybeAddControlValidationSymbol :
    Maybe ValidationResult
    -> FormControl msg
    -> FormControl msg
maybeAddControlValidationSymbol validationRes control =
    case ( validationRes, control ) of
        ( Just (ValidationResult { validation }), InputControl inputCfg ) ->
            { inputCfg
                | options =
                    (inputCfg.options
                        ++ [ inputAttr <| validationInputAttribute validation ]
                    )
            }
                |> InputControl

        _ ->
            control


maybeAddLabelFor : Maybe (InputOption msg) -> Label msg -> Label msg
maybeAddLabelFor maybeId (Label label) =
    Label <|
        case maybeId of
            Nothing ->
                label

            Just (InputId id) ->
                { label
                    | options =
                        label.options ++ [ labelAttr <| Html.Attributes.for id ]
                }

            _ ->
                label


addLabelOptions : List (LabelOption msg) -> Label msg -> Label msg
addLabelOptions options (Label label) =
    { label | options = label.options ++ options }
        |> Label


getFormControlId : FormControl msg -> Maybe (InputOption msg)
getFormControlId control =
    let
        optionFilter opt =
            case opt of
                InputId _ ->
                    True

                _ ->
                    False
    in
        case control of
            InputControl input ->
                List.filter optionFilter input.options
                    |> List.head

            SelectControl select ->
                List.filter optionFilter select.options
                    |> List.head



-- FORM LABELS


textLabel : String -> Label msg
textLabel text =
    Label
        { options = []
        , children = [ Html.text text ]
        }


label :
    List (LabelOption msg)
    -> List (Html.Html msg)
    -> Label msg
label options children =
    Label
        { options = options
        , children = children
        }


labelSmall : LabelOption msg
labelSmall =
    LabelSize GridInternal.Small


labelMedium : LabelOption msg
labelMedium =
    LabelSize GridInternal.Medium


labelLarge : LabelOption msg
labelLarge =
    LabelSize GridInternal.Large


labelAttr : Html.Attribute msg -> LabelOption msg
labelAttr attr =
    LabelAttr attr


renderLabel : Label msg -> Html.Html msg
renderLabel (Label { options, children }) =
    Html.label
        (labelAttributes options)
        children


labelAttributes : List (LabelOption msg) -> List (Html.Attribute msg)
labelAttributes options =
    List.map labelAttribute options
        |> List.filterMap identity


labelAttribute : LabelOption msg -> Maybe (Html.Attribute msg)
labelAttribute option =
    case option of
        FormLabel ->
            Just <| class "form-control-label"

        LabelSize size ->
            labelSizeOption size

        LabelWidth columnWidth ->
            Just <| GridInternal.colWidthClass columnWidth

        ColumnLabel ->
            Just <| class "col-form-label"

        LabelAttr attr ->
            Just attr



-- FORM INPUT CONTROLS


text : List (InputOption msg) -> FormControl msg
text =
    inputControl Text


password : List (InputOption msg) -> FormControl msg
password =
    inputControl Password


datetimeLocal : List (InputOption msg) -> FormControl msg
datetimeLocal =
    inputControl DatetimeLocal


date : List (InputOption msg) -> FormControl msg
date =
    inputControl Date


month : List (InputOption msg) -> FormControl msg
month =
    inputControl Month


time : List (InputOption msg) -> FormControl msg
time =
    inputControl Time


week : List (InputOption msg) -> FormControl msg
week =
    inputControl Week


number : List (InputOption msg) -> FormControl msg
number =
    inputControl Number


email : List (InputOption msg) -> FormControl msg
email =
    inputControl Email


url : List (InputOption msg) -> FormControl msg
url =
    inputControl Url


search : List (InputOption msg) -> FormControl msg
search =
    inputControl Search


tel : List (InputOption msg) -> FormControl msg
tel =
    inputControl Tel


color : List (InputOption msg) -> FormControl msg
color =
    inputControl Color


inputSmall : InputOption msg
inputSmall =
    InputSize GridInternal.Small


inputMedium : InputOption msg
inputMedium =
    InputSize GridInternal.Medium


inputLarge : InputOption msg
inputLarge =
    InputSize GridInternal.Large


inputId : String -> InputOption msg
inputId id =
    InputId id


inputAttr : Html.Attribute msg -> InputOption msg
inputAttr attr =
    InputAttr attr


inputControl : InputType -> List (InputOption msg) -> FormControl msg
inputControl tipe options =
    InputControl <|
        FormInternal.input tipe options


renderControl : FormControl msg -> Html.Html msg
renderControl control =
    case control of
        InputControl input ->
            renderInput input

        SelectControl select ->
            renderSelect select


renderInput : Input msg -> Html.Html msg
renderInput input =
    FormInternal.renderInput input



-- FORM SELECT CONTROL


selectControl :
    List (InputOption msg)
    -> List (SelectItem msg)
    -> FormControl msg
selectControl options items =
    SelectControl <|
        FormInternal.select options items


selectItem : List (Html.Attribute msg) -> List (Html.Html msg) -> SelectItem msg
selectItem =
    FormInternal.selectItem



-- SelectItem <| Html.option attributes children


renderSelect : Select msg -> Html.Html msg
renderSelect =
    FormInternal.renderSelect



-- CHECKBOXES AND RADIOS


checkbox :
    List (FormCheckOption msg)
    -> String
    -> Html.Html msg
checkbox =
    FormInternal.checkbox


checkboxRow :
    { labelText : String
    , options : List (FormCheckOption msg)
    , offset : Grid.ColumnWidth
    , controlWidth : Grid.ColumnWidth
    }
    -> Html.Html msg
checkboxRow { labelText, options, offset, controlWidth } =
    Html.div
        [ class "form-group row" ]
        [ Html.div
            (List.filterMap identity
                [ GridInternal.offsetClass offset
                , Just <| GridInternal.colWidthClass controlWidth
                ]
            )
            [ checkbox options labelText ]
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
            [ class "col-form-legend" ]
            [ renderLabel label ]
         ]
            ++ renderRadios name radios
        )


radioGroupSimple : String -> List (Radio msg) -> Html.Html msg
radioGroupSimple name radios =
    Html.div
        []
        (renderRadios name radios)


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
                [ GridInternal.colWidthClass controlWidth ]
                ( renderRadios name radios )
            ]


renderRadios : String -> List (FormInternal.Radio msg) -> List (Html.Html msg)
renderRadios name radios =
    List.map
        (\r ->
            FormInternal.addRadioAttribute (Html.Attributes.name name) r
                |> renderRadio
        )
        radios


radio : List (FormCheckOption msg) -> String -> FormInternal.Radio msg
radio =
    FormInternal.radio


checkDisabled : FormCheckOption msg
checkDisabled =
    CheckDisabled


radioDisabled : FormCheckOption msg
radioDisabled =
    CheckDisabled


checkAttr : Html.Attribute msg -> FormCheckOption msg
checkAttr attr =
    CheckAttr attr


radioAttr : Html.Attribute msg -> FormCheckOption msg
radioAttr =
    checkAttr


checkInline : FormCheckOption msg
checkInline =
    CheckInline


radioInline : FormCheckOption msg
radioInline =
    CheckInline


renderRadio : Radio msg -> Html.Html msg
renderRadio =
    FormInternal.renderRadio



-- FORM HELP TEXT


helpText : List (Html.Attribute msg) -> List (Html.Html msg) -> FormHelp msg
helpText attributes children =
    Html.small
        ([ class "form-text text-muted" ] ++ attributes)
        children
        |> FormHelp



-- Misc helpers


labelSizeOption : GridInternal.ScreenSize -> Maybe (Html.Attribute msg)
labelSizeOption size =
    case GridInternal.screenSizeOption size of
        Just s ->
            Just <| class <| "col-form-label-" ++ s

        Nothing ->
            Nothing


validationInputAttribute : Validation -> Html.Attribute msg
validationInputAttribute validation =
    class <| "form-control-" ++ validationToString validation


validationWrapperAttribute : Validation -> Html.Attribute msg
validationWrapperAttribute validation =
    class <| "has-" ++ validationToString validation


validationToString : Validation -> String
validationToString validation =
    case validation of
        Success ->
            "success"

        Warning ->
            "warning"

        Danger ->
            "danger"
