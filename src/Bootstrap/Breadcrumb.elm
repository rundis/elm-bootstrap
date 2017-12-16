module Bootstrap.Breadcrumb
    exposing
        ( container
        , item
        , Item
        )

{-| Indicate the current page's location within a navigational hierarchy that automatically adds separators via CSS.

    Breadcrumb.container
        [ Breadcrumb.item [] [ a [ href "#home" ] [ text "home" ] ]
        , Breadcrumb.item [] [ text "page" ]
        ]


# Breadcrumb

@docs Item, item, container

-}

import Html
import Html.Attributes


{-| Opaque type representing an item in the breadcrumb trail.
-}
type Item msg
    = Item (List (Html.Attribute msg)) (List (Html.Html msg))


{-| Create a breadcrumb item.

  - `attributes` List of attributes
  - `children` List of child elements

-}
item : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
item attributes children =
    Item attributes children


{-| Create a breadcrumb container.

  - `items` List of breadcrumb items

-}
container : List (Item msg) -> Html.Html msg
container items =
    case items of
        [] ->
            Html.text ""

        _ ->
            Html.nav [ Html.Attributes.attribute "aria-label" "breadcrumb", Html.Attributes.attribute "role" "navigation" ]
                [ Html.ol [ Html.Attributes.class "breadcrumb" ] <| toListItems items ]


toListItems : List (Item msg) -> List (Html.Html msg)
toListItems items =
    case items of
        [] ->
            []

        [ Item attributes children ] ->
            [ Html.li (attributes ++ [ (Html.Attributes.attribute "aria-current" "page"), Html.Attributes.class "breadcrumb-item active" ]) children ]

        (Item attributes children) :: rest ->
            [ Html.li (attributes ++ [ Html.Attributes.class "breadcrumb-item" ]) children ] ++ (toListItems rest)
