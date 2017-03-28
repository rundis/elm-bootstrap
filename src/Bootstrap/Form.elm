module Bootstrap.Form
    exposing
        ( form
        , formInline
        , group
        , label
        , row
        , col
        , colLabel
        , colLabelSm
        , colLabelLg
        , help
        , helpInline
        , validationText
        , groupSuccess
        , groupDanger
        , groupWarning
        , rowSuccess
        , rowWarning
        , rowDanger
        , Col
        )

{-| Bootstrap provides several form control styles, layout options, and custom components for creating a wide variety of forms.

# Forms
@docs form, formInline


# Groups
Use form groups to group items together (label + input is a typical simple example)

@docs group, label

## Group validation
@docs groupSuccess, groupWarning, groupDanger


# Grid layouts
@docs row, col, colLabel, colLabelSm, colLabelLg, Col


## Row validation
@docs rowSuccess, rowWarning, rowDanger


# Validation
@docs validationText

# Handy helpers
@docs help, helpInline

-}

import Html
import Html.Attributes as Attributes
import Bootstrap.Form.FormInternal as FormInternal
import Bootstrap.Grid.Row as Row
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Internal as GridInternal


{-| Opaque type representing a column in a form row
-}
type Col msg
    = Col
        { elemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        , options : List (Col.Option msg)
        , children : List (Html.Html msg)
        }


type Option msg
    = Validation FormInternal.Validation
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { validation : Maybe FormInternal.Validation
    , attributes : List (Html.Attribute msg)
    }


{-| Create a Html form elment
-}
form : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
form attributes children =
    Html.form
        attributes
        children


{-| Create an inline form for placing elements horizontally.

**Note**: You should stick to inline elements to get the effect you are probably expecting !
-}
formInline : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
formInline attributes =
    form (Attributes.class "form-inline" :: attributes)


{-| Use the group function to create a grouping of related form elements.
It just creates a div container with a `form-group` Bootstrap class.
Typically you use this for vertically laid out forms.

* `options` List of [`options`](#Option) for customizing the group
* `children` List of children
-}
group : List (Option msg) -> List (Html.Html msg) -> Html.Html msg
group options children =
    Html.div
        (toAttributes options)
        children


{-| Create a form control label. Suitable for use in form groups.

* `attributes` List of attributes
* `children` List of child elements
-}
label : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
label attributes children =
    Html.label
        (Attributes.class "form-control-label" :: attributes)
        children


{-| Option to signal success for a form group. Typically used for validation.
-}
groupSuccess : Option msg
groupSuccess =
    Validation FormInternal.Success


{-| Option to give a warning feedback for a form group.  Typically used for validation.
-}
groupWarning : Option msg
groupWarning =
    Validation FormInternal.Warning


{-| Option to give a danger/error feedback for a form group. Typically used for validation.
-}
groupDanger : Option msg
groupDanger =
    Validation FormInternal.Danger


{-| Creates a block level text element, suitable for providing context related help text in form groups.
-}
help : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
help attributes children =
    Html.small
        (Attributes.class "form-text text-muted" :: attributes)
        children


{-| Creates an inline text element, suitable for providing context related help text for inputs.
-}
helpInline : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
helpInline attributes children =
    Html.small
        (Attributes.class "text-muted" :: attributes)
        children


{-| Function to create validation related feedback. When placed inside a form group
or form row with validation options set, this element will receive the appropriate color.
-}
validationText :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
validationText attributes children =
    Html.div
        (Attributes.class "form-control-feedback" :: attributes)
        children


toAttributes : List (Option msg) -> List (Html.Attribute msg)
toAttributes modifiers =
    let
        options =
            List.foldl applyModifier defaultOptions modifiers
    in
        [ Attributes.class "form-group" ]
            ++ case options.validation of
                Just validation ->
                    [ FormInternal.validationWrapperAttribute validation ]

                Nothing ->
                    []
                        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { validation = Nothing
    , attributes = []
    }


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Validation validation ->
            { options | validation = Just validation }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }



{- Grid related functions -}


{-| Create a form group row element. Use this function when creating horizontal forms (in various shapes)
It reuses the options from Bootstrap.Grid.Row which gives you
a ton of customization options for how to layout columns within this row.

* `options` List of Bootstrap.Grid.Row options
* `cols` List of column elements (see [`col`](#col) or [`colLabel`](#colLabel))
-}
row : List (Row.Option msg) -> List (Col msg) -> Html.Html msg
row options cols =
    Html.div
        (Attributes.class "form-group" :: GridInternal.rowAttributes options)
        (List.map renderCol cols)


{-| Create a Grid column for use in [`form rows`](#row). It reuses the options from Bootstrap.Grid.Col which gives
you a ton of customization options for layout.

* `options` List of Bootstrap.Grid.Col options
* `children` List of child elements
-}
col : List (Col.Option msg) -> List (Html.Html msg) -> Col msg
col options children =
    Col
        { elemFn = Html.div
        , options = options
        , children = children
        }


{-| Create a label element as a grid column to be used in a [`form row`](#row).
Handy for use in horizontal form in various shapes.

* `options` List of Bootstrap.Grid.Col options for layout customization
* `children` List of child elements
-}
colLabel : List (Col.Option msg) -> List (Html.Html msg) -> Col msg
colLabel options children =
    Col
        { elemFn = Html.label
        , options = Col.attrs [ Attributes.class "col-form-label" ] :: options
        , children = children
        }


{-| Create a shorter (height) [`colLabel`](#colLabel)
-}
colLabelSm :
    List (GridInternal.ColOption msg)
    -> List (Html.Html msg)
    -> Col msg
colLabelSm options =
    colLabel (Col.attrs [ Attributes.class "col-form-label-sm" ] :: options)


{-| Create a taller  [`colLabel`](#colLabel)
-}
colLabelLg :
    List (GridInternal.ColOption msg)
    -> List (Html.Html msg)
    -> Col msg
colLabelLg options =
    colLabel (Col.attrs [ Attributes.class "col-form-label-lg" ] :: options)


{-| Option to give a success feedback for a form row.  Typically used for validation.
-}
rowSuccess : Row.Option msg
rowSuccess =
    rowValidation FormInternal.Success


{-| Option to give a warning feedback for a form row.  Typically used for validation.
-}
rowWarning : Row.Option msg
rowWarning =
    rowValidation FormInternal.Warning


{-| Option to give a danger/error feedback for a form row.  Typically used for validation.
-}
rowDanger : Row.Option msg
rowDanger =
    rowValidation FormInternal.Danger


rowValidation : FormInternal.Validation -> Row.Option msg
rowValidation validation =
    Row.attrs [ FormInternal.validationWrapperAttribute validation ]


renderCol : Col msg -> Html.Html msg
renderCol (Col { elemFn, options, children }) =
    elemFn
        (GridInternal.colAttributes options)
        children
