module Bootstrap.Button
    exposing
        ( button
        , buttonItem
        , linkButton
        , linkButtonItem
        , buttonGroup
        , buttonGroupItem
        , buttonToolbar
        , small
        , smallGroup
        , large
        , largeGroup
        , verticalGroup
        , rolePrimary
        , roleSecondary
        , roleSuccess
        , roleInfo
        , roleWarning
        , roleDanger
        , roleLink
        , block
        , outlinePrimary
        , outlineSecondary
        , outlineSuccess
        , outlineInfo
        , outlineWarning
        , outlineDanger
        , ButtonOption
        , ButtonConfig
        , ButtonGroupConfig
        , ButtonGroupOption
        , ButtonItem
        , ButtonGroupItem
        )

{-| Use Bootstrap’s custom button styles for actions in forms, dialogs, and more. Includes support for a handful of contextual variations and sizes.
You can also group a series of buttons together on a single line with the button group.


# Buttons
@docs button, linkButton, ButtonConfig

# Button options

@docs ButtonOption

## Roled
@docs rolePrimary, roleSecondary, roleSuccess, roleInfo, roleWarning, roleDanger, roleLink

## Outlined
@docs outlinePrimary, outlineSecondary, outlineSuccess, outlineInfo, outlineWarning, outlineDanger

## Size
@docs small, large

## Block
@docs block


# Button group

@docs buttonGroup, buttonItem, linkButtonItem, ButtonItem, ButtonGroupConfig

## Group options
@docs smallGroup, largeGroup, verticalGroup, ButtonGroupOption



# Button toolbar
@docs buttonToolbar, buttonGroupItem, ButtonGroupItem


-}

import Html
import Html.Attributes as Attributes exposing (class)
import Bootstrap.Internal.Button as ButtonInternal
import Bootstrap.Internal.Grid as GridInternal



{-| Type alias for params required for button functions.
-}
type alias ButtonConfig msg =
    { options : List ButtonOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


{-| Type alias for params required for buttonGroup
-}
type alias ButtonGroupConfig msg =
    { options : List ButtonGroupOption
    , attributes : List (Html.Attribute msg)
    , items : List (ButtonItem msg)
    }


{-| Type reresenting available options for styling a button group
-}
type ButtonGroupOption
    = SizeGroup GridInternal.ScreenSize
    | Vertical


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
type alias ButtonOption = ButtonInternal.ButtonOption


{-| Create a toolbar of buttons by composing button groups. Separate groups by margins on the button groups.

    Button.buttonToolbar []
        [ Button.buttonGroupItem
            { options = []
            , attributes = []
            , items = [] -- should contain a list of button items
            }
        , Button.buttonGroupItem
            { options = []
            , attributes = [ class "ml-2"]
            , items = [] -- should contain a list of button items
            }
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
smallGroup : ButtonGroupOption
smallGroup =
    SizeGroup GridInternal.Small


{-| Option to make all buttons in the given group large
-}
largeGroup : ButtonGroupOption
largeGroup =
    SizeGroup GridInternal.Large


{-| Option to make all buttons stack vertically for a button group
-}
verticalGroup : ButtonGroupOption
verticalGroup =
    Vertical


{-| Create a group of related buttons

    Button.buttonGroup
        { options = [ Button.smallGroup ]
        , attributes = []
        , items =
            [ Button.button
                { options = [ Button.rolePrimary ]
                , attributes = []
                , children = [ text "Primary" ]
                }
            , Button.button
                { options = [ Button.roleSecondary ]
                , attributes = []
                , children = [ text "Secondary" ]
                }
            ]
        }


* `buttonGroupConfig` config/params for a button group
  * `options` List of styling options
  * `attributes` List of attributes
  * `items` List of button items (ref [`buttonItem`](#buttonItem) and [`linkButtonItem`](#linkButtonItem))

-}
buttonGroup : ButtonGroupConfig msg -> Html.Html msg
buttonGroup buttonGroupConfig =
    buttonGroupItem buttonGroupConfig
        |> renderButtonGroup


{-| Create a button group that can be composed in a [`buttonToolbar`](#buttonToolbar)

The parameters are identical as for [`buttonGroup`](#buttonGroup)
-}
buttonGroupItem : ButtonGroupConfig msg -> ButtonGroupItem msg
buttonGroupItem { options, attributes, items } =
    Html.div
        (buttonGroupAttributes options ++ attributes)
        (List.map (\(ButtonItem elem) -> elem) items)
        |> ButtonGroupItem


renderButtonGroup : ButtonGroupItem msg -> Html.Html msg
renderButtonGroup (ButtonGroupItem elem) =
    elem


{-| Create a button

    Button.button
        { options = [ Button.rolePrimary ]
        , attributes = []
        , children = [ text "Primary" ]
        }


    -- Alternatively
    Button.button
        <| Button.ButtonConfig
            [Button.rolePrimary] [] [text "primary"]


* `buttonConfig` config/params for a button
  * `options` List of styling options
  * `attributes` List of attributes
  * `children` List of child elements


-}
button : ButtonConfig msg -> Html.Html msg
button buttonConfig =
    buttonItem buttonConfig
        |> renderButton


{-| Create a button that can be composed in a [`buttonGroup`](#buttonGroup)

The parameters are identical as for [`button`](#button)
-}
buttonItem : ButtonConfig msg -> ButtonItem msg
buttonItem { options, attributes, children } =
    Html.button
        (ButtonInternal.buttonAttributes options ++ attributes)
        children
        |> ButtonItem


{-| Create a link that appears as a button

    Button.linkButton
        { options = [ Button.rolePrimary ]
        , attributes = [ href "#"]
        , children = [ text "Primary" ]
        }


    -- Alternatively
    Button.linkButton
        <| Button.ButtonConfig
            [Button.rolePrimary] [ href "#" ] [text "primary"]


* `buttonConfig` config/params for a link button
  * `options` List of styling options
  * `attributes` List of attributes
  * `children` List of child elements


-}
linkButton : ButtonConfig msg -> Html.Html msg
linkButton buttonConfig =
    linkButtonItem buttonConfig
        |> renderButton


{-| Create a link button that can be composed in a [`buttonGroup`](#buttonGroup)

The parameters are identical as for [`linkButton`](#linkButton)
-}
linkButtonItem : ButtonConfig msg -> ButtonItem msg
linkButtonItem { options, attributes, children } =
    Html.a
        (Attributes.attribute "role" "button"
            :: ButtonInternal.buttonAttributes options
            |> (++) attributes
        )
        children
        |> ButtonItem


renderButton : ButtonItem msg -> Html.Html msg
renderButton (ButtonItem elem) =
    elem


{-| Option to make a button small
-}
small : ButtonOption
small =
    ButtonInternal.SizeButton GridInternal.Small


{-| Option to make a button large
-}
large : ButtonOption
large =
    ButtonInternal.SizeButton GridInternal.Large


{-| Option to color a button to signal a primary action
-}
rolePrimary : ButtonOption
rolePrimary =
    ButtonInternal.RoleButton ButtonInternal.Primary


{-| Option to color a button to signal a secondary action
-}
roleSecondary : ButtonOption
roleSecondary =
    ButtonInternal.RoleButton ButtonInternal.Secondary


{-| Option to indicate a successful or positive action
-}
roleSuccess : ButtonOption
roleSuccess =
    ButtonInternal.RoleButton ButtonInternal.Success


{-| Option to indicate a info action. Typically used for alerts.
-}
roleInfo : ButtonOption
roleInfo =
    ButtonInternal.RoleButton ButtonInternal.Info


{-| Option to indicate an action that should be taken with caution
-}
roleWarning : ButtonOption
roleWarning =
    ButtonInternal.RoleButton ButtonInternal.Warning


{-| Option to indicate an action that is potentially negative or dangerous
-}
roleDanger : ButtonOption
roleDanger =
    ButtonInternal.RoleButton ButtonInternal.Danger


{-| Option to make a button look like a link element
-}
roleLink : ButtonOption
roleLink =
    ButtonInternal.RoleButton ButtonInternal.Link


{-| Option to outline a button to signal a primary action
-}
outlinePrimary : ButtonOption
outlinePrimary =
    ButtonInternal.OutlineButton ButtonInternal.Primary


{-| Option to outline a button to signal a secondary action
-}
outlineSecondary : ButtonOption
outlineSecondary =
    ButtonInternal.OutlineButton ButtonInternal.Secondary


{-| Option to outline an indicatation of a successful or positive action
-}
outlineSuccess : ButtonOption
outlineSuccess =
    ButtonInternal.OutlineButton ButtonInternal.Success


{-| Option to outline an info action. Typically used for alerts.
-}
outlineInfo : ButtonOption
outlineInfo =
    ButtonInternal.OutlineButton ButtonInternal.Info


{-| Option to outline an action that should be taken with caution
-}
outlineWarning : ButtonOption
outlineWarning =
    ButtonInternal.OutlineButton ButtonInternal.Warning


{-| Option to outline an action that is potentially negative or dangerous
-}
outlineDanger : ButtonOption
outlineDanger =
    ButtonInternal.OutlineButton ButtonInternal.Danger


{-| Option to create block level buttons—those that span the full width of a parent
-}
block : ButtonOption
block =
    ButtonInternal.BlockButton




buttonGroupAttributes : List ButtonGroupOption -> List (Html.Attribute msg)
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


buttonGroupClass : ButtonGroupOption -> Maybe (Html.Attribute msg)
buttonGroupClass option =
    case option of
        Vertical ->
            Nothing

        SizeGroup size ->
            Just <| class <| "btn-group-" ++ GridInternal.screenSizeOption size



