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
        , inputId
        , inputAttr
        , selectControl
        , selectItem
        , checkbox
        , checkboxRow
        , radioGroup
        , radioGroupRow
        , radioControl
        , checkDisabled
        , checkAttr
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


type Input msg
    = Input { options : List (InputOption msg) }


type InputOption msg
    = InputSize GridInternal.ScreenSize
    | InputId String
    | InputAttr (Html.Attribute msg)


type Select msg
    = Select
        { items : List (SelectItem msg)
        , options : List (InputOption msg)
        }


type SelectItem msg
    = SelectItem (Html.Html msg)


type Radio msg
    = Radio
        { label : Label msg
        , options : List (FormCheckOption msg)
        }


type FormCheckOption msg
    = Disabled
    | CheckAttr (Html.Attribute msg)


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
                [ GridInternal.colWidthClass controlWidth ]
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
    case control of
        InputControl (Input input) ->
            List.head input.options

        {- List.filter (\opt -> case opt of
                       Input _ ->
                           True
                       _ -> False) input.options
           |> List.head
        -}
        SelectControl (Select select) ->
            List.head select.options



{- List.filter (\opt -> opt == InputId) select.options
   |> List.head
-}


labelAttr : Html.Attribute msg -> LabelOption msg
labelAttr attr =
    LabelAttr attr


textLabelControl : String -> Label msg
textLabelControl text =
    Label
        { options = []
        , children = [ Html.text text ]
        }


labelControl :
    List (LabelOption msg)
    -> List (Html.Html msg)
    -> Label msg
labelControl options children =
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


textControl : List (InputOption msg) -> FormControl msg
textControl =
    inputControl Text


passwordControl : List (InputOption msg) -> FormControl msg
passwordControl =
    inputControl Password


datetimeLocalControl : List (InputOption msg) -> FormControl msg
datetimeLocalControl =
    inputControl DatetimeLocal


dateControl : List (InputOption msg) -> FormControl msg
dateControl =
    inputControl Date


monthControl : List (InputOption msg) -> FormControl msg
monthControl =
    inputControl Month


timeControl : List (InputOption msg) -> FormControl msg
timeControl =
    inputControl Time


weekControl : List (InputOption msg) -> FormControl msg
weekControl =
    inputControl Week


numberControl : List (InputOption msg) -> FormControl msg
numberControl =
    inputControl Number


emailControl : List (InputOption msg) -> FormControl msg
emailControl =
    inputControl Email


urlControl : List (InputOption msg) -> FormControl msg
urlControl =
    inputControl Url


searchControl : List (InputOption msg) -> FormControl msg
searchControl =
    inputControl Search


telControl : List (InputOption msg) -> FormControl msg
telControl =
    inputControl Tel


colorControl : List (InputOption msg) -> FormControl msg
colorControl =
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
        Input { options = options }


selectControl :
    List (InputOption msg)
    -> List (SelectItem msg)
    -> FormControl msg
selectControl options items =
    SelectControl <|
        Select
            { options = options
            , items = items
            }


selectItem : List (Html.Attribute msg) -> List (Html.Html msg) -> SelectItem msg
selectItem attributes children =
    SelectItem <| Html.option attributes children


checkbox :
    List (FormCheckOption msg)
    -> Label msg
    -> Html.Html msg
checkbox options label =
    Html.div
        [ classList
            [ ( "form-check", True )
            , ( "disabled", isDisabled options )
            ]
        ]
        [ Html.label
            [ class "form-check-label" ]
            [ Html.input
                -- TODO: What about any the rest of the options
                [ class "form-check-input"
                , type_ "checkbox"
                , Html.Attributes.disabled <| isDisabled options
                ]
                []
            , renderLabel label
            ]
        ]


checkboxRow :
    { label : Label msg
    , options : List (FormCheckOption msg)
    , offset : Grid.ColumnWidth
    , controlWidth : Grid.ColumnWidth
    }
    -> Html.Html msg
checkboxRow { label, options, offset, controlWidth } =
    Html.div
        [ class "form-group row" ]
        [ Html.div
            (List.filterMap identity
                [ GridInternal.offsetClass offset
                , Just <| GridInternal.colWidthClass controlWidth
                ]
            )
            [ checkbox options label ]
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
                [ GridInternal.colWidthClass controlWidth ]
                (List.map
                    (\r ->
                        addRadioAttribute (Html.Attributes.name name) r
                            |> renderRadio
                    )
                    radios
                )
            ]


radioControl :
    List (FormCheckOption msg)
    -> Label msg
    -> Radio msg
radioControl options label =
    Radio
        { label = label
        , options = options
        }


checkDisabled : FormCheckOption msg
checkDisabled =
    Disabled


checkAttr : Html.Attribute msg -> FormCheckOption msg
checkAttr attr =
    CheckAttr attr


addRadioAttribute : Html.Attribute msg -> Radio msg -> Radio msg
addRadioAttribute attribute (Radio rec) =
    Radio <|
        { rec | options = rec.options ++ [ checkAttr attribute ] }


renderRadio : Radio msg -> Html.Html msg
renderRadio (Radio { label, options }) =
    Html.div
        [ classList
            [ ( "form-check", True )
            , ( "disabled", isDisabled options )
            ]
        ]
        [ Html.label
            [ class "form-check-label" ]
            [ Html.input
                -- TODO: what about the rest of the options !?
                [ type_ "radio"
                , class "form-check-input"
                , Html.Attributes.disabled <| isDisabled options
                ]
                []
            , renderLabel label
            ]
        ]


isDisabled : List (FormCheckOption msg) -> Bool
isDisabled options =
    List.any (\opt -> opt == Disabled) options


renderLabel : Label msg -> Html.Html msg
renderLabel (Label { options, children }) =
    Html.label
        (labelAttributes options)
        children


renderControl : FormControl msg -> Html.Html msg
renderControl control =
    case control of
        InputControl input ->
            renderInput input

        SelectControl select ->
            renderSelect select


renderInput : Input msg -> Html.Html msg
renderInput (Input { options }) =
    Html.input
        (inputAttributes options)
        []


renderSelect : Select msg -> Html.Html msg
renderSelect (Select { items, options }) =
    Html.select
        (inputAttributes options)
        (List.map (\(SelectItem item) -> item) items)


inputAttributes : List (InputOption msg) -> List (Html.Attribute msg)
inputAttributes options =
    class "form-control"
        :: (List.map inputAttribute options
                |> List.filterMap identity
           )


inputAttribute : InputOption msg -> Maybe (Html.Attribute msg)
inputAttribute option =
    case option of
        InputSize size ->
            inputSizeOption size

        InputId id ->
            Just <| Html.Attributes.id id

        InputAttr attr ->
            Just attr


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


inputSizeOption : GridInternal.ScreenSize -> Maybe (Html.Attribute msg)
inputSizeOption size =
    case GridInternal.screenSizeOption size of
        Just s ->
            Just <| class <| "form-control-" ++ s

        Nothing ->
            Nothing


labelSizeOption : GridInternal.ScreenSize -> Maybe (Html.Attribute msg)
labelSizeOption size =
    case GridInternal.screenSizeOption size of
        Just s ->
            Just <| class <| "col-form-label-" ++ s

        Nothing ->
            Nothing


validationOption : Validation -> String
validationOption validation =
    case validation of
        Success ->
            "has-success"

        Warning ->
            "has-warning"

        Danger ->
            "has-danger"
