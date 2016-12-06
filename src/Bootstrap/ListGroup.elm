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
        , role
        , active
        , disabled
        , Role(..)
        , ItemClass
        , Item
        , CustomItem
        )

import Html
import Html.Attributes exposing (class, type_)


type ItemClass
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
        , classes : List ItemClass
        , itemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        }


type CustomItem msg
    = CustomItem
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        , classes : List ItemClass
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
        , classes = []
        , attributes = []
        }


anchorItem :
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    , classes : List ItemClass
    }
    -> CustomItem msg
anchorItem { attributes, children, classes } =
    CustomItem
        { itemFn = Html.a
        , attributes = attributes
        , children = children
        , classes = Action :: classes
        }


buttonItem :
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    , classes : List ItemClass
    }
    -> CustomItem msg
buttonItem { attributes, children, classes } =
    CustomItem
        { itemFn = Html.button
        , attributes = attributes ++ [ type_ "button" ]
        , children = children
        , classes = Action :: classes
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


text :
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    , elemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
    }
    -> Html.Html msg
text { elemFn, attributes, children } =
    elemFn
        ([ class "list-group-item-text" ] ++ attributes)
        children



renderItem : Item msg -> Html.Html msg
renderItem (Item { itemFn, attributes, classes, children }) =
    itemFn
        ([ class <| itemClasses classes ] ++ attributes)
        children


renderCustomItem : CustomItem msg -> Html.Html msg
renderCustomItem (CustomItem { itemFn, attributes, classes, children }) =
    itemFn
        ([ class <| itemClasses classes ] ++ attributes)
        children


role : Role -> ItemClass
role r =
    Roled r


active : ItemClass
active =
    Active


disabled : ItemClass
disabled =
    Disabled


itemClasses : List ItemClass -> String
itemClasses classes =
    List.foldl
        (\class classString ->
            String.join " " [ classString, itemClass class ]
        )
        "list-group-item"
        classes


itemClass : ItemClass -> String
itemClass class =
    case class of
        Roled role ->
            roleClass role

        Active ->
            "active"

        Disabled ->
            "disabled"

        Action ->
            "list-group-item-action"


roleClass : Role -> String
roleClass role =
    case role of
        Success ->
            "list-group-item-success"

        Info ->
            "list-group-item-info"

        Warning ->
            "list-group-item-warning"

        Danger ->
            "list-group-item-danger"
