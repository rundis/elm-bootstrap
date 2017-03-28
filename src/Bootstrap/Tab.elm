module Bootstrap.Tab
    exposing
        ( view
        , config
        , items
        , withAnimation
        , pills
        , item
        , link
        , pane
        , initialState
        , customInitialState
        , subscriptions
        , justified
        , fill
        , right
        , center
        , attrs
        , Config
        , State
        , Item
        , Link
        , Pane
        , Option
        )

{-| Use tabs to create tabbable regions. Tabs uses view state, so there is a little bit of wiring needed to use them.

    -- example with animation, you can drop the subscription part when not using animations

    type alias Model =
        { tabState : Tab.State }


    init : ( Model, Cmd Msg )
    init =
        ( { tabState : Tab.initalState}, Cmd.none )


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
            |> Tab.withAnimation -- remember to wire up subscriptions when using this option
            |> Tab.right
            |> Tab.items
                [ Tab.item
                    { link = Tab.link [] [ text "Tab 1" ]
                    , pane = Tab.pane [] [ text "Tab 1 Content" ]
                    }
                , Tab.item
                    { link = Tab.link [] [ text "Tab 2" ]
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
@docs pills, withAnimation, justified, fill, center, right, attrs, Option

# Tab items
@docs item, link, pane, Item, Link, Pane



# With animations
@docs subscriptions

-}

import AnimationFrame as AnimationFrame
import Html
import Html.Attributes exposing (class, classList, href, style)
import Html.Events exposing (onWithOptions, on)
import Json.Decode as Json


{-| Opaque type representing the view state of the tabs control
-}
type State
    = State
        { activeTab : Int
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

* `toMsg` Message constructor function used for transitioning view state
* `options` Customization options for the tabs control
* `withAnimation` Option to enable a simple fade in animation for tabs.
* `items` List of tab items

**NOTE** When using animations you must also remember to set up [`subscriptions`](#subscriptions)

-}
type Config msg
    = Config
        { toMsg : State -> msg
        , items : List (Item msg)
        , withAnimation : Bool
        , layout : Maybe TabLayout
        , isPill : Bool
        , attributes : List (Html.Attribute msg)
        }


{-| Opaque type representing a tab item
-}
type Item msg
    = Item
        { link : Link msg
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
            AnimationFrame.times
                (\_ -> toMsg <| State <| { state | visibility = Showing })

        _ ->
            Sub.none


{-| Use this function to create the inital state for the tabs control
-}
initialState : State
initialState =
    customInitialState 0


{-| Use this function if you want to initialize your tabs control with a specific tab selected.

**NOTE: ** Should you specify an index out of range, the first tab item will be displayd by default
-}
customInitialState : Int -> State
customInitialState idx =
    State
        { activeTab = idx
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
        }


{-| Define the tab items for a Tab.
-}
items : List (Item msg) -> Config msg -> Config msg
items items (Config config) =
    Config
        { config | items = items }


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
layout layout (Config config) =
    Config
        { config | layout = Just layout }


{-| Option to make the tab menu items display with a pilled/buttonish look
-}
pills : Config msg -> Config msg
pills (Config config) =
    Config
        { config | isPill = True }


{-| Option to add a fade in/out animation effect when switching tabs
-}
withAnimation : Config msg -> Config msg
withAnimation (Config config) =
    Config
        { config | withAnimation = True }


{-| Use this function when you need additional customization with Html.Attribute attributes for the tabs control
-}
attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs attrs (Config config) =
    Config
        { config | attributes = config.attributes ++ attrs }


{-| Creates a tab control which keeps track of the selected tab item and displays the corresponding tab pane for you

    Tab.config TabMsg
        |> Tab.withAnimation -- remember to wire up subscriptions when using this option
        |> Tab.right
        |> Tab.items
            [ Tab.item
                { link = Tab.link [] [ text "Tab 1" ]
                , pane = Tab.pane [] [ text "Tab 1 Content" ]
                }
            , Tab.item
                { link = Tab.link [] [ text "Tab 2" ]
                , pane = Tab.pane [] [ text "Tab 2 Content" ]
                }
            ]
        |> Tab.view model.tabState
-}
view : State -> Config msg -> Html.Html msg
view ((State { activeTab }) as state) ((Config { items }) as config) =
    let
        activeIdx =
            if activeTab > List.length items then
                0
            else
                max activeTab 0
    in
        Html.div []
            [ Html.ul
                (tabAttributes config)
                (List.indexedMap
                    (\idx (Item { link }) ->
                        renderLink idx (idx == activeIdx) config link
                    )
                    items
                )
            , Html.div
                [ class "tab-content" ]
                (List.indexedMap
                    (\idx (Item { pane }) ->
                        renderTabPane (idx == activeIdx) pane state config
                    )
                    items
                )
            ]


renderLink :
    Int
    -> Bool
    -> Config msg
    -> Link msg
    -> Html.Html msg
renderLink idx active (Config { toMsg, withAnimation }) (Link { attributes, children }) =
    Html.li
        [ class "nav-item" ]
        [ Html.a
            ([ classList
                [ ( "nav-link", True )
                , ( "active", active )
                ]
             , href "#"
             , onWithOptions
                "click"
                { stopPropagation = False
                , preventDefault = True
                }
               <|
                Json.succeed <|
                    toMsg <|
                        State
                            { activeTab = idx
                            , visibility = visibilityTransition (withAnimation && not active) Hidden
                            }
             ]
                ++ attributes
            )
            children
        ]


renderTabPane :
    Bool
    -> Pane msg
    -> State
    -> Config msg
    -> Html.Html msg
renderTabPane active (Pane { attributes, children }) state config =
    let
        displayAttrs =
            if active then
                activeTabAttributes state config
            else
                [ style [ ( "display", "none" ) ] ]
    in
        Html.div
            ([ class "tab-pane" ] ++ displayAttrs ++ attributes)
            children


activeTabAttributes :
    State
    -> Config msg
    -> List (Html.Attribute msg)
activeTabAttributes (State { visibility }) (Config { toMsg, withAnimation }) =
    case visibility of
        Hidden ->
            [ style [ ( "display", "none" ) ] ]

        Start ->
            [ style [ ( "display", "block" ), ( "opacity", "0" ) ] ]

        Showing ->
            [ style [ ( "display", "block" ) ]
            , transitionStyle 1
            ]


visibilityTransition : Bool -> Visibility -> Visibility
visibilityTransition withAnimation visibility =
    case ( withAnimation, visibility ) of
        ( True, Hidden ) ->
            Start

        ( True, Start ) ->
            Showing

        _ ->
            Showing


transitionHandler : (State -> msg) -> State -> Bool -> Json.Decoder msg
transitionHandler toMsg (State state) withAnimation =
    Json.succeed <|
        toMsg <|
            State
                { state | visibility = visibilityTransition withAnimation state.visibility }


transitionStyle : Int -> Html.Attribute msg
transitionStyle opacity =
    style
        [ ( "opacity", toString opacity )
        , ( "-webkit-transition", "opacity 0.15s linear" )
        , ( "-o-transition", "opacity 0.15s linear" )
        , ( "transition", "opacity 0.15s linear" )
        ]


tabAttributes : Config msg -> List (Html.Attribute msg)
tabAttributes (Config config) =
    [ classList
        [ ( "nav", True )
        , ( "nav-tabs", not config.isPill )
        , ( "nav-pills", config.isPill )
        ]
    ]
        ++ (case config.layout of
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
        ++ config.attributes


applyModifier : Option msg -> Options msg -> Options msg
applyModifier option options =
    case option of
        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }

        Layout layout ->
            { options | layout = Just layout }


{-| Create a composable tab item

* `link` The link/menu for the tab item
* `pane` The content part of a tab item
-}
item :
    { link : Link msg
    , pane : Pane msg
    }
    -> Item msg
item { link, pane } =
    Item
        { link = link
        , pane = pane
        }


{-| Creates a composable tab menu item

* `attributes`  List of attributes
* `children` List of child elements
-}
link : List (Html.Attribute msg) -> List (Html.Html msg) -> Link msg
link attributes children =
    Link
        { attributes = attributes
        , children = children
        }


{-| Creates a composable tab menu pane

* `attributes`  List of attributes
* `children` List of child elements
-}
pane : List (Html.Attribute msg) -> List (Html.Html msg) -> Pane msg
pane attributes children =
    Pane
        { attributes = attributes
        , children = children
        }
