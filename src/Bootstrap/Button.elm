module Bootstrap.Button
    exposing
        ( button
        , buttonItem
        , linkButton
        , linkButtonItem
        , buttonGroup
        , buttonGroupItem
        , buttonToolbar
        , attrs
        , groupAttrs
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
        , Option
        , GroupOption
        , ButtonItem
        , ButtonGroupItem
        )

{-| Use Bootstrap’s custom button styles for actions in forms, dialogs, and more. Includes support for a handful of contextual variations and sizes.
You can also group a series of buttons together on a single line with the button group.


# Buttons
@docs button, linkButton

# Button options

@docs attrs, Option

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
@docs smallGroup, largeGroup, verticalGroup, groupAttrs, GroupOption


# Button toolbar
@docs buttonToolbar, buttonGroupItem, ButtonGroupItem


-}

import Html
import Html.Attributes as Attributes exposing (class, classList)
import Bootstrap.Internal.Button as ButtonInternal
import Bootstrap.Internal.Grid as GridInternal




{-| Type reresenting available options for styling a button group
-}
type GroupOption msg
    = SizeGroup GridInternal.ScreenSize
    | Vertical
    | GroupAttrs (List (Html.Attribute msg))


type alias GroupOptions msg =
    { size : Maybe GridInternal.ScreenSize
    , vertical : Bool
    , attributes : List (Html.Attribute msg)
    }


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
type alias Option msg = ButtonInternal.Option msg


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
smallGroup : GroupOption msg
smallGroup =
    SizeGroup GridInternal.Small


{-| Option to make all buttons in the given group large
-}
largeGroup : GroupOption msg
largeGroup =
    SizeGroup GridInternal.Large


{-| Option to make all buttons stack vertically for a button group
-}
verticalGroup : GroupOption msg
verticalGroup =
    Vertical


{-| When you need to customize the group element with standard Html.Attribute use this function to create it as a group option
-}
groupAttrs : List (Html.Attribute msg) -> GroupOption msg
groupAttrs attrs =
    GroupAttrs attrs

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
    List (GroupOption msg)
    -> List (ButtonItem msg)
    -> Html.Html msg
buttonGroup  options items =
    buttonGroupItem options items
        |> renderButtonGroup


{-| Create a button group that can be composed in a [`buttonToolbar`](#buttonToolbar)

The parameters are identical as for [`buttonGroup`](#buttonGroup)
-}
buttonGroupItem :
    List (GroupOption msg)
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
    List (Option msg)
    -> List (Html.Html msg)
    -> Html.Html msg
button options children =
    buttonItem options children
        |> renderButton


{-| Create a button that can be composed in a [`buttonGroup`](#buttonGroup)

The parameters are identical as for [`button`](#button)
-}
buttonItem :
    List (Option msg)
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
    List (Option msg)
    -> List (Html.Html msg)
    -> Html.Html msg
linkButton options children =
    linkButtonItem options children
        |> renderButton


{-| Create a link button that can be composed in a [`buttonGroup`](#buttonGroup)

The parameters are identical as for [`linkButton`](#linkButton)
-}
linkButtonItem :
    List (Option msg)
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
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs =
    ButtonInternal.Attrs attrs


{-| Option to make a button small
-}
small : Option msg
small =
    ButtonInternal.Size GridInternal.Small


{-| Option to make a button large
-}
large : Option msg
large =
    ButtonInternal.Size GridInternal.Large


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



buttonGroupAttributes : List (GroupOption msg) -> List (Html.Attribute msg)
buttonGroupAttributes modifiers =
    let
        options =
            List.foldl applyGroupModifier defaultGroupOptions modifiers
    in
        [ Attributes.attribute "role" "group"
        , classList
            [ ("btn-group", True)
            , ("btn-group-vertical", options.vertical)
            ]
        ] ++ ( case (options.size |> Maybe.andThen GridInternal.screenSizeOption) of
                Just s ->
                    [ class <| "btn-group-" ++ s ]

                Nothing ->
                    []
          )

        ++ options.attributes



applyGroupModifier : GroupOption msg -> GroupOptions msg -> GroupOptions msg
applyGroupModifier modifier options =
    case modifier of
        SizeGroup size ->
            { options | size = Just size }

        Vertical ->
            { options | vertical = True }

        GroupAttrs attrs ->
            { options | attributes = options.attributes ++ attrs }


defaultGroupOptions : GroupOptions msg
defaultGroupOptions =
    { size = Nothing
    , vertical = False
    , attributes = []
    }


