module Page.Form exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Radio as Radio
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Util


view : List (Html msg)
view =
    [ Util.simplePageHeader
        "Form"
        """Elm Bootstrap provides you functions to easily utilize most of the extensive form support offered by Bootstrap."""
    , Util.pageContent
        (controls
            ++ formGroups
            ++ fieldsets
            ++ inline
            ++ grid
            ++ controlSizing
            ++ columnSizing
            ++ help
            ++ validation
            ++ customControls
        )
    ]


controls : List (Html msg)
controls =
    [ h2 [] [ text "Form controls" ]
    , p [] [ text """Bootstrap provides a wide range of styling options for form controls.
                    These styles are opt-in. Elm Bootstrap provides various functions and modules
                    to make it nice and easy to apply these styles in a reasonably type safe manner.""" ]
    , Util.example
        [ Form.form []
            [ Form.group []
                [ Form.label [ for "myemail" ] [ text "Email address" ]
                , Input.email [ Input.id "myemail" ]
                , Form.help [] [ text "We'll never share your email with anyone else." ]
                ]
            , Form.group []
                [ Form.label [ for "mypwd" ] [ text "Password" ]
                , Input.password [ Input.id "mypwd" ]
                ]
            , Form.group []
                [ Form.label [ for "myselect" ] [ text "My select" ]
                , Select.select [ Select.id "myselect" ]
                    [ Select.item [] [ text "Item 1" ]
                    , Select.item [] [ text "Item 2" ]
                    ]
                ]
            , Form.group []
                [ label [ for "myarea" ] [ text "My textarea" ]
                , Textarea.textarea
                    [ Textarea.id "myarea"
                    , Textarea.rows 3
                    ]
                ]
            , Fieldset.config
                |> Fieldset.asGroup
                |> Fieldset.legend [] [ text "Radio buttons" ]
                |> Fieldset.children
                    (Radio.radioList "myradios"
                        [ Radio.create [] "Option one"
                        , Radio.create [] "Option two"
                        , Radio.create [ Radio.disabled True ] "I'm disabled"
                        ]
                    )
                |> Fieldset.view
            , Checkbox.checkbox [] "Check me out"
            , Button.button [ Button.primary ] [ text "Submit" ]
            ]
        ]
    , Util.code controlsCode
    ]


controlsCode : Html msg
controlsCode =
    Util.toMarkdownElm """

-- imports used
import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Form as Form
import Bootstrap.Form.Input as Input
import Bootstrap.Form.Select as Select
import Bootstrap.Form.Checkbox as Checkbox
import Bootstrap.Form.Radio as Radio
import Bootstrap.Form.Textarea as Textarea
import Bootstrap.Form.Fieldset as Fieldset
import Bootstrap.Button as Button


-- in some view function

Form.form []
    [ Form.group []
        [ Form.label [for "myemail"] [ text "Email address"]
        , Input.email [ Input.id "myemail" ]
        , Form.help [] [ text "We'll never share your email with anyone else." ]
        ]
    , Form.group []
        [ Form.label [for "mypwd"] [ text "Password"]
        , Input.password [ Input.id "mypwd" ]
        ]
    , Form.group []
        [ Form.label [ for "myselect" ] [ text "My select" ]
        , Select.select [ Select.id "myselect" ]
            [ Select.item [] [ text "Item 1"]
            , Select.item [] [ text "Item 2"]
            ]
        ]
    , Form.group []
        [ label [ for "myarea"] [ text "My textarea"]
        , Textarea.textarea
            [ Textarea.id "myarea"
            , Textarea.rows 3
            ]
        ]
    , Fieldset.config
        |> Fieldset.asGroup
        |> Fieldset.legend [] [ text "Radio buttons" ]
        |> Fieldset.children
            ( Radio.radioList "myradios"
                [ Radio.create [] "Option one"
                , Radio.create [] "Option two"
                , Radio.create [ Radio.disabled True] "I'm disabled"
                ]
            )
        |> Fieldset.view
    , Checkbox.checkbox [] "Check me out"
    , Button.button [ Button.primary] [ text "Submit" ]
    ]
"""


formGroups : List (Html msg)
formGroups =
    [ h2 [] [ text "Form groups" ]
    , p [] [ text """Using form groups is the easiest way to add some structure to forms.
                    It's only purpose is to provide margin-bottom around a label and control pairing.""" ]
    , Util.example
        [ Form.form []
            [ h4 [] [ text "Form groups example" ]
            , Form.group []
                [ Form.label [] [ text "Example label" ]
                , Input.text [ Input.attrs [ placeholder "Example input" ] ]
                ]
            , Form.group []
                [ Form.label [] [ text "Another label" ]
                , Input.text [ Input.attrs [ placeholder "Another input" ] ]
                ]
            ]
        ]
    , Util.code formGroupsCode
    , Util.calloutInfo
        [ p [] [ text "There's nothing stopping you from adding any element within a form group, eventhough it's primary purpose is for label + control pairs." ] ]
    ]


formGroupsCode : Html msg
formGroupsCode =
    Util.toMarkdownElm """
Form.form []
    [ h4 [] [ text "Form groups example"]
    , Form.group []
        [ Form.label [] [ text "Example label" ]
        , Input.text [ Input.attrs [ placeholder "Example input" ] ]
        ]
    , Form.group []
        [ Form.label [] [ text "Another label" ]
        , Input.text [ Input.attrs [ placeholder "Another input" ] ]
        ]
    ]
"""


fieldsets : List (Html msg)
fieldsets =
    [ h2 [] [ text "Fieldset" ]
    , p [] [ text """The Html fieldset element can be used as a form group or just as a handy way to group multiple controls.
                   You can use the Bootstrap.Form.Fieldset module for ease of composition. """ ]
    , Util.example
        [ Fieldset.config
            |> Fieldset.disabled True
            |> Fieldset.legend [] [ text "Form group fieldset" ]
            |> Fieldset.children
                [ Fieldset.config
                    |> Fieldset.asGroup
                    |> Fieldset.children
                        [ Form.label [] [ text "Some field" ]
                        , Input.text []
                        ]
                    |> Fieldset.view
                , Fieldset.config
                    |> Fieldset.asGroup
                    |> Fieldset.children
                        [ Form.label [] [ text "Another field" ]
                        , Input.text []
                        ]
                    |> Fieldset.view
                ]
            |> Fieldset.view
        ]
    , Util.code fieldsetsCode
    , Util.calloutInfo
        [ h3 [] [ text "Usage" ]
        , p [] [ text """You can nest fieldsets and optionally use them as form groups.
                        A neat feature of fieldsets is that if you add the disabled attribute, all form controls and buttons
                        within the fieldset will be disabled (caveat: doesn't work for anchor elements).
                        Here's how to use them in Elm Bootstrap:""" ]
        , ul []
            [ textLi "You start by calling Fieldset.config which returns an opaque config record."
            , textLi "Then optionsally configure options, add legend (again optional) and children. Order doesn't matter."
            , textLi "Finally to turn the fieldset into Elm Html, call the view function."
            ]
        , p [] [ text """If you call the same composition function more than once, the last one "wins".""" ]
        ]
    ]


fieldsetsCode : Html msg
fieldsetsCode =
    Util.toMarkdownElm """
Fieldset.config
    |> Fieldset.disabled True
    |> Fieldset.legend [] [ text "Form group fieldset" ]
    |> Fieldset.children
        [ Fieldset.config
            |> Fieldset.asGroup
            |> Fieldset.children
                [ Form.label [] [ text "Some field" ]
                , Input.text []
                ]
            |> Fieldset.view
        , Fieldset.config
            |> Fieldset.asGroup
            |> Fieldset.children
                [ Form.label [] [ text "Another field" ]
                , Input.text []
                ]
            |> Fieldset.view
        ]
    |> Fieldset.view
"""


inline : List (Html msg)
inline =
    [ h2 [] [ text "Inline forms" ]
    , p [] [ text """Use the Form.formInline function to display a series of labels, form controls, and buttons on a single horizontal row.
                    Form controls within inline forms vary slightly from their default states.""" ]
    , Util.example
        [ Form.formInline []
            [ Input.text [ Input.attrs [ placeholder "Search" ] ]
            , Button.button
                [ Button.primary
                , Button.attrs [ class "ml-sm-2 my-2" ]
                ]
                [ text "Search" ]
            ]
        ]
    , Util.code inlineCode
    , Util.calloutInfo
        [ p [] [ text """When using inline forms you'll probably end up having to adjust spacing, width and alignment.
                      Once you do, you also need to take into account that your form should probably support a responsive design.
                      Bootstrap provides a range of util classes that's not yet added to Elm Bootstrap.
                      Please consult the Twitter Bootstrap 4 documentation for details.""" ]
        ]
    ]


inlineCode : Html msg
inlineCode =
    Util.toMarkdownElm """
Form.formInline []
    [ Input.text [ Input.attrs [ placeholder "Search" ]]
    , Button.button
        [ Button.primary
        , Button.attrs [ class "ml-sm-2 my-2" ]
        ]
        [ text "Search" ]
    ]
"""


grid : List (Html msg)
grid =
    [ h2 [] [ text "Using the Grid" ]
    , p [] [ text """For more structured form layouts that are also responsive, you can utilize the Grid aware Form related functions in Elm Bootstrap.
                  We reuse the options from the Bootstrap.Grid.Col and Bootstrap.Grid.Row modules to provide you with
                  a very wide range of options to structure your forms. Let's show an example of a horizontal form.""" ]
    , Util.example
        [ Grid.container []
            [ Form.form []
                [ Form.row []
                    [ Form.colLabel [ Col.sm2 ] [ text "Email" ]
                    , Form.col [ Col.sm10 ]
                        [ Input.email [] ]
                    ]
                , Form.row []
                    [ Form.colLabel [ Col.sm2 ] [ text "Postal" ]
                    , Form.col [ Col.sm5 ]
                        [ Input.text [ Input.attrs [ placeholder "Zip" ] ] ]
                    , Form.col [ Col.sm5 ]
                        [ Input.text [ Input.attrs [ placeholder "State" ] ] ]
                    ]
                , Form.row []
                    [ Form.col [ Col.offsetSm2, Col.sm10 ]
                        [ Checkbox.checkbox [] "Check me" ]
                    ]
                , Form.row [ Row.rightSm ]
                    [ Form.col [ Col.sm2 ]
                        [ Button.button
                            [ Button.primary, Button.attrs [ class "float-right" ] ]
                            [ text "Submit" ]
                        ]
                    ]
                ]
            ]
        ]
    , Util.code gridCode
    ]


gridCode : Html msg
gridCode =
    Util.toMarkdownElm """
Grid.container []
    [ Form.form []
        [ Form.row []
            [ Form.colLabel [ Col.sm2 ] [ text "Email" ]
            , Form.col [ Col.sm10 ]
                [ Input.email [] ]
            ]
        , Form.row []
            [ Form.colLabel [ Col.sm2 ] [ text "Postal" ]
            , Form.col [ Col.sm5 ]
                [ Input.text [ Input.attrs [ placeholder "Zip" ] ] ]
            , Form.col [ Col.sm5 ]
                [ Input.text [ Input.attrs [ placeholder "State" ] ] ]
            ]
        , Form.row []
            [ Form.col [ Col.offsetSm2, Col.sm10 ]
                [ Checkbox.checkbox [] "Check me" ]
            ]
        , Form.row [ Row.rightSm ]
            [ Form.col [ Col.sm2 ]
                [ Button.button
                    [ Button.primary, Button.attrs [ class "float-right"] ]
                    [ text "Submit" ]
                ]
            ]
        ]
    ]
"""


controlSizing : List (Html msg)
controlSizing =
    [ h2 [] [ text "Control sizing" ]
    , p [] [ text "You can control the height of text inputs and selects when that makes sense." ]
    , Util.example
        [ h4 [] [ text "Inputs" ]
        , Input.text [ Input.large, Input.attrs [ placeholder "large" ] ]
        , Input.text [ Input.attrs [ placeholder "Default" ] ]
        , Input.text [ Input.small, Input.attrs [ placeholder "small" ] ]
        , h4 [ class "mt-4" ] [ text "Selects" ]
        , Select.select [ Select.large ]
            [ Select.item [] [ text "Large" ] ]
        , Select.select []
            [ Select.item [] [ text "Default" ] ]
        , Select.select [ Select.small ]
            [ Select.item [] [ text "Small" ] ]
        ]
    , Util.code controlSizingCode
    ]


controlSizingCode : Html msg
controlSizingCode =
    Util.toMarkdownElm """
div []
    [ h4 [] [ text "Inputs" ]
    , Input.text [ Input.large, Input.attrs [ placeholder "large" ] ]
    , Input.text [ Input.attrs [ placeholder "Default" ] ]
    , Input.text [ Input.small, Input.attrs [ placeholder "small" ] ]
    , h4 [ class "mt-4" ] [ text "Selects" ]
    , Select.select [ Select.large ]
        [ Select.item [] [ text "Large"] ]
    , Select.select []
        [ Select.item [] [ text "Default"] ]
    , Select.select [ Select.small ]
        [ Select.item [] [ text "Small"] ]
    ]
"""


columnSizing : List (Html msg)
columnSizing =
    [ h2 [] [ text "Column sizing" ]
    , p [] [ text "Wrap inputs in grid columns to enforce desired widths." ]
    , Util.example
        [ Grid.row []
            [ Grid.col [ Col.xs2 ]
                [ Input.text [ Input.attrs [ placeholder ".col-2"] ] ]
            , Grid.col [ Col.xs3 ]
                [ Input.text [ Input.attrs [ placeholder ".col-3"] ] ]
            , Grid.col [ Col.xs4 ]
                [ Input.text [ Input.attrs [ placeholder ".col-4"] ] ]
            ]
        ]
    , Util.code columnSizingCode
    ]

columnSizingCode : Html msg
columnSizingCode =
    Util.toMarkdownElm """
Grid.row []
    [ Grid.col [ Col.xs2 ]
        [ Input.text [ Input.attrs [ placeholder ".col-2"] ] ]
    , Grid.col [ Col.xs3 ]
        [ Input.text [ Input.attrs [ placeholder ".col-3"] ] ]
    , Grid.col [ Col.xs4 ]
        [ Input.text [ Input.attrs [ placeholder ".col-4"] ] ]
    ]
"""


help : List (Html msg)
help =
    [ h2 [] [ text "Help text"]
    , p [] [ text "Provide context relateded help text by using convenience functions in the Form module." ]
    , Util.example
        [ h4 [] [ text "Block level" ]
        , Form.label [] [ text "Password" ]
        , Input.password []
        , Form.help [] [ text "Your password must be minumum 8 characters" ]
        ]
    , Util.code helpCode
    , Util.example
        [ h4 [] [ text "Inline"]
        , Form.formInline []
            [ Form.label [] [ text "Passoword" ]
            , Input.password [ Input.attrs [ class "mx-sm-3" ] ]
            , Form.helpInline [] [ text "Your password must be minumum 8 characters" ]
            ]
        ]
    , Util.code helpInlineCode
    ]

helpCode : Html msg
helpCode =
    Util.toMarkdownElm """
div []
    [ Form.label [] [ text "Password" ]
    , Input.password []
    , Form.help [] [ text "Your password must be minumum 8 characters" ]
    ]
"""

helpInlineCode : Html msg
helpInlineCode =
    Util.toMarkdownElm """
Form.formInline []
    [ Form.label [] [ text "Passoword" ]
    , Input.password [ Input.attrs [ class "mx-sm-3" ] ]
    , Form.helpInline [] [ text "Your password must be minumum 8 characters" ]
    ]
"""


validation : List (Html msg)
validation =
    [ h2 [] [ text "Validation" ]
    , p [] [ text """You can add validation styles to your forms and form elements to provide feedback to your users.""" ]
    , Util.example
        [ Form.form []
            [ Form.group [ Form.groupSuccess ]
                [ Form.label [] [ text "Success" ]
                , Input.text [ Input.success ]
                , Form.validationText [] [ text "All good !" ]
                , Form.help [] [ text "Help text" ]
                ]
            , Form.group [ Form.groupWarning ]
                [ Form.label [] [ text "Warning" ]
                , Input.text [ Input.warning ]
                , Form.validationText [] [ text "Hm... are you sure about this ?" ]
                , Form.help [] [ text "Help text" ]
                ]
            , Form.group [ Form.groupDanger ]
                [ Form.label [] [ text "Danger" ]
                , Input.text [ Input.danger ]
                , Form.validationText [] [ text "Something not quite right." ]
                , Form.help [] [ text "Help text" ]
                ]
            , Form.group [ Form.groupSuccess ]
                [ Form.label [] [ text "Select success" ]
                , Select.select []
                    [ Select.item [] [ text "Option" ] ]
                , Form.validationText [] [ text "Excellent choice" ]
                , Form.help [] [ text "Help text" ]
                ]
            , Form.group [ Form.groupDanger ]
                [ Form.label [] [ text "Danger Area" ]
                , Textarea.textarea [ Textarea.rows 2 ]
                , Form.validationText [] [ text "Too much stuff" ]
                , Form.help [] [ text "Help text" ]
                ]

            , Checkbox.checkbox [ Checkbox.warning ] "Check me"
            ]
        ]
    , Util.code validationInlineCode
    , Util.calloutInfo
        [ h3 [] [ text "How it works" ]
        , p [] [ text "Here's how it works:" ]
        , ul []
            [ textLi "Add a validation state to a form group, checkbox or radio."
            , textLi "Any label or form control within the group will receive the validation style."
            , textLi "Any validationText (which is optional of course), will also receive the validation style."
            , textLi "For inputs (and textarea) you can also add a validation state icon to the control itself, by manually setting the validation state on the control."
            , textLi "For checkboxes, you set the validation state on the checkbox itself."
            ]
        ]
    , h4 [] [ text  "Validation in horizontal forms"]
    , Util.example
        [ Form.form []
            [ Form.row [ Form.rowSuccess ]
                [ Form.colLabel [ Col.sm2 ] [ text "Password" ]
                , Form.col [ Col.sm10 ]
                    [ Input.password [ Input.success ]
                    , Form.validationText [] [ text "Nice one !" ]
                    , Form.help [] [ text "Make sure it's kept safe..." ]
                    ]
                ]
            , Form.row [ Form.rowDanger ]
                [ Form.colLabel [ Col.sm2 ] [ text "Password" ]
                , Form.col [ Col.sm10 ]
                    [ Input.password [ Input.danger ]
                    , Form.validationText [] [ text "Nice try, but no sigar !" ]
                    , Form.help [] [ text "Make sure it's kept safe..." ]
                    ]
                ]
            , Form.row [ Form.rowWarning ]
                [ Form.colLabel [ Col.sm2 ] [ text "Choose carefully" ]
                , Form.col [ Col.sm10 ]
                    [ Fieldset.config
                        |> Fieldset.children
                            [ Checkbox.checkbox
                                [ Checkbox.inline ]
                                "Choose me"
                            , Checkbox.checkbox
                                [ Checkbox.inline ]
                                "No me"
                            , Checkbox.checkbox
                                [ Checkbox.inline]
                                "Correct choice"
                            ]
                        |> Fieldset.view
                    ]


                ]
            ]
        ]
    , Util.code validationInlineCode
    ]


validationInlineCode : Html msg
validationInlineCode =
    Util.toMarkdownElm """
Form.form []
    [ Form.group [ Form.groupSuccess ]
        [ Form.label [] [ text "Success" ]
        , Input.text [ Input.success ]
        , Form.validationText [] [ text "All good !" ]
        , Form.help [] [ text "Help text" ]
        ]
    , Form.group [ Form.groupWarning ]
        [ Form.label [] [ text "Warning" ]
        , Input.text [ Input.warning ]
        , Form.validationText [] [ text "Hm... are you sure about this ?" ]
        , Form.help [] [ text "Help text" ]
        ]
    , Form.group [ Form.groupDanger ]
        [ Form.label [] [ text "Danger" ]
        , Input.text [ Input.danger ]
        , Form.validationText [] [ text "Something not quite right." ]
        , Form.help [] [ text "Help text" ]
        ]
    , Form.group [ Form.groupSuccess ]
        [ Form.label [] [ text "Select success" ]
        , Select.select []
            [ Select.item [] [ text "Option" ] ]
        , Form.validationText [] [ text "Excellent choice" ]
        , Form.help [] [ text "Help text" ]
        ]
    , Form.group [ Form.groupDanger ]
        [ Form.label [] [ text "Danger Area" ]
        , Textarea.textarea [ Textarea.rows 2 ]
        , Form.validationText [] [ text "Too much stuff" ]
        , Form.help [] [ text "Help text" ]
        ]

    , Checkbox.checkbox [ Checkbox.warning ] "Check me"
    ]
"""



customControls : List (Html msg)
customControls =
    [ h2 [] [ text "Custom controls"]
    , p [] [ text """Bootstrap provides a few custom controls to make std Html Form elements appear a bit nicer across browsers.
                You can choose to opt in on using custom selects, radios and checkboxes fairly seamlessly""" ]
    , Util.example
        [ Form.form []
            [ Form.group []
                [ Form.label [] [ text "Custom select" ]
                , Select.custom []
                    [ Select.item [] [ text "Item 1"]
                    , Select.item [] [ text "Item 2"]
                    ]
                ]
            , Form.group []
                [ Form.label [] [ text "Custom radios" ]
                , Fieldset.config
                    |> Fieldset.children
                        ( Radio.radioList "customradiogroup"
                            [ Radio.createCustom [ Radio.inline ] "Radio 1"
                            , Radio.createCustom [ Radio.inline ] "Radio 2"
                            , Radio.createCustom [ Radio.inline ] "Radio 3"
                            ]
                        )
                    |> Fieldset.view
                ]
            , Form.group []
                [ Form.label [] [ text "Custom checkboxes" ]
                , Fieldset.config
                    |> Fieldset.children
                        [ Checkbox.custom [ Checkbox.inline ] "Check 1"
                        , Checkbox.custom [ Checkbox.inline ] "Check 2"
                        , Checkbox.custom [ Checkbox.inline ] "Check 3"
                        ]
                    |> Fieldset.view
                ]
            ]
        ]
    , Util.code customControlsCode
    , Util.calloutInfo
        [ p [] [ text """In Elm Bootstrap custom controls are block level by default as opposed to in Twitter Bootstrap 4, where they are inline.
                         By making them block level by default, they behave just like their non custom counterparts, which is hopefully less confusing !""" ]
        ]
    ]


customControlsCode : Html msg
customControlsCode =
    Util.toMarkdownElm """
Form.form []
    [ Form.group []
        [ Form.label [] [ text "Custom select" ]
        , Select.custom []
            [ Select.item [] [ text "Item 1"]
            , Select.item [] [ text "Item 2"]
            ]
        ]
    , Form.group []
        [ Form.label [] [ text "Custom radios" ]
        , Fieldset.config
            |> Fieldset.children
                ( Radio.radioList "customradiogroup"
                    [ Radio.createCustom [ Radio.inline ] "Radio 1"
                    , Radio.createCustom [ Radio.inline ] "Radio 2"
                    , Radio.createCustom [ Radio.inline ] "Radio 3"
                    ]
                )
            |> Fieldset.view
        ]
    , Form.group []
        [ Form.label [] [ text "Custom checkboxes" ]
        , Fieldset.config
            |> Fieldset.children
                [ Checkbox.custom [ Checkbox.inline ] "Check 1"
                , Checkbox.custom [ Checkbox.inline ] "Check 2"
                , Checkbox.custom [ Checkbox.inline ] "Check 3"
                ]
            |> Fieldset.view
        ]
    ]
"""




textLi : String -> Html msg
textLi str =
    li [] [ text str ]
