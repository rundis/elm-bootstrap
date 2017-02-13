module Bootstrap.Button
    exposing
        ( button
        , buttonItem
        , linkButton
        , linkButtonItem
        , buttonGroup
        , buttonGroupItem
        , buttonToolbar
        , attr
        , groupAttr
        , small
        , smallGroup
        , large
        , largeGroup
        , verticalGroup
        , primary
        , secondary
        , success
        , info
        , warning
        , danger
        , roleLink
        , block
        , outlinePrimary
        , outlineSecondary
        , outlineSuccess
        , outlineInfo
        , outlineWarning
        , outlineDanger
        , ButtonOption
        , ButtonGroupOption
        , ButtonItem
        , ButtonGroupItem
        )

{-| Use Bootstrap’s custom button styles for actions in forms, dialogs, and more. Includes support for a handful of contextual variations and sizes.
You can also group a series of buttons together on a single line with the button group.


# Buttons
@docs button, linkButton

# Button options

@docs attr, ButtonOption

## Roled
@docs primary, secondary, success, info, warning, danger, roleLink

## Outlined
@docs outlinePrimary, outlineSecondary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger

## Size
@docs small, large

## Block
@docs block


# Button group

@docs buttonGroup, buttonItem, linkButtonItem, ButtonItem

## Group options
@docs smallGroup, largeGroup, verticalGroup, groupAttr, ButtonGroupOption


# Button toolbar
@docs buttonToolbar, buttonGroupItem, ButtonGroupItem


-}

import Html
import Html.Attributes as Attributes exposing (class)
import Bootstrap.Internal.Button as ButtonInternal
import Bootstrap.Internal.Grid as GridInternal




{-| Type reresenting available options for styling a button group
-}
type ButtonGroupOption msg
    = SizeGroup GridInternal.ScreenSize
    | Vertical
    | GroupAttr (Html.Attribute msg)


{-| Opaque type representing a button group. Used when composing a button toolbar
-}
type ButtonGroupItem msg
    = ButtonGroupItem (Html.Html msg)


{-| Opaque type representing a button or link button, for composing button groups
-}
type ButtonItem msg
    = ButtonItem (Html.Html msg)


{-| Opaque type reresenting available options for styling a button
-}
type alias ButtonOption msg = ButtonInternal.ButtonOption msg


{-| Create a toolbar of buttons by composing button groups. Separate groups by margins on the button groups.

    Button.buttonToolbar []
        [ Button.buttonGroupItem []
            [] -- should contain a list of button items

        , Button.buttonGroupItem
            [ Button.groupAttr <| class "ml-2" ]
            [] -- should contain a list of button items

        ]


* `attributes` List of attributes to customize the toolbar element
* `items` List of button group (items)
-}
buttonToolbar : List (Html.Attribute msg) -> List (ButtonGroupItem msg) -> Html.Html msg
buttonToolbar attributes items =
    Html.div
        ([ Attributes.attribute "role" "toolbar"
         , class "btn-toolbar"
         ]
            ++ attributes
        )
        (List.map renderButtonGroup items)


{-| Option to make all buttons in the given group small
-}
smallGroup : ButtonGroupOption msg
smallGroup =
    SizeGroup GridInternal.Small


{-| Option to make all buttons in the given group large
-}
largeGroup : ButtonGroupOption msg
largeGroup =
    SizeGroup GridInternal.Large


{-| Option to make all buttons stack vertically for a button group
-}
verticalGroup : ButtonGroupOption msg
verticalGroup =
    Vertical


{-| When you need to customize the group element with standard Html.Attribute use this function to create it as a group option
-}
groupAttr : Html.Attribute msg -> ButtonGroupOption msg
groupAttr attr =
    GroupAttr attr

{-| Create a group of related buttons

    Button.buttonGroup
        [ Button.smallGroup ]
        [ Button.button [ Button.primary ] [ text "Primary" ]
        , Button.button [ Button.secondary ] [ text "Secondary" ]
        ]

  * `options` List of styling options
  * `items` List of button items (ref [`buttonItem`](#buttonItem) and [`linkButtonItem`](#linkButtonItem))

-}
buttonGroup :
    List (ButtonGroupOption msg)
    -> List (ButtonItem msg)
    -> Html.Html msg
buttonGroup  options items =
    buttonGroupItem options items
        |> renderButtonGroup


{-| Create a button group that can be composed in a [`buttonToolbar`](#buttonToolbar)

The parameters are identical as for [`buttonGroup`](#buttonGroup)
-}
buttonGroupItem :
    List (ButtonGroupOption msg)
    -> List (ButtonItem msg)
    -> ButtonGroupItem msg
buttonGroupItem options items  =
    Html.div
        (buttonGroupAttributes options)
        (List.map (\(ButtonItem elem) -> elem) items)
        |> ButtonGroupItem


renderButtonGroup : ButtonGroupItem msg -> Html.Html msg
renderButtonGroup (ButtonGroupItem elem) =
    elem


{-| Create a button

    Button.button [ Button.primary ] [ text "Primary" ]


* `options` List of styling options
* `children` List of child elements

-}
button :
    List (ButtonOption msg)
    -> List (Html.Html msg)
    -> Html.Html msg
button options children =
    buttonItem options children
        |> renderButton


{-| Create a button that can be composed in a [`buttonGroup`](#buttonGroup)

The parameters are identical as for [`button`](#button)
-}
buttonItem :
    List (ButtonOption msg)
    -> List (Html.Html msg)
    -> ButtonItem msg
buttonItem options children  =
    Html.button
        (ButtonInternal.buttonAttributes options)
        children
        |> ButtonItem


{-| Create a link that appears as a button

    Button.linkButton [ Button.primary ] [ text "Primary" ]



* `options` List of styling options
* `children` List of child elements

-}
linkButton :
    List (ButtonOption msg)
    -> List (Html.Html msg)
    -> Html.Html msg
linkButton options children =
    linkButtonItem options children
        |> renderButton


{-| Create a link button that can be composed in a [`buttonGroup`](#buttonGroup)

The parameters are identical as for [`linkButton`](#linkButton)
-}
linkButtonItem :
    List (ButtonOption msg)
    -> List (Html.Html msg)
    -> ButtonItem msg
linkButtonItem options children =
    Html.a
        (Attributes.attribute "role" "button"
            :: ButtonInternal.buttonAttributes options
        )
        children
        |> ButtonItem


renderButton : ButtonItem msg -> Html.Html msg
renderButton (ButtonItem elem) =
    elem

{-| When you need to customize a button element with standard Html.Attribute use this function to create it as a button option
-}
attr : Html.Attribute msg -> ButtonOption msg
attr attr =
    ButtonInternal.ButtonAttr attr


{-| Option to make a button small
-}
small : ButtonOption msg
small =
    ButtonInternal.SizeButton GridInternal.Small


{-| Option to make a button large
-}
large : ButtonOption msg
large =
    ButtonInternal.SizeButton GridInternal.Large


{-| Option to color a button to signal a primary action
-}
primary : ButtonOption msg
primary =
    ButtonInternal.RoleButton ButtonInternal.Primary


{-| Option to color a button to signal a secondary action
-}
secondary : ButtonOption msg
secondary =
    ButtonInternal.RoleButton ButtonInternal.Secondary


{-| Option to indicate a successful or positive action
-}
success : ButtonOption msg
success =
    ButtonInternal.RoleButton ButtonInternal.Success


{-| Option to indicate a info action. Typically used for alerts.
-}
info : ButtonOption msg
info =
    ButtonInternal.RoleButton ButtonInternal.Info


{-| Option to indicate an action that should be taken with caution
-}
warning : ButtonOption msg
warning =
    ButtonInternal.RoleButton ButtonInternal.Warning


{-| Option to indicate an action that is potentially negative or dangerous
-}
danger : ButtonOption msg
danger =
    ButtonInternal.RoleButton ButtonInternal.Danger


{-| Option to make a button look like a link element
-}
roleLink : ButtonOption msg
roleLink =
    ButtonInternal.RoleButton ButtonInternal.Link


{-| Option to outline a button to signal a primary action
-}
outlinePrimary : ButtonOption msg
outlinePrimary =
    ButtonInternal.OutlineButton ButtonInternal.Primary


{-| Option to outline a button to signal a secondary action
-}
outlineSecondary : ButtonOption msg
outlineSecondary =
    ButtonInternal.OutlineButton ButtonInternal.Secondary


{-| Option to outline an indicatation of a successful or positive action
-}
outlineSuccess : ButtonOption msg
outlineSuccess =
    ButtonInternal.OutlineButton ButtonInternal.Success


{-| Option to outline an info action. Typically used for alerts.
-}
outlineInfo : ButtonOption msg
outlineInfo =
    ButtonInternal.OutlineButton ButtonInternal.Info


{-| Option to outline an action that should be taken with caution
-}
outlineWarning : ButtonOption msg
outlineWarning =
    ButtonInternal.OutlineButton ButtonInternal.Warning


{-| Option to outline an action that is potentially negative or dangerous
-}
outlineDanger : ButtonOption msg
outlineDanger =
    ButtonInternal.OutlineButton ButtonInternal.Danger


{-| Option to create block level buttons—those that span the full width of a parent
-}
block : ButtonOption msg
block =
    ButtonInternal.BlockButton




buttonGroupAttributes : List (ButtonGroupOption msg) -> List (Html.Attribute msg)
buttonGroupAttributes options =
    let
        prefixClass =
            "btn-group"
                ++ (if List.any (\x -> x == Vertical) options then
                        "-vertical"
                    else
                        ""
                   )
    in
        Attributes.attribute "role" "group"
            :: class prefixClass
            :: (List.map buttonGroupClass options
                    |> List.filterMap identity
               )


buttonGroupClass : ButtonGroupOption msg -> Maybe (Html.Attribute msg)
buttonGroupClass option =
    case option of
        Vertical ->
            Nothing

        SizeGroup size ->
            Maybe.map (\s -> class <| "btn-group-" ++ s) <|
                GridInternal.screenSizeOption size

        GroupAttr attr ->
            Just attr



