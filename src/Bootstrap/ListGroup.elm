module Bootstrap.ListGroup
    exposing
        ( ul
        , li
        , custom
        , anchor
        , button
        , roleSuccess
        , roleInfo
        , roleWarning
        , roleDanger
        , active
        , disabled
        , attr
        , ItemOption
        , Item
        , CustomItem
        )
{-| List groups are a flexible and powerful component for displaying a series of content. List group items can be modified and extended to support just about any content within. They can also be used as navigation with the right modifier class

# Simple lists
@docs ul, li, Item


# Custom lists
@docs custom, anchor, button, CustomItem


# Options
@docs roleSuccess, roleSuccess, roleInfo, roleWarning, roleDanger, active, disabled, attr, ItemOption


-}
import Html
import Html.Attributes as Attr exposing (class, type_)


{-| Opaque type representing configuration options for a list item
-}
type ItemOption msg
    = Roled Role
    | Active
    | Disabled
    | Action
    | Attr (Html.Attribute msg)


type Role
    = Success
    | Info
    | Warning
    | Danger


{-| Opaque type representing a list item in a ul based list group
-}
type Item msg
    = Item
        { children : List (Html.Html msg)
        , options : List (ItemOption msg)
        , itemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        }


{-| Opaque type representing an item in a custom list group
-}
type CustomItem msg
    = CustomItem
        { options : List (ItemOption msg)
        , children : List (Html.Html msg)
        , itemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        }


{-| A simple list group based on an ul element

    ListGroup.ul
        [ ListGroup.li [ ListGroup.active ] [ text "Item 1"]
        , ListGroup.li [ ] [ text "Item 2" ]
        ]
-}
ul : List (Item msg) -> Html.Html msg
ul items =
    Html.ul
        [ class "list-group" ]
        (List.map renderItem items)


{-| Composable li element for an ul based list group
-}
li : List (ItemOption msg) -> List (Html.Html msg) -> Item msg
li options children =
    Item
        { itemFn = Html.li
        , children = children
        , options = options
        }


{-| Create a custom List group
    ListGroup.custom
        [ ListGroup.button
            [ ListGroup.attr <| onClick "MyItem1Msg"
            , ListGroup.roleInfo
            ]
            [ text "List item 1" ]
        , ListGroup.button
            [ ListGroup.attr <| onClick "MyItem2Msg"
            , ListGroup.roleWarning
            ]
            [ text "List item 2" ]
        ]

-}
custom : List (CustomItem msg) -> Html.Html msg
custom items =
    Html.div
        [ class "list-group" ]
        (List.map renderCustomItem items)


{-| Create a composable anchor list item for use in a custom list

* `options` List of options to configure the list item
* `children` List of child elements
-}
anchor :
    List (ItemOption msg)
    -> List (Html.Html msg)
    -> CustomItem msg
anchor options children =
    CustomItem
        { itemFn = Html.a
        , children = children
        , options = Action :: options
        }

{-| Create a composable button list item for use in a custom list

* `options` List of options to configure the list item
* `children` List of child elements
-}
button :
    List (ItemOption msg)
    -> List (Html.Html msg)
    -> CustomItem msg
button options children =
    CustomItem
        { itemFn = Html.button
        , children = children
        , options = Action :: (options ++ [ Attr <| type_ "button" ])
        }




renderItem : Item msg -> Html.Html msg
renderItem (Item { itemFn, options, children }) =
    itemFn
        (itemAttributes options)
        children


renderCustomItem : CustomItem msg -> Html.Html msg
renderCustomItem (CustomItem { itemFn, options, children }) =
    itemFn
        (itemAttributes options)
        children


{-| Option to style a list item with success colors
-}
roleSuccess : ItemOption msg
roleSuccess =
    Roled Success


{-| Option to style a list item with info colors
-}
roleInfo : ItemOption msg
roleInfo =
    Roled Info


{-| Option to style a list item with warning colors
-}
roleWarning : ItemOption msg
roleWarning =
    Roled Warning


{-| Option to style a list item with danger colors
-}
roleDanger : ItemOption msg
roleDanger =
    Roled Danger


{-| Option to mark a list item as active
-}
active : ItemOption msg
active =
    Active


{-| Option to disable a list item
-}
disabled : ItemOption msg
disabled =
    Disabled


{-| Use this function to supply any additional Hmtl.Attribute you need for your list items
-}
attr : Html.Attribute msg -> ItemOption msg
attr attr =
    Attr attr


itemAttributes : List (ItemOption msg) -> List (Html.Attribute msg)
itemAttributes options =
    let
        hasDisabled =
            List.any (\opt -> opt == Disabled) options
    in
        [ class "list-group-item"
        , Attr.disabled hasDisabled
        ]
            ++ List.map itemClass options


itemClass : (ItemOption msg) -> Html.Attribute msg
itemClass option =
        case option of
            Roled role ->
                class <| roleOption role

            Active ->
                class <| "active"

            Disabled ->
                class <| "disabled"

            Action ->
                class <| "list-group-item-action"

            Attr attr ->
                attr


roleOption : Role -> String
roleOption role =
    case role of
        Success ->
            "list-group-item-success"

        Info ->
            "list-group-item-info"

        Warning ->
            "list-group-item-warning"

        Danger ->
            "list-group-item-danger"
