module Bootstrap.ButtonGroup
    exposing
        ( group
        , groupItem
        , button
        , linkButton
        , toolbar
        , small
        , large
        , vertical
        , attrs
        , Option
        , ButtonItem
        , GroupItem
        )

{-| Group a series of buttons together on a single line with the button group.

# Button group

@docs group, button, linkButton, ButtonItem

## Group options
@docs small, large, vertical, attrs, Option


# Button toolbar
@docs toolbar, groupItem, GroupItem


-}

import Html
import Html.Attributes exposing (class, classList, attribute)
import Bootstrap.Button as Button
import Bootstrap.Grid.Internal as GridInternal


{-| Opaque type representing the possible styling options for a button group
-}
type Option msg
    = Size GridInternal.ScreenSize
    | Vertical
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { size : Maybe GridInternal.ScreenSize
    , vertical : Bool
    , attributes : List (Html.Attribute msg)
    }


{-| Opaque type representing a button group. Used when composing a button toolbar
-}
type GroupItem msg
    = GroupItem (Html.Html msg)


{-| Opaque type representing a button or link button, for composing button groups
-}
type ButtonItem msg
    = ButtonItem (Html.Html msg)


{-| Create a group of related buttons

    ButtonGroup.group
        [ ButtonGroup.small ]
        [ ButtonGroup.button [ Button.primary ] [ text "Primary" ]
        , ButtonGroup.button [ Button.secondary ] [ text "Secondary" ]
        ]

  * `options` List of styling options
  * `items` List of button items (ref [`buttonItem`](#buttonItem) and [`linkButtonItem`](#linkButtonItem))

-}
group :
    List (Option msg)
    -> List (ButtonItem msg)
    -> Html.Html msg
group options items =
    groupItem options items
        |> renderGroup


{-| Create a button group that can be composed in a [`toolbar`](#toolbar)

The parameters are identical as for [`group`](#group)
-}
groupItem :
    List (Option msg)
    -> List (ButtonItem msg)
    -> GroupItem msg
groupItem options items =
    Html.div
        (groupAttributes options)
        (List.map (\(ButtonItem elem) -> elem) items)
        |> GroupItem


{-| Create a toolbar of buttons by composing button groups. Separate groups by margins on the button groups.

    ButtonGroup.toolbar []
        [ ButtonGroup.groupItem []
            [] -- should contain a list of button items

        , ButtonGroup.groupItem
            [ Button.attrs [ class "ml-2" ] ]
            [] -- should contain a list of button items

        ]


* `attributes` List of attributes to customize the toolbar element
* `items` List of button group (items)
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
linkButton : List (Button.Option msg) -> List (Html.Html msg) -> ButtonItem msg
linkButton options children =
    Button.linkButton options children |> ButtonItem


{-| Option to make all buttons in the given group small
-}
small : Option msg
small =
    Size GridInternal.SM


{-| Option to make all buttons in the given group large
-}
large : Option msg
large =
    Size GridInternal.LG


{-| Option to make all buttons stack vertically for a button group
-}
vertical : Option msg
vertical =
    Vertical


{-| When you need to customize the group element with standard Html.Attribute use this function to create it as a group option
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs =
    Attrs attrs


groupAttributes : List (Option msg) -> List (Html.Attribute msg)
groupAttributes modifiers =
    let
        options =
            List.foldl applyModifier defaultOptions modifiers
    in
        [ attribute "role" "group"
        , classList
            [ ( "btn-group", True )
            , ( "btn-group-vertical", options.vertical )
            ]
        ]
            ++ (case (options.size |> Maybe.andThen GridInternal.screenSizeOption) of
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

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }


defaultOptions : Options msg
defaultOptions =
    { size = Nothing
    , vertical = False
    , attributes = []
    }
