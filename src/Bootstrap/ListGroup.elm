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
        , attrs
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
@docs roleSuccess, roleSuccess, roleInfo, roleWarning, roleDanger, active, disabled, attrs, ItemOption


-}

import Html
import Html.Attributes as Attr exposing (class, classList, type_)


{-| Opaque type representing configuration options for a list item
-}
type ItemOption msg
    = Roled Role
    | Active
    | Disabled
    | Action
    | Attrs (List (Html.Attribute msg))


type Role
    = Success
    | Info
    | Warning
    | Danger


type alias ItemOptions msg =
    { role : Maybe Role
    , active : Bool
    , disabled : Bool
    , action : Bool
    , attributes : List (Html.Attribute msg)
    }


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
        , options = Action :: (options ++ [ Attrs [ type_ "button" ] ])
        }


renderItem : Item msg -> Html.Html msg
renderItem (Item { itemFn, options, children }) =
    itemFn
        (List.foldl applyModifier defaultOptions options |> itemAttributes)
        children


renderCustomItem : CustomItem msg -> Html.Html msg
renderCustomItem (CustomItem { itemFn, options, children }) =
    itemFn
        (List.foldl applyModifier defaultOptions options |> itemAttributes)
        children


defaultOptions : ItemOptions msg
defaultOptions =
    { role = Nothing
    , active = False
    , disabled = False
    , action = False
    , attributes = []
    }


applyModifier : ItemOption msg -> ItemOptions msg -> ItemOptions msg
applyModifier modifier options =
    case modifier of
        Roled role ->
            { options | role = Just role }

        Action ->
            { options | action = True }

        Disabled ->
            { options | disabled = True }

        Active ->
            { options | active = True }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }


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
attrs : List (Html.Attribute msg) -> ItemOption msg
attrs attrs =
    Attrs attrs


itemAttributes : ItemOptions msg -> List (Html.Attribute msg)
itemAttributes options =
    [ classList
        [ ( "list-group-item", True )
        , ( "disabled", options.disabled )
        , ( "active", options.active )
        , ( "action", options.action )
        ]
    ]
        ++ [ Attr.disabled options.disabled ]
        ++ (Maybe.map (\r -> [ roleClass r ]) options.role
                |> Maybe.withDefault []
           )


roleClass : Role -> Html.Attribute msg
roleClass role =
    class <|
        case role of
            Success ->
                "list-group-item-success"

            Info ->
                "list-group-item-info"

            Warning ->
                "list-group-item-warning"

            Danger ->
                "list-group-item-danger"
