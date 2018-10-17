module Bootstrap.Internal.ListGroup exposing (CustomItem(..), Item(..), ItemOption(..), ItemOptions, applyModifier, defaultOptions, itemAttributes, preventClick, renderCustomItem, renderItem)

import Bootstrap.Internal.Role as Role exposing (Role(..))
import Html
import Html.Attributes as Attr exposing (class, classList)


type ItemOption msg
    = Roled Role
    | Active
    | Disabled
    | Action
    | Attrs (List (Html.Attribute msg))


type alias ItemOptions msg =
    { role : Maybe Role
    , active : Bool
    , disabled : Bool
    , action : Bool
    , attributes : List (Html.Attribute msg)
    }


type Item msg
    = Item
        { children : List (Html.Html msg)
        , options : List (ItemOption msg)
        , itemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        }


type CustomItem msg
    = CustomItem
        { options : List (ItemOption msg)
        , children : List (Html.Html msg)
        , itemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
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


{-| Nasty hack to prevent click handler on
-}
preventClick : Html.Attribute a
preventClick =
    Attr.attribute
        "onclick"
        "var event = arguments[0] || window.event; event.preventDefault();"


itemAttributes : ItemOptions msg -> List (Html.Attribute msg)
itemAttributes options =
    [ classList
        [ ( "list-group-item", True )
        , ( "disabled", options.disabled )
        , ( "active", options.active )
        , ( "list-group-item-action", options.action )
        ]
    ]
        ++ [ Attr.disabled options.disabled ]
        ++ (Maybe.map (\r -> [ Role.toClass "list-group-item" r ]) options.role
                |> Maybe.withDefault []
           )
        ++ options.attributes
