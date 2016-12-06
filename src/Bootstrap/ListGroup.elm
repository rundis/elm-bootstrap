module Bootstrap.ListGroup exposing
    (listGroup)


import Html
import Html.Attributes exposing (class)


type Item msg =
    Item (Html.Html msg)


listGroup : List (Item msg) -> Html.Html msg
listGroup items =
    Html.ul
        [class "list-group"]
        (List.map (\(Item el) -> el) items)


item : List (Html.Html msg) -> Item msg
item children =
    Item <|
        Html.li
            [class "list-group-item"]
            children
