module Bootstrap.ListGroup
    exposing
        ( list
        , customList
        , item
        , anchorItem
        , buttonItem
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        , text
        , roleSuccess
        , roleInfo
        , roleWarning
        , roleDanger
        , active
        , disabled
        , ItemOption
        , Item
        , CustomItem
        )

import Html
import Html.Attributes exposing (class, type_)


type ItemOption
    = Roled Role
    | Active
    | Disabled
    | Action


type Role
    = Success
    | Info
    | Warning
    | Danger


type Item msg
    = Item
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        , options : List ItemOption
        , itemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        }


type CustomItem msg
    = CustomItem
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        , options : List ItemOption
        , itemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        }


list : List (Item msg) -> Html.Html msg
list items =
    Html.ul
        [ class "list-group" ]
        (List.map renderItem items)


customList : List (CustomItem msg) -> Html.Html msg
customList items =
    Html.div
        [ class "list-group" ]
        (List.map renderCustomItem items)


item : List (Html.Html msg) -> Item msg
item children =
    Item
        { itemFn = Html.li
        , children = children
        , options = []
        , attributes = []
        }


anchorItem :
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    , options : List ItemOption
    }
    -> CustomItem msg
anchorItem { attributes, children, options } =
    CustomItem
        { itemFn = Html.a
        , attributes = attributes
        , children = children
        , options = Action :: options
        }


buttonItem :
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    , options : List ItemOption
    }
    -> CustomItem msg
buttonItem { attributes, children, options } =
    CustomItem
        { itemFn = Html.button
        , attributes = attributes ++ [ type_ "button" ]
        , children = children
        , options = Action :: options
        }


h1 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h1 attributes children =
    heading Html.h1 attributes children


h2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h2 attributes children =
    heading Html.h2 attributes children


h3 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h3 attributes children =
    heading Html.h3 attributes children


h4 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h4 attributes children =
    heading Html.h4 attributes children


h5 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h5 attributes children =
    heading Html.h5 attributes children


h6 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h6 attributes children =
    heading Html.h6 attributes children


heading :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
heading elemFn attributes children =
    elemFn
        ([ class "list-group-item-heading" ] ++ attributes)
        children


text : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
text attributes children =
    Html.p
        ([ class "list-group-item-text" ] ++ attributes)
        children


renderItem : Item msg -> Html.Html msg
renderItem (Item { itemFn, attributes, options, children }) =
    itemFn
        (itemAttributes options ++ attributes)
        children


renderCustomItem : CustomItem msg -> Html.Html msg
renderCustomItem (CustomItem { itemFn, attributes, options, children }) =
    itemFn
        (itemAttributes options ++ attributes)
        children


roleSuccess : ItemOption
roleSuccess =
    Roled Success


roleInfo : ItemOption
roleInfo =
    Roled Info


roleWarning : ItemOption
roleWarning =
    Roled Warning


roleDanger : ItemOption
roleDanger =
    Roled Danger


active : ItemOption
active =
    Active


disabled : ItemOption
disabled =
    Disabled


itemAttributes : List ItemOption -> List (Html.Attribute msg)
itemAttributes options =
    class "list-group-item" :: List.map itemClass options


itemClass : ItemOption -> Html.Attribute msg
itemClass option =
    class <|
        case option of
            Roled role ->
                roleOption role

            Active ->
                "active"

            Disabled ->
                "disabled"

            Action ->
                "list-group-item-action"


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
