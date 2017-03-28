module Bootstrap.Form.Select
    exposing
        ( select
        , custom
        , item
        , id
        , small
        , large
        , disabled
        , onInput
        , attrs
        , Option
        , Item
        )

{-| This module allows you to create Bootstrap styled `select` elements.


# Creating
@docs select, custom, item, Item

# Options
@docs id, small, large, id, disabled, onInput, attrs, Option

-}

import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Bootstrap.Grid.Internal as GridInternal


{-| Opaque type representing a composable HTML select
-}
type Select msg
    = Select
        { options : List (Option msg)
        , items : List (Item msg)
        }


{-| Opaque type representing a select option element
-}
type Item msg
    = Item (Html.Html msg)


{-| Opaque type representing legal select options
-}
type Option msg
    = Size GridInternal.ScreenSize
    | Id String
    | Custom
    | Disabled Bool
    | OnInput (String -> msg)
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { id : Maybe String
    , size : Maybe GridInternal.ScreenSize
    , disabled : Bool
    , custom : Bool
    , onInput : Maybe (String -> msg)
    , attributes : List (Html.Attribute msg)
    }


{-| Create a select

    Select.select
        [ Select.id "myselect"
        , Select.value "1"
        , Select.onInput MySelectMsg
        ]
        [ Select.item [ id "1"] [ text "Item 1" ]
        , Select.item [ id "2"] [ text "Item 2" ]
        ]

-}
select : List (Option msg) -> List (Item msg) -> Html.Html msg
select options items =
    create options items |> view


{-| Create a select with custom Bootstrap styling to make it look a little bit nicer than the default browser select element
-}
custom : List (Option msg) -> List (Item msg) -> Html.Html msg
custom options =
    view << create (Custom :: options)


create : List (Option msg) -> List (Item msg) -> Select msg
create options items =
    Select
        { options = options
        , items = items
        }


view : Select msg -> Html.Html msg
view (Select { options, items }) =
    Html.select
        (toAttributes options)
        (List.map (\(Item e) -> e) items)


{-| Create a select option element to be passed to a [`select`](#select)
-}
item : List (Html.Attribute msg) -> List (Html.Html msg) -> Item msg
item attributes children =
    Html.option attributes children |> Item


{-| Option to make a select shorter (height)
-}
small : Option msg
small =
    Size GridInternal.SM


{-| Option to make a select taller (height)
-}
large : Option msg
large =
    Size GridInternal.LG


{-| Options/shorthand for setting the id of a select
-}
id : String -> Option msg
id id =
    Id id


{-| Use this function to handle any Html.Attribute option you wish for your select
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs =
    Attrs attrs


{-| Shorthand for assigning an onInput handler for a select
-}
onInput : (String -> msg) -> Option msg
onInput toMsg =
    OnInput toMsg


{-| Shorthand for setting the disabled attribute of a select
-}
disabled : Bool -> Option msg
disabled disabled =
    Disabled disabled


toAttributes : List (Option msg) -> List (Html.Attribute msg)
toAttributes modifiers =
    let
        options =
            List.foldl applyModifier defaultOptions modifiers
    in
        [ if options.custom then
            Attributes.class "custom-select form-control"
          else
            Attributes.class "form-control"
        , Attributes.disabled options.disabled
        ]
            ++ ([ Maybe.map Attributes.id options.id
                , Maybe.andThen sizeAttribute options.size
                , Maybe.map Events.onInput options.onInput
                ]
                    |> List.filterMap identity
               )
            ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { id = Nothing
    , size = Nothing
    , custom = False
    , disabled = False
    , onInput = Nothing
    , attributes = []
    }


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Size size ->
            { options | size = Just size }

        Id id ->
            { options | id = Just id }

        Custom ->
            { options | custom = True }

        Disabled val ->
            { options | disabled = val }

        OnInput onInput ->
            { options | onInput = Just onInput }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }


sizeAttribute : GridInternal.ScreenSize -> Maybe (Html.Attribute msg)
sizeAttribute size =
    Maybe.map
        (\s -> Attributes.class <| "form-control-" ++ s)
        (GridInternal.screenSizeOption size)
