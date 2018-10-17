module Bootstrap.Pagination.Item exposing (item, link, span, active, disabled, attrs, ItemConfig, Item)

{-| When you need more control over pagination items you would use the functions in this module.

@docs item, link, span, active, disabled, attrs, ItemConfig, Item

-}

import Bootstrap.Pagination.Internal as Internal exposing (Status(..))
import Html


{-| Opaque type representing configuration options for an item (regardless of whether its a Link or a Span).
-}
type alias ItemConfig msg =
    Internal.ItemConfig msg


{-| Opaque type representing an pagination item.
-}
type alias Item msg =
    Internal.Item msg


{-| Creates an initial item configuration.
-}
item : ItemConfig msg
item =
    Internal.ItemConfig
        { status = Default
        , attrs = []
        }


{-| Customize the (li) element container for a pagination item.
-}
attrs : List (Html.Attribute msg) -> ItemConfig msg -> ItemConfig msg
attrs attributes ((Internal.ItemConfig rec) as config) =
    Internal.ItemConfig
        { rec | attrs = attributes }


{-| Set this particular item as active/selected in the pagination widget.
-}
active : Bool -> Internal.ItemConfig msg -> Internal.ItemConfig msg
active isActive ((Internal.ItemConfig rec) as config) =
    if isActive then
        Internal.ItemConfig
            { rec | status = Active }

    else
        config


{-| Set this item as disabled. For links it will also set tabindex to -1 and override the clickhandler.
-}
disabled : Bool -> Internal.ItemConfig msg -> Internal.ItemConfig msg
disabled isDisabled ((Internal.ItemConfig rec) as config) =
    if isDisabled then
        Internal.ItemConfig
            { rec | status = Disabled }

    else
        config


{-| Create a pagination link (a) element.
-}
link :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> ItemConfig msg
    -> Item msg
link attributes children config =
    Internal.Item
        { config = config
        , link = Internal.Link Html.a attributes children
        }


{-| Create a pagination span element.
-}
span :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> ItemConfig msg
    -> Item msg
span attributes children config =
    Internal.Item
        { config = config
        , link = Internal.Link Html.span attributes children
        }
