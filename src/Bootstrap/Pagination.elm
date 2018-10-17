module Bootstrap.Pagination exposing
    ( defaultConfig, view
    , ariaLabel, small, large, attrs, listAttrs, align, items, Config
    , itemsList, ListItem, ListConfig
    )

{-| Module for creating a Boostrap Pagination control, to indicate a series of related content exists across multiple pages.


## Simple list example

    import Bootstrap.HAlign as HAlign
    import Bootstrap.Pagination as Pagination

    simplePaginationList : Model -> Html Msg
    simplePaginationList model =
        Pagination.defaultConfig
            |> Pagination.ariaLabel "Pagination"
            |> Pagination HAlign.centerXs
            |> Pagination.large
            |> Pagination.itemsList
                { selectedMsg = PaginationMsg
                , prevItem = Just <| Pagination.ListItem [] [ text "Previous" ]
                , nextItem = Just <| Pagination.ListItem [] [ text "Next" ]
                , activeIdx = model.activePageIdx
                , data = [ 1, 2, 3, 4, 5 ] -- You'd typically generate this from your model somehow !
                , itemFn = \idx _ -> Pagination.ListItem [] [ text <| toString (idx + 1) ]
                , urlFn = \idx _ -> "#/pages/" ++ toString (idx + 1)
                }
            |> Pagination.view


## Customized pagination

    import Bootstrap.HAlign as HAlign
    import Bootstrap.Pagination as Item


    -- Not you'll also need to fill in the pagination logic yourselves (not shown for brevity)
    customPagination : Model -> Html Msg
    customPagination model =
        let
            myData =
                [ { icon = "car", name = "Car" }
                , { icon = "bus", name = "Bus" }
                , { icon = "train", name = "Train" }
                ]
        in
        div []
            [ h1 [] [ text "Pagination" ]
            , Pagination.defaultConfig
                |> Pagination.ariaLabel "Pagination"
                |> Pagination.align HAlign.centerXs
                |> Pagination.large
                |> Pagination.items
                    ([ Item.item
                        |> Item.span [ class "custom-page-item" ]
                            [ span
                                [ class "fa fa-fast-backward"
                                , attribute "aria-hidden" "true"
                                ]
                                []
                            , span [ class "sr-only" ]
                                [ text "First page" ]
                            ]
                     , Item.item
                        |> Item.span [ class "custom-page-item" ]
                            [ span
                                [ class "fa fa-arrow-left"
                                , attribute "aria-hidden" "true"
                                ]
                                []
                            , span [ class "sr-only" ] [ text "Previous" ]
                            ]
                     ]
                        ++ List.indexedMap
                            (\idx item ->
                                Item.item
                                    |> Item.active (idx == model.activePageIdx)
                                    |> Item.span [ class "custom-page-item" ]
                                        [ span
                                            [ class <| "fa fa-" ++ item.icon
                                            , attribute "aria-hidden" "true"
                                            ]
                                            []
                                        , span [ class "sr-only" ] [ text item.name ]
                                        ]
                            )
                            myData
                        ++ [ Item.item
                                |> Item.span [ class "custom-page-item" ]
                                    [ span
                                        [ class "fa fa-arrow-right"
                                        , attribute "aria-hidden" "true"
                                        ]
                                        []
                                    , span [ class "sr-only" ] [ text "Next" ]
                                    ]
                           , Item.item
                                |> Item.span [ class "custom-page-item" ]
                                    [ span
                                        [ class "fa fa-fast-forward"
                                        , attribute "aria-hidden" "true"
                                        ]
                                        []
                                    , span [ class "sr-only" ] [ text "Last page" ]
                                    ]
                           ]
                    )
                |> Pagination.view
            ]

@docs defaultConfig, view


## Customization

@docs ariaLabel, small, large, attrs, listAttrs, align, items, Config


## Simple pagination lists

@docs itemsList, ListItem, ListConfig

-}

import Bootstrap.General.HAlign as General
import Bootstrap.General.Internal exposing (hAlignClass)
import Bootstrap.Pagination.Internal as Internal
import Bootstrap.Pagination.Item as Item
import Html
import Html.Attributes exposing (attribute, class)
import Html.Events exposing (onClick)


{-| Opaque type holding the configuration options for a pagination widget.
-}
type Config msg
    = Config (ConfigRec msg)


type alias ConfigRec msg =
    { size : Size
    , ariaLabel : Maybe String
    , hAlign : Maybe General.HAlign
    , attrs : List (Html.Attribute msg)
    , listAttrs : List (Html.Attribute msg)
    , items : List (Item.Item msg)
    }


type Size
    = Default
    | Small
    | Large


{-| Provides a default configuration which you can configure further using the various customization functions.
-}
defaultConfig : Config msg
defaultConfig =
    Config <|
        { size = Default
        , ariaLabel = Nothing
        , hAlign = Nothing
        , attrs = []
        , listAttrs = []
        , items = []
        }


{-| Configure the pagination and its control to be larger.
-}
large : Config msg -> Config msg
large config =
    size Large config


{-| Configure the pagination and its control to be smaller.
-}
small : Config msg -> Config msg
small config =
    size Small config


{-| Provide screen readers a helpful descriptive text for your pagination widget.
-}
ariaLabel : String -> Config msg -> Config msg
ariaLabel label (Config configRec) =
    Config <|
        { configRec | ariaLabel = Just label }


size : Size -> Config msg -> Config msg
size s (Config configRec) =
    Config <|
        { configRec | size = s }


{-| Customize the root nav element with std. Html.Attribute(s) for the pagination.
-}
attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs xs (Config configRec) =
    Config <|
        { configRec | attrs = xs }


{-| Customize the pagination ul element with std. Html.Attribute(s) for the pagination.
-}
listAttrs : List (Html.Attribute msg) -> Config msg -> Config msg
listAttrs xs (Config configRec) =
    Config <|
        { configRec | listAttrs = xs }


{-| Customize the horizontal alignment of the pagination components.

    import Bootstrap.Pagination as Pagination
    import Bootstrap.General.HAlign as HAlign


    Pagination.defaultConfig
        |> Pagination.align HAlign.centerXs

-}
align : General.HAlign -> Config msg -> Config msg
align hAlign (Config configRec) =
    Config <|
        { configRec | hAlign = Just hAlign }


{-| Configure the items to be shown in the pagination.
-}
items : List (Item.Item msg) -> Config msg -> Config msg
items xs (Config configRec) =
    Config <|
        { configRec | items = xs }


{-| Record type for providing configuration for a simple pagination list with default behaviours/

  - **selectedMsg** - A msg that you use to keep track of the activeIdx in your model
  - **prevItem** - When provided will render a previous item link before the individual page items.
  - **nextItem** - When provided will render a next item link after the individual page items.
  - **activeIdx** - Index of currently active item in the items list.
  - **data** - List of actual data items (of any type)
  - **itemFn** - Callback function to allow you to specify what's rendered for the paginations individual page items
  - **urlFn** - Callback function to allow you to specify the href url for an individual pagination item

-}
type alias ListConfig a msg =
    { selectedMsg : Int -> msg
    , prevItem : Maybe (ListItem msg)
    , nextItem : Maybe (ListItem msg)
    , activeIdx : Int
    , data : List a
    , itemFn : Int -> a -> ListItem msg
    , urlFn : Int -> a -> String
    }


{-| Record alias for describing a pagination page item.
-}
type alias ListItem msg =
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


{-| Create a simple default pagination list.

    import Bootstrap.Pagination as Pagination

    viewPagination : Model -> Html Msg
    viewPagination model =
        Pagination.defaultConfig
            |> Pagination.itemsList
                { selectedMsg = PaginationMsg
                , prevItem = Just <| Pagination.ListItem [] [ text "Previous" ]
                , nextItem = Just <| Pagination.ListItem [] [ text "Next" ]
                , activeIdx = model.activePageIdx
                , data = [ 1, 2, 3, 4, 5 ] -- You'd typically generate this from your model somehow !
                , itemFn = \idx _ -> Pagination.ListItem [] [ text <| toString (idx + 1) ]
                , urlFn = \idx _ -> "#/pages/" ++ toString (idx + 1)
                }

-}
itemsList : ListConfig a msg -> Config msg -> Config msg
itemsList conf config =
    let
        byIdx idx =
            List.indexedMap Tuple.pair conf.data
                |> List.filter (\( i, item ) -> i == idx)
                |> List.map Tuple.second
                |> List.head

        count =
            List.length conf.data

        prevItem =
            if conf.activeIdx > 0 then
                byIdx <| conf.activeIdx - 1

            else
                Nothing

        nextItem =
            if conf.activeIdx < (count - 1) then
                byIdx <| conf.activeIdx + 1

            else
                Nothing
    in
    ([ Maybe.map
        (\{ attributes, children } ->
            Item.item
                |> Item.disabled (count < 2 || conf.activeIdx < 1)
                |> Item.link
                    ((case prevItem of
                        Just item ->
                            [ Html.Attributes.href <| conf.urlFn (conf.activeIdx - 1) item
                            , onClick <| conf.selectedMsg (conf.activeIdx - 1)
                            ]

                        Nothing ->
                            [ Html.Attributes.href "#" ]
                     )
                        ++ attributes
                    )
                    children
        )
        conf.prevItem
     ]
        ++ List.indexedMap
            (\idx item ->
                let
                    { attributes, children } =
                        conf.itemFn idx item
                in
                Item.item
                    |> Item.disabled (idx == conf.activeIdx)
                    |> Item.link
                        ([ Html.Attributes.href <| conf.urlFn idx item
                         , onClick <| conf.selectedMsg idx
                         ]
                            ++ attributes
                        )
                        children
                    |> Just
            )
            conf.data
        ++ [ Maybe.map
                (\{ attributes, children } ->
                    Item.item
                        |> Item.disabled (count < 2 || conf.activeIdx > (count - 2))
                        |> Item.link
                            ((case nextItem of
                                Just item ->
                                    [ Html.Attributes.href <| conf.urlFn (conf.activeIdx + 1) item
                                    , onClick <| conf.selectedMsg (conf.activeIdx + 1)
                                    ]

                                Nothing ->
                                    [ Html.Attributes.href "#" ]
                             )
                                ++ attributes
                            )
                            children
                )
                conf.nextItem
           ]
    )
        |> List.filterMap identity
        |> (\xs -> items xs config)


{-| Takes a pagination config and renders it to std Elm Html.
-}
view : Config msg -> Html.Html msg
view (Config configRec) =
    Html.nav
        (navAttributes configRec)
        [ Html.ul
            (listAttributes configRec)
            (List.map Internal.viewItem configRec.items)
        ]


navAttributes : ConfigRec msg -> List (Html.Attribute msg)
navAttributes config =
    case config.ariaLabel of
        Just label ->
            [ attribute "aria-label" label ]

        Nothing ->
            []


listAttributes : ConfigRec msg -> List (Html.Attribute msg)
listAttributes config =
    [ class "pagination" ]
        ++ sizeClass config.size
        ++ (case config.hAlign of
                Just align_ ->
                    [ hAlignClass align_ ]

                Nothing ->
                    []
           )
        ++ config.listAttrs


sizeClass : Size -> List (Html.Attribute msg)
sizeClass size_ =
    case size_ of
        Large ->
            [ class "pagination-lg" ]

        Small ->
            [ class "pagination-sm" ]

        Default ->
            []
