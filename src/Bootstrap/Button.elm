module Bootstrap.Button
    exposing
        ( button
        , linkButton
        , attrs
        , small
        , large
        , primary
        , secondary
        , success
        , info
        , warning
        , danger
        , roleLink
        , block
        , disabled
        , outlinePrimary
        , outlineSecondary
        , outlineSuccess
        , outlineInfo
        , outlineWarning
        , outlineDanger
        , Option
        )

{-| Use Bootstrap’s custom button styles for actions in forms, dialogs, and more. Includes support for a handful of contextual variations and sizes.
You can also group a series of buttons together on a single line with the button group.


# Buttons
@docs button, linkButton

# Button options

@docs attrs, disabled, Option

## Roled
@docs primary, secondary, success, info, warning, danger, roleLink

## Outlined
@docs outlinePrimary, outlineSecondary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger

## Size
@docs small, large

## Block
@docs block


-}

import Html
import Html.Attributes as Attributes exposing (class, classList)
import Bootstrap.Internal.Button as ButtonInternal
import Bootstrap.Grid.Internal as GridInternal


{-| Opaque type reresenting available options for styling a button
-}
type alias Option msg =
    ButtonInternal.Option msg


{-| Create a button

    Button.button [ Button.primary ] [ text "Primary" ]


* `options` List of styling options
* `children` List of child elements

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



* `options` List of styling options
* `children` List of child elements

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


{-| When you need to customize a button element with standard Html.Attribute use this function to create it as a button option
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs =
    ButtonInternal.Attrs attrs


{-| Option to make a button small
-}
small : Option msg
small =
    ButtonInternal.Size GridInternal.SM


{-| Option to make a button large
-}
large : Option msg
large =
    ButtonInternal.Size GridInternal.LG


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


{-| Option to create block level buttons—those that span the full width of a parent
-}
block : Option msg
block =
    ButtonInternal.Block


{-| Option to disable a button.
-}
disabled : Bool -> Option msg
disabled disabled =
    ButtonInternal.Disabled disabled
