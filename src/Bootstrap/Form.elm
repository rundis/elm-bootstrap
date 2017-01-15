module Bootstrap.Form
    exposing
        ( form
        , inlineForm
        , customItem
        , group
        , groupSimple
        , groupRow
        , groupRowSimple
        , textLabel
        , label
        , labelSmall
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
        , inputLarge
        , inputId
        , inputAttr
        , select
        , selectItem
        , checkbox
        , checkboxRow
        , radioGroup
        , radioGroupSimple
        , radioGroupRow
        , radio
        , checkDisabled
        , radioDisabled
        , checkInline
        , radioInline
        , checkAttr
        , radioAttr
        , labelAttr
        , help
        , success
        , warning
        , error
        , FormCheckOption
        , Label
        , FormControl
        , InputOption
        , SelectItem
        , LabelOption
        , FormHelp
        , ValidationResult
        )

{-| This library provides several form control styles, layout options, and custom components for creating a wide variety of forms.


# Form
@docs form, inlineForm

# Stacked groups
@docs group, groupSimple, radioGroup, radioGroupSimple, checkbox

# Using the grid
@docs groupRow, groupRowSimple, radioGroupRow, checkboxRow


# Labels
@docs label, textLabel, Label

## Label options
@docs labelSmall, labelLarge, labelAttr, LabelOption


# Textual inputs
@docs text, password, datetimeLocal, date, month, time, week, number, email, url, search, tel, color, FormControl

## Options
@docs inputSmall, inputLarge, inputId, inputAttr, InputOption


# Select
@docs select, selectItem, SelectItem



# Checkbox
@docs checkbox, checkboxRow

## Checkbox options
@docs checkDisabled, checkInline, checkAttr, FormCheckOption


# Radio
@docs radio

## Radio options
@docs radioDisabled, radioInline, radioAttr


# Help
@docs help, FormHelp


# Validation
@docs warning, error, success, ValidationResult

# Custom items
When all else fails and you need custom items
@docs customItem

-}


import Html
import Html.Attributes exposing (class, classList, type_, style)
import Bootstrap.Internal.Form as FormInternal exposing (InputType(..), Input, Select, SelectItem, InputOption(..), FormCheckOption(..))
import Bootstrap.Grid as Grid
import Bootstrap.Internal.Grid as GridInternal


type Validation
    = Success
    | Warning
    | Danger

{-| Opaque type representing a form element validation result
-}
type ValidationResult
    = ValidationResult
        { validation : Validation
        , feedback : String
        }


{-| Opaque type represeting a composable html label item
-}
type Label msg
    = Label
        { options : List (LabelOption msg)
        , children : List (Html.Html msg)
        }


{-| Opaque type representing the configuration options for a label
-}
type LabelOption msg
    = FormLabel
    | ColumnLabel
    | LabelSize GridInternal.ScreenSize
    | LabelWidth Grid.ColumnWidth
    | LabelAttr (Html.Attribute msg)


{-| Opaque type representing a composable form control
-}
type FormControl msg
    = InputControl (Input msg)
    | SelectControl (Select msg)


{-| Opaque type representing configuration options for an input or select
-}
type alias InputOption msg =
    FormInternal.InputOption msg


{-| Opaque type representing a select option element
-}
type alias SelectItem msg =
    FormInternal.SelectItem msg


{-| Opaque type representing a radio control
-}
type alias Radio msg =
    FormInternal.Radio msg


{-| Opaque type representing configuration options for radios and checkboxes
-}
type alias FormCheckOption msg =
    FormInternal.FormCheckOption msg


{-| Opaque type representing a form control help text element
-}
type FormHelp msg
    = FormHelp (Html.Html msg)


type FormItem msg
    = FormItem (Html.Html msg)

-- FORMS

{-| Use the inlineForm to display a series of labels, form controls, and buttons on a single horizontal row. Form controls within inline forms vary slightly from their default states.

*  Controls are display: flex, collapsing any HTML white space and allowing you to provide alignment control with spacing and flexbox utilities.
* Controls and input groups receive width: auto to override the Bootstrap default width: 100%.
* Controls only appear inline in viewports that are at least 576px wide to account for narrow viewports on mobile devices.

You may need to manually address the width and alignment of individual form controls
-}
inlineForm : List (Html.Attribute msg) -> List (FormItem msg) -> Html.Html msg
inlineForm attributes items =
    form
        (attributes ++ [ class "form-inline" ])
        items



{-| Create a default Html form element

* `attributes` List of attributes
* `items` List of Form items

-}
form : List (Html.Attribute msg) -> List (FormItem msg) -> Html.Html msg
form attributes items =
    Html.form attributes
        (List.map (\(FormItem elem) -> elem) items)



{-| Sometimes you may need to add some custom elements in between your controls
Yhis function provides you with that option.
-}
customItem : Html.Html msg -> FormItem msg
customItem element =
    FormItem element


-- FORM GROUPS

{-| Create a label control pair with no additional stuff
-}
groupSimple :
    { label : Label msg
    , control : FormControl msg
    }
    -> FormItem msg
groupSimple { label, control } =
    group
        { label = label
        , control = control
        , validation = Nothing
        , help = Nothing
        }



{-| Create a form group with optional validation and optional associated help text

    Form.group
        { validation = Just <| Form.error "You must fill in this field"
        , help = Just <| Form.help [] [ text "Enter a 7 digits " ]
        , label = Form.textLabel "MyInput"
        , control = Form.text [ Form.inputId "myinput"]
        }

-}
group :
    { label : Label msg
    , control : FormControl msg
    , validation : Maybe ValidationResult
    , help : Maybe (FormHelp msg)
    }
    -> FormItem msg
group { label, control, validation, help } =
    let
        updLabel =
            maybeAddLabelFor (getFormControlId control) label
                |> addLabelOptions [ FormLabel ]
    in
        Html.div
            (groupOptions validation False)
            ([ renderLabel updLabel
             , maybeAddControlValidationSymbol validation control
                |> renderControl
             ]
                ++ maybeValidation validation
                ++ maybeHelp help
            )
            |> FormItem

{-| Create a form group with a column for the label and one column for the control
If you need validation or helptexts you should be using [`groupRow`](#groupRow)
-}
groupRowSimple :
    { label : Label msg
    , labelWidth : Grid.ColumnWidth
    , control : FormControl msg
    , controlWidth : Grid.ColumnWidth
    }
    -> FormItem msg
groupRowSimple { label, labelWidth, control, controlWidth } =
    groupRow
        { label = label
        , labelWidth = labelWidth
        , control = control
        , controlWidth = controlWidth
        , validation = Nothing
        , help = Nothing
        }


{-| Create a form group with a column for the label and one column for the control. You may optionally supply a helptext and/or validation results

    groupRow
        { help = Just <| Form.help [] [ text "Enter a password with a minimum or 8 character" ]
        , validation = Just <| Form.error "Password to short"
        , label = Form.textLabel "Password"
        , control = Form.password [ Form.inputId "mypwdfield" ]
        , labelWidth = Grid.colXsFour
        , controlWidth = Grid.colXsEight
        }

-}
groupRow :
    { label : Label msg
    , labelWidth : Grid.ColumnWidth
    , control : FormControl msg
    , controlWidth : Grid.ColumnWidth
    , validation : Maybe ValidationResult
    , help : Maybe (FormHelp msg)
    }
    -> FormItem msg
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
            |> FormItem


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

{-| Creates an error validation result. When given to a group, the label and control will be hightlighted to indicate an error
in addition the error text will be shown below the control.
-}
error : String -> ValidationResult
error message =
    validationResult Danger message


{-| Creates an warning validation result. When given to a group, the label and control will be hightlighted to indicate a warning
in addition the warning text will be shown below the control.
-}
warning : String -> ValidationResult
warning message =
    validationResult Warning message


{-| Creates an success validation result. When given to a group, the label and control will be hightlighted to indicate success
in addition the success text will be shown below the control.
-}
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

{-| Shorthand to create a composable label element when you just want to specify a text for the label
-}
textLabel : String -> Label msg
textLabel text =
    Label
        { options = []
        , children = [ Html.text text ]
        }


{-| Createa a composable label element. It's customizable by options.

    Form.label
        [ Form.labelSmall
        , Form.labelAttr <| attribute "role" "whatever"
        ]
        [ text "My Label " ]
-}
label :
    List (LabelOption msg)
    -> List (Html.Html msg)
    -> Label msg
label options children =
    Label
        { options = options
        , children = children
        }

{-| Option to create a smaller label
-}
labelSmall : LabelOption msg
labelSmall =
    LabelSize GridInternal.Small


{-| Option to make a label taller
-}
labelLarge : LabelOption msg
labelLarge =
    LabelSize GridInternal.Large


{-| Use this function if you need to customize your label with additional Html.Attribute attributes
-}
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

{-| Create an input with type="text"

    Form.text
        [ Form.inputId "myinput"
        , Form.inputSmall
        , Form.inputAttr <| onInput MyInputMsg
        ]

-}
text : List (InputOption msg) -> FormControl msg
text =
    inputControl Text


{-| Create an input with type="password"
-}
password : List (InputOption msg) -> FormControl msg
password =
    inputControl Password


{-| Create an input with type="datetime-control"
-}
datetimeLocal : List (InputOption msg) -> FormControl msg
datetimeLocal =
    inputControl DatetimeLocal


{-| Create an input with type="date"
-}
date : List (InputOption msg) -> FormControl msg
date =
    inputControl Date


{-| Create an input with type="month"
-}
month : List (InputOption msg) -> FormControl msg
month =
    inputControl Month


{-| Create an input with type="time"
-}
time : List (InputOption msg) -> FormControl msg
time =
    inputControl Time


{-| Create an input with type="week"
-}
week : List (InputOption msg) -> FormControl msg
week =
    inputControl Week


{-| Create an input with type="number"
-}
number : List (InputOption msg) -> FormControl msg
number =
    inputControl Number


{-| Create an input with type="email"
-}
email : List (InputOption msg) -> FormControl msg
email =
    inputControl Email


{-| Create an input with type="url"
-}
url : List (InputOption msg) -> FormControl msg
url =
    inputControl Url


{-| Create an input with type="search"
-}
search : List (InputOption msg) -> FormControl msg
search =
    inputControl Search


{-| Create an input with type="tel"
-}
tel : List (InputOption msg) -> FormControl msg
tel =
    inputControl Tel


{-| Create an input with type="color"
-}
color : List (InputOption msg) -> FormControl msg
color =
    inputControl Color


{-| Option to size a text-input or select to be smaller (height wisw)
-}
inputSmall : InputOption msg
inputSmall =
    InputSize GridInternal.Small



{-| Option to size a text-input or select to be taller
-}
inputLarge : InputOption msg
inputLarge =
    InputSize GridInternal.Large


{-| Provide the id attribute for a text input or select.

**NOTE** When using form groups, the `for` attribute will be set automatically
if you specify this option !

-}
inputId : String -> InputOption msg
inputId id =
    InputId id


{-| Use this function when you need to customize your input or select with further Html.Attribute attributes
-}
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

{-| Create a composable select control for use withing form groups

    Form.select
        [ Form.inputId "myselect"
        , Form.inputLarge
        ]
        [ Form.selectItem [] [ text "Item 1"]
        , Form.selectItem [] [ text "Item 2"]
        ]

* `options` List of input options for customization
* `items` List of [`select items`](#selectItem)

-}
select :
    List (InputOption msg)
    -> List (SelectItem msg)
    -> FormControl msg
select options items =
    SelectControl <|
        FormInternal.select options items


{-|  Create an option element for use in a select

* `attributes` List of attributes
* `children` List of child elements
-}
selectItem : List (Html.Attribute msg) -> List (Html.Html msg) -> SelectItem msg
selectItem =
    FormInternal.selectItem



renderSelect : Select msg -> Html.Html msg
renderSelect =
    FormInternal.renderSelect



-- CHECKBOXES AND RADIOS


{-| Create a composable checkbox item for use in forms

    Form.checkbox [ Form.checkInline ] "Check me !"

-}
checkbox :
    List (FormCheckOption msg)
    -> String
    -> FormItem msg
checkbox options label =
    FormInternal.checkbox options label
        |> FormItem



{-| Create a checkbox row, where the checkbox is given an offset to align nicely with other form groups

    Form.checkboxRow
        { options = []
        , labeltext = "Check me !"
        , offset = Grid.offsetXsFour
        , controlWidth = Grid.colXsEight
        }

-}
checkboxRow :
    { labelText : String
    , options : List (FormCheckOption msg)
    , offset : Grid.ColumnWidth
    , controlWidth : Grid.ColumnWidth
    }
    -> FormItem msg
checkboxRow { labelText, options, offset, controlWidth } =
    Html.div
        [ class "form-group row" ]
        [ Html.div
            (List.filterMap identity
                [ GridInternal.offsetClass offset
                , Just <| GridInternal.colWidthClass controlWidth
                ]
            )
            [ FormInternal.checkbox options labelText ]
        ]
        |> FormItem


{-| Create a group of radios as a form group

    Form.radioGroup
        { label = Form.textLabel "Select one of the following"
        , name = "myradios"
        , radios =
            [ Form.radio [] "Radio 1"
            , Form.radio [] "Radio 2"
            ]
        }

**NOTE: ** The `name` is added to all radios in the radio group as with the Html `name` attribute
-}
radioGroup :
    { label : Label msg
    , name : String
    , radios : List (Radio msg)
    }
    -> FormItem msg
radioGroup { label, name, radios } =
    Html.fieldset
        [ class "form-group" ]
        ([ Html.legend
            [ class "col-form-legend" ]
            [ renderLabel label ]
         ]
            ++ renderRadios name radios
        )
        |> FormItem


{-| Create a radio group without a group label
-}
radioGroupSimple : String -> List (Radio msg) -> FormItem msg
radioGroupSimple name radios =
    Html.div
        []
        (renderRadios name radios)
        |> FormItem



{-| Create a radio group that aligns nicely with other row based form elements
    Form.radioGroupRow
        { label = Form.textLabel "Select one of the following"
        , name = "myradios"
        , labelWidth = Grid.colXsFour
        , controlWidth = Grid.colXsEight
        , radios =
            [ Form.radio [] "Radio 1"
            , Form.radio [] "Radio 2"
            ]
        }

-}
radioGroupRow :
    { label : Label msg
    , labelWidth : Grid.ColumnWidth
    , name : String
    , radios : List (Radio msg)
    , controlWidth : Grid.ColumnWidth
    }
    -> FormItem msg
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
            |> FormItem


renderRadios : String -> List (FormInternal.Radio msg) -> List (Html.Html msg)
renderRadios name radios =
    List.map
        (\r ->
            FormInternal.addRadioAttribute (Html.Attributes.name name) r
                |> renderRadio
        )
        radios


{-| Creates a composable input with type="radio" for use in radio groups

* options List of options to customize the radio
* labelText Text for the radio label
-}
radio : List (FormCheckOption msg) -> String -> FormInternal.Radio msg
radio =
    FormInternal.radio



{-| Option to disable a checkbox. Use this rather than specifying `Html.Attributes.disabled`
as this option provides additional styling.
-}
checkDisabled : FormCheckOption msg
checkDisabled =
    CheckDisabled


{-| Option to disable a radio. Use this rather than specifying `Html.Attributes.disabled`
as this option provides additional styling.
-}
radioDisabled : FormCheckOption msg
radioDisabled =
    CheckDisabled


{-| Use this function when you need to specify custom attributes for your checkbox control
-}
checkAttr : Html.Attribute msg -> FormCheckOption msg
checkAttr attr =
    CheckAttr attr


{-| Use this function when you need to specify custom attributes for your radio control
-}
radioAttr : Html.Attribute msg -> FormCheckOption msg
radioAttr =
    checkAttr


{-| Option to allow laying out checkbox controls horizontally (default is stacked )
-}
checkInline : FormCheckOption msg
checkInline =
    CheckInline


{-| Option to allow laying out radio controls horizontally (default is stacked )
-}
radioInline : FormCheckOption msg
radioInline =
    CheckInline


renderRadio : Radio msg -> Html.Html msg
renderRadio =
    FormInternal.renderRadio



-- FORM HELP TEXT

{-| Creates a form control help text element for use in form groups

* `attributes` List of attributes
* `children` List of child elements
-}
help : List (Html.Attribute msg) -> List (Html.Html msg) -> FormHelp msg
help attributes children =
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
