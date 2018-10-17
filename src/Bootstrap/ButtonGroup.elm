module Bootstrap.ButtonGroup exposing
    ( button, linkButton, radioButton, checkboxButton
    , buttonGroup, linkButtonGroup, radioButtonGroup, checkboxButtonGroup
    , ButtonItem, LinkButtonItem, RadioButtonItem, CheckboxButtonItem
    , small, large, vertical, attrs, Option
    , toolbar, buttonGroupItem, linkButtonGroupItem, radioButtonGroupItem
    , checkboxButtonGroupItem, GroupItem
    )

{-| Group a series of buttons together on a single line with the button group.


# Button group

@docs button, linkButton, radioButton, checkboxButton
@docs buttonGroup, linkButtonGroup, radioButtonGroup, checkboxButtonGroup
@docs ButtonItem, LinkButtonItem, RadioButtonItem, CheckboxButtonItem


## Group options

@docs small, large, vertical, attrs, Option


# Button toolbar

@docs toolbar, buttonGroupItem, linkButtonGroupItem, radioButtonGroupItem
@docs checkboxButtonGroupItem, GroupItem

-}

import Bootstrap.Button as Button
import Bootstrap.General.Internal exposing (ScreenSize(..), screenSizeOption)
import Html
import Html.Attributes as Attributes exposing (attribute, class, classList)


{-| Opaque type representing the possible styling options for a button group
-}
type Option msg
    = Size ScreenSize
    | Vertical
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { size : Maybe ScreenSize
    , vertical : Bool
    , attributes : List (Html.Attribute msg)
    }


{-| Opaque type representing a button group. Used when composing a button toolbar
-}
type GroupItem msg
    = GroupItem (Html.Html msg)


{-| Opaque type representing a button, for composing button groups
-}
type ButtonItem msg
    = ButtonItem (Html.Html msg)


{-| Opaque type representing a link button, for composing button groups
-}
type LinkButtonItem msg
    = LinkButtonItem (Html.Html msg)


{-| Opaque type representing a radio button, for composing button groups
-}
type RadioButtonItem msg
    = RadioButtonItem (Html.Html msg)


{-| Opaque type representing a checkbox button, for composing button groups
-}
type CheckboxButtonItem msg
    = CheckboxButtonItem (Html.Html msg)


{-| Create a group of related buttons

    ButtonGroup.buttonGroup
        [ ButtonGroup.small ]
        [ ButtonGroup.button [ Button.primary ] [ text "Primary" ]
        , ButtonGroup.button [ Button.secondary ] [ text "Secondary" ]
        ]

  - `options` List of styling options
  - `items` List of button items (ref [`buttonItem`](#buttonItem) and [`linkButtonItem`](#linkButtonItem))

-}
buttonGroup : List (Option msg) -> List (ButtonItem msg) -> Html.Html msg
buttonGroup options items =
    buttonGroupItem options items
        |> renderGroup


{-| Create a group of related link buttons. Parameters are identical to [`buttonGroup`](#buttonGroup)
-}
linkButtonGroup : List (Option msg) -> List (LinkButtonItem msg) -> Html.Html msg
linkButtonGroup options items =
    linkButtonGroupItem options items
        |> renderGroup


{-| Create a group of mutually-exclusive radio buttons. Parameters are identical to [`buttonGroup`](#buttonGroup)

    ButtonGroup.radioButtonGroup
        [ ButtonGroup.small ]
        [ ButtonGroup.radioButton True [ Button.primary ] [ text "On" ]
        , ButtonGroup.radioButton False [ Button.primary ] [ text "Off" ]
        ]

-}
radioButtonGroup : List (Option msg) -> List (RadioButtonItem msg) -> Html.Html msg
radioButtonGroup options items =
    radioButtonGroupItem options items
        |> renderGroup


{-| Create a group of related checkbox buttons. Parameters are identical to [`buttonGroup`](#buttonGroup)

    ButtonGroup.checkboxButtonGroup
        [ ButtonGroup.small ]
        [ ButtonGroup.checkboxButton True [ Button.primary ] [ text "Bold" ]
        , ButtonGroup.checkboxButton True [ Button.primary ] [ text "Italic" ]
        ]

-}
checkboxButtonGroup : List (Option msg) -> List (CheckboxButtonItem msg) -> Html.Html msg
checkboxButtonGroup options items =
    checkboxButtonGroupItem options items
        |> renderGroup


{-| Create a button group that can be composed in a [`toolbar`](#toolbar)

The parameters are identical as for [`buttonGroup`](#buttonGroup)

-}
buttonGroupItem : List (Option msg) -> List (ButtonItem msg) -> GroupItem msg
buttonGroupItem options items =
    Html.div
        (groupAttributes False options)
        (List.map (\(ButtonItem elem) -> elem) items)
        |> GroupItem


{-| The same as [`buttonGroupItem`](#buttonGroupItem), but for link buttons
-}
linkButtonGroupItem : List (Option msg) -> List (LinkButtonItem msg) -> GroupItem msg
linkButtonGroupItem options items =
    Html.div
        (groupAttributes False options)
        (List.map (\(LinkButtonItem elem) -> elem) items)
        |> GroupItem


{-| The same as [`buttonGroupItem`](#buttonGroupItem), but for radio buttons
-}
radioButtonGroupItem : List (Option msg) -> List (RadioButtonItem msg) -> GroupItem msg
radioButtonGroupItem options items =
    Html.div
        (groupAttributes True options)
        (List.map (\(RadioButtonItem elem) -> elem) items)
        |> GroupItem


{-| The same as [`buttonGroupItem`](#buttonGroupItem), but for checkbox buttons
-}
checkboxButtonGroupItem : List (Option msg) -> List (CheckboxButtonItem msg) -> GroupItem msg
checkboxButtonGroupItem options items =
    Html.div
        (groupAttributes True options)
        (List.map (\(CheckboxButtonItem elem) -> elem) items)
        |> GroupItem


{-| Create a toolbar of buttons by composing button groups. Separate groups by margins on the button groups.

    ButtonGroup.toolbar []
        [ ButtonGroup.groupItem []
            []

        -- should contain a list of button items
        , ButtonGroup.groupItem
            [ Button.attrs [ class "ml-2" ] ]
            []

        -- should contain a list of button items
        ]

  - `attributes` List of attributes to customize the toolbar element
  - `items` List of button group (items)

-}
toolbar : List (Html.Attribute msg) -> List (GroupItem msg) -> Html.Html msg
toolbar attributes items =
    Html.div
        ([ attribute "role" "toolbar"
         , class "btn-toolbar"
         ]
            ++ attributes
        )
        (List.map renderGroup items)


renderGroup : GroupItem msg -> Html.Html msg
renderGroup (GroupItem elem) =
    elem


{-| Create a button than can be composed in a button group
-}
button : List (Button.Option msg) -> List (Html.Html msg) -> ButtonItem msg
button options children =
    Button.button options children |> ButtonItem


{-| Create a linkButton that can be composed in a button group
-}
linkButton : List (Button.Option msg) -> List (Html.Html msg) -> LinkButtonItem msg
linkButton options children =
    Button.linkButton options children |> LinkButtonItem


{-| Create a radioButton that can be composed in a button group
-}
radioButton : Bool -> List (Button.Option msg) -> List (Html.Html msg) -> RadioButtonItem msg
radioButton checked options children =
    Button.radioButton checked options children |> RadioButtonItem


{-| Create a checkboxButton that can be composed in a button group
-}
checkboxButton : Bool -> List (Button.Option msg) -> List (Html.Html msg) -> CheckboxButtonItem msg
checkboxButton checked options children =
    Button.checkboxButton checked options children |> CheckboxButtonItem


{-| Option to make all buttons in the given group small
-}
small : Option msg
small =
    Size SM


{-| Option to make all buttons in the given group large
-}
large : Option msg
large =
    Size LG


{-| Option to make all buttons stack vertically for a button group
-}
vertical : Option msg
vertical =
    Vertical


{-| When you need to customize the group element with standard Html.Attribute use this function to create it as a group option
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    Attrs attrs_


groupAttributes : Bool -> List (Option msg) -> List (Html.Attribute msg)
groupAttributes toggle modifiers =
    let
        options =
            List.foldl applyModifier defaultOptions modifiers
    in
    [ attribute "role" "group"
    , classList
        [ ( "btn-group", True )
        , ( "btn-group-toggle", toggle )
        , ( "btn-group-vertical", options.vertical )
        ]

    -- data-toggle is needed to display radio buttons correctly (by hiding the actual radio input)
    , attribute "data-toggle" "buttons"
    ]
        ++ (case options.size |> Maybe.andThen screenSizeOption of
                Just s ->
                    [ class <| "btn-group-" ++ s ]

                Nothing ->
                    []
           )
        ++ options.attributes


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Size size ->
            { options | size = Just size }

        Vertical ->
            { options | vertical = True }

        Attrs attrs_ ->
            { options | attributes = options.attributes ++ attrs_ }


defaultOptions : Options msg
defaultOptions =
    { size = Nothing
    , vertical = False
    , attributes = []
    }
