module Bootstrap.Tab exposing
    ( view, config, items, initialState, customInitialState, Config, State
    , pills, withAnimation, justified, fill, center, right, attrs, useHash, Option
    , item, link, pane, Item, Link, Pane
    , subscriptions
    )

{-| Use tabs to create tabbable regions. Tabs uses view state, so there is a little bit of wiring needed to use them.

    -- example with animation, you can drop the subscription part when not using animations
    type alias Model =
        { tabState : Tab.State }

    init : ( Model, Cmd Msg )
    init =
        ( { tabState = Tab.initalState }, Cmd.none )

    type Msg
        = TabMsg Tab.State

    update : Msg -> Model -> ( Model, Cmd msg )
    update msg model =
        case msg of
            TabMsg state ->
                ( { model | tabState = state }
                , Cmd.none
                )

    view : Model -> Html msg
    view model =
        Tab.config TabMsg
            |> Tab.withAnimation
            -- remember to wire up subscriptions when using this option
            |> Tab.right
            |> Tab.items
                [ Tab.item
                    { id = "tabItem1"
                    , link = Tab.link [] [ text "Tab 1" ]
                    , pane = Tab.pane [] [ text "Tab 1 Content" ]
                    }
                , Tab.item
                    { id = "tabItem2"
                    , link = Tab.link [] [ text "Tab 2" ]
                    , pane = Tab.pane [] [ text "Tab 2 Content" ]
                    }
                ]
            |> Tab.view model.tabState

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Tab.subscriptions model.tabState TabMsg


# Tabs

@docs view, config, items, initialState, customInitialState, Config, State


# Options

@docs pills, withAnimation, justified, fill, center, right, attrs, useHash, Option


# Tab items

@docs item, link, pane, Item, Link, Pane


# With animations

@docs subscriptions

-}

import Browser.Events
import Html
import Html.Attributes as Attributes exposing (class, classList, href, style)
import Html.Events exposing (custom, on, onClick)
import Json.Decode as Json


{-| Opaque type representing the view state of the tabs control
-}
type State
    = State
        { activeTab : Maybe String
        , visibility : Visibility
        }


{-| Opaque type representing customization options for a tabs control
-}
type Option msg
    = Layout TabLayout
    | Attrs (List (Html.Attribute msg))


type TabLayout
    = Center
    | Right
    | Fill
    | Justified


type Visibility
    = Hidden
    | Start
    | Showing


type alias Options msg =
    { layout : Maybe TabLayout
    , isPill : Bool
    , attributes : List (Html.Attribute msg)
    }


{-| Configuration for a tabs control

  - `toMsg` Message constructor function used for transitioning view state
  - `options` Customization options for the tabs control
  - `withAnimation` Option to enable a simple fade in animation for tabs.
  - `items` List of tab items

**NOTE** When using animations you must also remember to set up [`subscriptions`](#subscriptions)

-}
type Config msg
    = Config (ConfigRec msg)


type alias ConfigRec msg =
    { toMsg : State -> msg
    , items : List (Item msg)
    , withAnimation : Bool
    , layout : Maybe TabLayout
    , isPill : Bool
    , attributes : List (Html.Attribute msg)
    , useHash : Bool
    }


{-| Opaque type representing a tab item
-}
type Item msg
    = Item
        { id : String
        , link : Link msg
        , pane : Pane msg
        }


{-| Opaque type representing a tab item link
-}
type Link msg
    = Link
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


{-| Opaque type representing a tab item pane
-}
type Pane msg
    = Pane
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


{-| When using animations you **must** remember to wire up this function to your main subscriptions

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Sub.batch
            [ Tab.subscriptions model.tabState TabMsg

            --  ...other subscriptions you might have
            ]

-}
subscriptions : State -> (State -> msg) -> Sub msg
subscriptions (State state) toMsg =
    case state.visibility of
        Start ->
            Browser.Events.onAnimationFrame
                (\_ -> toMsg <| State <| { state | visibility = Showing })

        _ ->
            Sub.none


{-| Use this function to create the inital state for the tabs control
-}
initialState : State
initialState =
    State
        { activeTab = Nothing
        , visibility = Showing
        }


{-| Use this function if you want to initialize your tabs control with a specific tab selected.

**NOTE: ** Should you specify an id not found, the first tab item will be displayd by default

-}
customInitialState : String -> State
customInitialState id =
    State
        { activeTab = Just id
        , visibility = Showing
        }


{-| Create an initial/default view configuration for a Tab.
-}
config : (State -> msg) -> Config msg
config toMsg =
    Config
        { toMsg = toMsg
        , items = []
        , isPill = False
        , withAnimation = False
        , layout = Nothing
        , attributes = []
        , useHash = False
        }


{-| Define the tab items for a Tab.
-}
items : List (Item msg) -> Config msg -> Config msg
items items_ (Config configRec) =
    Config
        { configRec | items = items_ }


{-| Space out tab menu items evenly accross the the whole tabs control width
-}
justified : Config msg -> Config msg
justified =
    layout Justified


{-| Space out tab menu items to use the entire tabs control width, as opposed to [`justified`](#justified) items will not get equal widths
-}
fill : Config msg -> Config msg
fill =
    layout Fill


{-| Option to center the tab menu items
-}
center : Config msg -> Config msg
center =
    layout Center


{-| Option to place tab menu items to the right
-}
right : Config msg -> Config msg
right =
    layout Right


layout : TabLayout -> Config msg -> Config msg
layout layout_ (Config configRec) =
    Config
        { configRec | layout = Just layout_ }


{-| Option to make the tab menu items display with a pilled/buttonish look
-}
pills : Config msg -> Config msg
pills (Config configRec) =
    Config
        { configRec | isPill = True }


{-| Option to add a fade in/out animation effect when switching tabs
-}
withAnimation : Config msg -> Config msg
withAnimation (Config configRec) =
    Config
        { configRec | withAnimation = True }


{-| Use this function when you need additional customization with Html.Attribute attributes for the tabs control
-}
attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs attrs_ (Config configRec) =
    Config
        { configRec | attributes = configRec.attributes ++ attrs_ }


{-| By default the click handler for tabs has preventDefault true. If however you want the url hash
to be updated with the tab item id, you may use this function to ensure the url is changed when users
click on a tab item. This is handy if you use "real"" paths for your SPA pages but also want to be able to "deep-link" to a particular
tab item.
-}
useHash : Bool -> Config msg -> Config msg
useHash use (Config configRec) =
    Config
        { configRec | useHash = use }


{-| Creates a tab control which keeps track of the selected tab item and displays the corresponding tab pane for you

    Tab.config TabMsg
        |> Tab.withAnimation
        -- remember to wire up subscriptions when using this option
        |> Tab.right
        |> Tab.items
            [ Tab.item
                { id = "tabItem1"
                , link = Tab.link [] [ text "Tab 1" ]
                , pane = Tab.pane [] [ text "Tab 1 Content" ]
                }
            , Tab.item
                { id = "tabItem2"
                , link = Tab.link [] [ text "Tab 2" ]
                , pane = Tab.pane [] [ text "Tab 2 Content" ]
                }
            ]
        |> Tab.view model.tabState

-}
view : State -> Config msg -> Html.Html msg
view state (Config configRec) =
    case getActiveItem state configRec of
        Nothing ->
            Html.div []
                [ Html.ul (tabAttributes configRec) []
                , Html.div [ class "tab-content" ] []
                ]

        Just (Item currentItem) ->
            Html.div []
                [ Html.ul
                    (tabAttributes configRec)
                    (List.map
                        (\(Item item_) -> renderLink item_.id (item_.id == currentItem.id) item_.link configRec)
                        configRec.items
                    )
                , Html.div
                    [ class "tab-content" ]
                    (List.map
                        (\(Item item_) ->
                            renderTabPane item_.id (item_.id == currentItem.id) item_.pane state configRec
                        )
                        configRec.items
                    )
                ]


getActiveItem : State -> ConfigRec msg -> Maybe (Item msg)
getActiveItem (State { activeTab }) configRec =
    case activeTab of
        Nothing ->
            List.head configRec.items

        Just id ->
            List.filter (\(Item item_) -> item_.id == id) configRec.items
                |> List.head
                |> (\found ->
                        case found of
                            Just f ->
                                Just f

                            Nothing ->
                                List.head configRec.items
                   )


renderLink :
    String
    -> Bool
    -> Link msg
    -> ConfigRec msg
    -> Html.Html msg
renderLink id active (Link { attributes, children }) configRec =
    let
        commonClasses =
            [ ( "nav-link", True ), ( "active", active ) ]

        clickHandler =
            onClick <|
                configRec.toMsg <|
                    State
                        { activeTab = Just id
                        , visibility = visibilityTransition (configRec.withAnimation && not active) Hidden
                        }

        linkItem =
            if configRec.useHash then
                Html.a
                    ([ classList commonClasses
                     , clickHandler
                     , href <| "#" ++ id
                     ]
                        ++ attributes
                    )
                    children

            else
                Html.button
                    ([ classList <| commonClasses ++ [ ( "btn", True ), ( "btn-link", True ) ]
                     , clickHandler
                     ]
                        ++ attributes
                    )
                    children
    in
    Html.li
        [ class "nav-item" ]
        [ linkItem ]


renderTabPane :
    String
    -> Bool
    -> Pane msg
    -> State
    -> ConfigRec msg
    -> Html.Html msg
renderTabPane id active (Pane { attributes, children }) state configRec =
    let
        displayAttrs =
            if active then
                activeTabAttributes state configRec

            else
                [ style "display" "none" ]
    in
    Html.div
        ([ Attributes.id id, class "tab-pane" ] ++ displayAttrs ++ attributes)
        children


activeTabAttributes :
    State
    -> ConfigRec msg
    -> List (Html.Attribute msg)
activeTabAttributes (State { visibility }) configRec =
    case visibility of
        Hidden ->
            [ style "display" "none" ]

        Start ->
            [ style "display" "block", style "opacity" "0" ]

        Showing ->
            [ style "display" "block" ] ++ transitionStyles 1


visibilityTransition : Bool -> Visibility -> Visibility
visibilityTransition withAnimation_ visibility =
    case ( withAnimation_, visibility ) of
        ( True, Hidden ) ->
            Start

        ( True, Start ) ->
            Showing

        _ ->
            Showing


transitionHandler : (State -> msg) -> State -> Bool -> Json.Decoder msg
transitionHandler toMsg (State state) withAnimation_ =
    Json.succeed <|
        toMsg <|
            State
                { state | visibility = visibilityTransition withAnimation_ state.visibility }


transitionStyles : Int -> List (Html.Attribute msg)
transitionStyles opacity =
    [ style "opacity" <| String.fromInt opacity
    , style "-webkit-transition" "opacity 0.15s linear"
    , style "-o-transition" "opacity 0.15s linear"
    , style "transition" "opacity 0.15s linear"
    ]


tabAttributes : ConfigRec msg -> List (Html.Attribute msg)
tabAttributes configRec =
    [ classList
        [ ( "nav", True )
        , ( "nav-tabs", not configRec.isPill )
        , ( "nav-pills", configRec.isPill )
        ]
    ]
        ++ (case configRec.layout of
                Just Justified ->
                    [ class "nav-justified" ]

                Just Fill ->
                    [ class "nav-fill" ]

                Just Center ->
                    [ class "justify-content-center" ]

                Just Right ->
                    [ class "justify-content-end" ]

                Nothing ->
                    []
           )
        ++ configRec.attributes


applyModifier : Option msg -> Options msg -> Options msg
applyModifier option options =
    case option of
        Attrs attrs_ ->
            { options | attributes = options.attributes ++ attrs_ }

        Layout layout_ ->
            { options | layout = Just layout_ }


{-| Create a composable tab item

  - `id` A unique id for the tab item
  - `link` The link/menu for the tab item
  - `pane` The content part of a tab item

-}
item :
    { id : String
    , link : Link msg
    , pane : Pane msg
    }
    -> Item msg
item rec =
    Item
        { id = rec.id
        , link = rec.link
        , pane = rec.pane
        }


{-| Creates a composable tab menu item

  - `attributes` List of attributes
  - `children` List of child elements

-}
link : List (Html.Attribute msg) -> List (Html.Html msg) -> Link msg
link attributes children =
    Link
        { attributes = attributes
        , children = children
        }


{-| Creates a composable tab menu pane

  - `attributes` List of attributes
  - `children` List of child elements

-}
pane : List (Html.Attribute msg) -> List (Html.Html msg) -> Pane msg
pane attributes children =
    Pane
        { attributes = attributes
        , children = children
        }
