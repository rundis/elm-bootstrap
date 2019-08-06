module Bootstrap.Button exposing
    ( button, linkButton, radioButton, checkboxButton, submitButton, resetButton
    , attrs, onClick, disabled, Option
    , primary, secondary, success, info, warning, danger, light, dark, roleLink
    , outlinePrimary, outlineSecondary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger, outlineLight, outlineDark
    , small, large
    , block
    )

{-| Use Bootstrap’s custom button styles for actions in forms, dialogs, and more. Includes support for a handful of contextual variations and sizes.
You can also group a series of buttons together on a single line with the button group.


# Buttons

@docs button, linkButton, radioButton, checkboxButton, submitButton, resetButton


# Button options

@docs attrs, onClick, disabled, Option


## Roled

@docs primary, secondary, success, info, warning, danger, light, dark, roleLink


## Outlined

@docs outlinePrimary, outlineSecondary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger, outlineLight, outlineDark


## Size

@docs small, large


## Block

@docs block

-}

import Bootstrap.General.Internal exposing (ScreenSize(..))
import Bootstrap.Internal.Button as ButtonInternal
import Html
import Html.Attributes as Attributes exposing (class, classList, type_)
import Html.Events as Events
import Json.Decode as Decode


{-| Opaque type reresenting available options for styling a button
-}
type alias Option msg =
    ButtonInternal.Option msg


{-| Create a button

    Button.button [ Button.primary ] [ text "Primary" ]

  - `options` List of styling options
  - `children` List of child elements

-}
button :
    List (Option msg)
    -> List (Html.Html msg)
    -> Html.Html msg
button options children =
    Html.button
        (ButtonInternal.buttonAttributes options)
        children


{-| Create a link that appears as a button

    Button.linkButton [ Button.primary ] [ text "Primary" ]

  - `options` List of styling options
  - `children` List of child elements

-}
linkButton :
    List (Option msg)
    -> List (Html.Html msg)
    -> Html.Html msg
linkButton options children =
    Html.a
        (Attributes.attribute "role" "button"
            :: ButtonInternal.buttonAttributes options
        )
        children


{-| Create a radio input that appears as a button

    Button.radioButton True [ Button.primary ] [ text "Primary" ]

  - `checked` Default value
  - `options` List of styling options
  - `children` List of child elements

-}
radioButton :
    Bool
    -> List (Option msg)
    -> List (Html.Html msg)
    -> Html.Html msg
radioButton checked options children =
    let
        hideRadio =
            -- hides the radio input element, only showing the bootstrap button
            Attributes.attribute "data-toggle" "button"
    in
    Html.label
        (classList [ ( "active", checked ) ]
            :: hideRadio
            :: ButtonInternal.buttonAttributes options
        )
        (Html.input [ Attributes.type_ "radio", Attributes.checked checked, Attributes.autocomplete False ] [] :: children)


{-| Create a checkbox input that appears as a button

    Button.checkboxButton True [ Button.primary ] [ text "Primary" ]

  - `checked` Default value
  - `options` List of styling options
  - `children` List of child elements

-}
checkboxButton :
    Bool
    -> List (Option msg)
    -> List (Html.Html msg)
    -> Html.Html msg
checkboxButton checked options children =
    Html.label (classList [ ( "active", checked ) ] :: ButtonInternal.buttonAttributes options)
        (Html.input [ Attributes.type_ "checkbox", Attributes.checked checked, Attributes.autocomplete False ] [] :: children)


{-| Shorthand to creae a button with type "submit"

    Button.submitButton [ Button.primary ] [ text "Primary" ]

  - `options` List of styling options
  - `children` List of child elements

-}
submitButton : List (Option msg) -> List (Html.Html msg) -> Html.Html msg
submitButton options children =
    Html.button
        (type_ "submit" :: ButtonInternal.buttonAttributes options)
        children


{-| Shorthand to creae a button with type "reset"

    Button.resetButton [ Button.primary ] [ text "Primary" ]

  - `options` List of styling options
  - `children` List of child elements

-}
resetButton : List (Option msg) -> List (Html.Html msg) -> Html.Html msg
resetButton options children =
    Html.button
        (type_ "reset" :: ButtonInternal.buttonAttributes options)
        children


{-| When you need to customize a button element with standard Html.Attribute use this function to create it as a button option
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    ButtonInternal.Attrs attrs_


{-| Option to fire a message when a button is clicked
-}
onClick : msg -> Option msg
onClick message =
    -- prevent default is needed for checkboxButton and radioButton. If False, the click event will fire twice
    attrs [ Events.preventDefaultOn "click" (Decode.succeed ( message, True )) ]


{-| Option to make a button small
-}
small : Option msg
small =
    ButtonInternal.Size SM


{-| Option to make a button large
-}
large : Option msg
large =
    ButtonInternal.Size LG


{-| Option to color a button to signal a primary action
-}
primary : Option msg
primary =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Primary


{-| Option to color a button to signal a secondary action
-}
secondary : Option msg
secondary =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Secondary


{-| Option to indicate a successful or positive action
-}
success : Option msg
success =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Success


{-| Option to indicate a info action. Typically used for alerts.
-}
info : Option msg
info =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Info


{-| Option to indicate an action that should be taken with caution
-}
warning : Option msg
warning =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Warning


{-| Option to indicate an action that is potentially negative or dangerous
-}
danger : Option msg
danger =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Danger


{-| Option to create a light button
-}
light : Option msg
light =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Light


{-| Option to create a dark button
-}
dark : Option msg
dark =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Dark


{-| Option to make a button look like a link element
-}
roleLink : Option msg
roleLink =
    ButtonInternal.Coloring <| ButtonInternal.Roled ButtonInternal.Link


{-| Option to outline a button to signal a primary action
-}
outlinePrimary : Option msg
outlinePrimary =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Primary


{-| Option to outline a button to signal a secondary action
-}
outlineSecondary : Option msg
outlineSecondary =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Secondary


{-| Option to outline an indicatation of a successful or positive action
-}
outlineSuccess : Option msg
outlineSuccess =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Success


{-| Option to outline an info action. Typically used for alerts.
-}
outlineInfo : Option msg
outlineInfo =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Info


{-| Option to outline an action that should be taken with caution
-}
outlineWarning : Option msg
outlineWarning =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Warning


{-| Option to outline an action that is potentially negative or dangerous
-}
outlineDanger : Option msg
outlineDanger =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Danger


{-| Option to create a light outlined button
-}
outlineLight : Option msg
outlineLight =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Light


{-| Option to create a dark outlined button
-}
outlineDark : Option msg
outlineDark =
    ButtonInternal.Coloring <| ButtonInternal.Outlined ButtonInternal.Dark


{-| Option to create block level buttons—those that span the full width of a parent
-}
block : Option msg
block =
    ButtonInternal.Block


{-| Option to disable a button.
-}
disabled : Bool -> Option msg
disabled disabled_ =
    ButtonInternal.Disabled disabled_
