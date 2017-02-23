module Page.Tab exposing (view, initialState, subscriptions, State)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Tab as Tab
import Util
import Bootstrap.Form as Form
import Bootstrap.Form.Radio as Radio


type alias State =
    { tabState : Tab.State
    , pillState : Tab.State
    , animatedState : Tab.State
    , customizedState : Tab.State
    , layout : Layout
    }


type Layout
    = None
    | Justified
    | Fill
    | Center
    | Right


initialState : State
initialState =
    { tabState = Tab.initialState
    , pillState = Tab.initialState
    , animatedState = Tab.initialState
    , customizedState = Tab.initialState
    , layout = None
    }


subscriptions : State -> (State -> msg) -> Sub msg
subscriptions state toMsg =
    Tab.subscriptions state.animatedState (\ts -> toMsg { state | animatedState = ts })


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Tab"
        """Use the Tab module when you want to create a tabbed interface element with tabbable regions of content."""
    , Util.pageContent
        (tabs state toMsg ++ pills state toMsg ++ animated state toMsg ++ customized state toMsg)
    ]


tabs : State -> (State -> msg) -> List (Html msg)
tabs state toMsg =
    [ h2 [] [ text "Tabs" ]
    , p [] [ text """Create a classic tabbed control using the tabs function.
                    Since the Tabs require some internal view state, you will need to do a little bit of wiring to get it working.""" ]
    , Util.example
        [ Tab.tabs
            state.tabState
            { toMsg = (\ts -> toMsg { state | tabState = ts })
            , options = []
            , withAnimation = False
            , items =
                [ Tab.item
                    { link = Tab.link [] [ text "Tab 1" ]
                    , pane =
                        Tab.pane [ class "mt-3" ]
                            [ h4 [] [ text "Tab 1 Heading" ]
                            , p [] [ text "Contents of tab 1." ]
                            ]
                    }
                , Tab.item
                    { link = Tab.link [] [ text "Tab 2" ]
                    , pane =
                        Tab.pane [ class "mt-3" ]
                            [ h4 [] [ text "Tab 2 Heading" ]
                            , p [] [ text "This is something completely different." ]
                            ]
                    }
                ]
            }
        ]
    , Util.code tabsCode
    ]


tabsCode : Html msg
tabsCode =
    Util.toMarkdownElm """

-- Tabs depends on view state to keep track of the active Tab, you'll need to store that in your model

type alias Model =
    { tabState : Tab.State }

-- Provide the initialState for the Tabs control

init : ( Model, Cmd Msg )
init =
    ( { tabState : Tab.initalState}, Cmd.none )


--  To step the state forward for the Tabs control we need to have a Message

type Msg
    = TabMsg Tab.State


-- In your update function you will need to handle the messages coming from the Tabs control

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        TabMsg state ->
            ( { model | tabState = state }
            , Cmd.none
            )


-- The view specifies how the tab should look and behave

view : Model -> Html msg
view model =
    Tab.tabs
        model.tabState
        { toMsg = TabMsg
        , options = []
        , withAnimation = False
        , items =
            [ Tab.item
                { link = Tab.link [] [ text "Tab 1"]
                , pane = Tab.pane [ class "mt-3"]
                            [ h4 [] [ text "Tab 1 Heading"]
                            , p [] [ text "Contents of tab 1." ]
                            ]
                }
            , Tab.item
                { link = Tab.link [] [ text "Tab 2" ]
                , pane = Tab.pane [ class "mt-3"]
                            [ h4 [] [ text "Tab 2 Heading"]
                            , p [] [ text "This is something completely different." ]
                            ]
                }
            ]
        }
"""


pills : State -> (State -> msg) -> List (Html msg)
pills state toMsg =
    [ h2 [] [ text "Pills" ]
    , p [] [ text "Pills are just like tabs but gives a pill look to the tabs " ]
    , Util.example
        [ Tab.pills
            state.pillState
            { toMsg = (\ts -> toMsg { state | pillState = ts })
            , options = []
            , withAnimation = False
            , items =
                [ Tab.item
                    { link = Tab.link [] [ text "Tab 1" ]
                    , pane =
                        Tab.pane [ class "mt-3" ]
                            [ h4 [] [ text "Tab 1 Heading" ]
                            , p [] [ text "Contents of tab 1." ]
                            ]
                    }
                , Tab.item
                    { link = Tab.link [] [ text "Tab 2" ]
                    , pane =
                        Tab.pane [ class "mt-3" ]
                            [ h4 [] [ text "Tab 2 Heading" ]
                            , p [] [ text "This is something completely different." ]
                            ]
                    }
                ]
            }
        ]
    , Util.code pillsCode
    ]


pillsCode : Html msg
pillsCode =
    Util.toMarkdownElm """
Tab.pills
    model.tabState
    { toMsg = TabMsg
    , options = []
    , withAnimation = False
    , items =
        [ Tab.item
            { link = Tab.link [] [ text "Tab 1"]
            , pane = Tab.pane [ class "mt-3"]
                        [ h4 [] [ text "Tab 1 Heading"]
                        , p [] [ text "Contents of tab 1." ]
                        ]
            }
        , Tab.item
            { link = Tab.link [] [ text "Tab 2" ]
            , pane = Tab.pane [ class "mt-3"]
                        [ h4 [] [ text "Tab 2 Heading"]
                        , p [] [ text "This is something completely different." ]
                        ]
            }
        ]
    }
"""


animated : State -> (State -> msg) -> List (Html msg)
animated state toMsg =
    [ h2 [] [ text "Adding an animation effect" ]
    , p [] [ text "You can add an fade in animation effect, by adding a little bit more of wiring." ]
    , Util.example
        [ Tab.tabs
            state.animatedState
            { toMsg = (\ts -> toMsg { state | animatedState = ts })
            , options = []
            , withAnimation = True
            , items =
                [ Tab.item
                    { link = Tab.link [] [ text "Tab 1" ]
                    , pane =
                        Tab.pane [ class "mt-3" ]
                            [ h4 [] [ text "Tab 1 Heading" ]
                            , p [] [ text "Contents of tab 1." ]
                            ]
                    }
                , Tab.item
                    { link = Tab.link [] [ text "Tab 2" ]
                    , pane =
                        Tab.pane [ class "mt-3" ]
                            [ h4 [] [ text "Tab 2 Heading" ]
                            , p [] [ text "This is something completely different." ]
                            ]
                    }
                ]
            }
        ]
    , Util.code animatedCode
    , Util.calloutWarning
        [ h4 [] [ text "Don't forget the subscription !"]
        , p [] [ text """When you set withAnimation to True it's really important that you remember to also wire up the subscriptions function.
                         If you forget, changing tabs will not work."""]
        ]
    ]


animatedCode : Html msg
animatedCode =
    Util.toMarkdownElm """


-- For animations to work you need to wire up a subscription for the Tabs control

subscriptions : Model -> Sub Msg
    subscriptions model =
        Tab.subscriptions model.tabState TabMsg


view : Model -> Html msg
view model =
    Tab.tabs
        model.tabState
        { toMsg = TabMsg
        , options = []
        , withAnimation = True -- Enables animation
        , items =
            [ Tab.item
                { link = Tab.link [] [ text "Tab 1"]
                , pane = Tab.pane [ class "mt-3"]
                            [ h4 [] [ text "Tab 1 Heading"]
                            , p [] [ text "Contents of tab 1." ]
                            ]
                }
            , Tab.item
                { link = Tab.link [] [ text "Tab 2" ]
                , pane = Tab.pane [ class "mt-3"]
                            [ h4 [] [ text "Tab 2 Heading"]
                            , p [] [ text "This is something completely different." ]
                            ]
                }
            ]
        }

"""


customized : State -> (State -> msg) -> List (Html msg)
customized state toMsg =
    let
        radioAttrs layout =
            [ Radio.inline
            , Radio.onClick <| toMsg { state | layout = layout }
            , Radio.checked <| layout == state.layout
            ]

        tabOptions =
            case state.layout of
                None ->
                    []

                Center ->
                    [ Tab.center ]

                Right ->
                    [ Tab.right ]

                Justified ->
                    [ Tab.justified ]

                Fill ->
                    [ Tab.fill ]


    in
        [ h2 [] [ text "Customizing with options" ]
        , p [] [ text "You can easily customize spacing and alignement of tabs using helper functions" ]
        , Util.example
            [ Form.form []
                [ h5 [] [ text "Tab layout options" ]
                , Form.group []
                    [ Form.label [] [ text "Horizontal alignment"]
                    , div []
                        [ Radio.radio (radioAttrs None)  "Default"
                        , Radio.radio (radioAttrs Center)  "Tab.center"
                        , Radio.radio (radioAttrs Right)  "Tab.right"
                        , Radio.radio (radioAttrs Justified)  "Tab.justified"
                        , Radio.radio (radioAttrs Fill)  "Tab.fill"
                        ]
                    ]
                , hr [] []
                ]
            , Tab.pills
                state.customizedState
                { toMsg = (\ts -> toMsg { state | customizedState = ts })
                , options = tabOptions
                , withAnimation = False
                , items =
                    [ Tab.item
                        { link = Tab.link [] [ text "First tab" ]
                        , pane =
                            Tab.pane [ class "mt-3" ]
                                [ p [] [ text """Food truck fixie locavore, accusamus mcsweeney's marfa nulla single-origin coffee squid. Exercitation +1 labore velit, blog sartorial PBR leggings next level wes anderson artisan four loko farm-to-table craft beer twee. Qui photo booth letterpress, commodo enim craft beer mlkshk aliquip jean shorts ullamco ad vinyl cillum PBR. Homo nostrud organic, assumenda labore aesthetic magna delectus mollit. Keytar helvetica VHS salvia yr, vero magna velit sapiente labore stumptown. Vegan fanny pack odio cillum wes anderson 8-bit, sustainable jean shorts beard ut DIY ethical culpa terry richardson biodiesel. Art party scenester stumptown, tumblr butcher vero sint qui sapiente accusamus tattooed echo park.""" ]
                                ]
                        }
                    , Tab.item
                        { link = Tab.link [] [ text "Second tab" ]
                        , pane =
                            Tab.pane [ class "mt-3" ]
                                [ h4 [] [ text "Tab 2 Heading" ]
                                , p [] [ text "This is something completely different." ]
                                ]
                        }
                    , Tab.item
                        { link = Tab.link [] [ text "Yet another tab" ]
                        , pane =
                            Tab.pane [ class "mt-3" ]
                                [ h4 [] [ text "Tab 3 Heading" ]
                                , p [] [ text "Nothing to see here." ]
                                ]
                        }
                    ]
                }
            ]
        ]
