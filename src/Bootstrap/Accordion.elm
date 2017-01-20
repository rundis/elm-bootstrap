module Bootstrap.Accordion
    exposing
        ( accordion
        , cardToggle
        , cardBlock
        , card
        , toggleContainer
        , subscriptions
        , initialState
        , State
        , Config
        , Card
        , CardBlock
        , CardToggle
        , ToggleContainer
        )

{-| An accordion is a group of stacked cards where you can toggle the visibility (slide up/down) of each card

    type alias Model =
        { accordionState = Accordion.state }


    init: (Model, Cmd Msg)
        ( { accordionState = Accordion.initialState }, Cmd.none )


    type Msg
        = AccordionMsg Accordion.State



    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            AccordionMsg state ->
                ( { model | accordionState = state }
                , Cmd.none
                )


    view : Model -> Html Msg
    view model =
        Accordion.accordion
            model.accordionState
            { toMsg = AccordionMsg
            , withAnimation = True
            , cards
                [ Accordion.card
                    { id = "card1"
                    , toggle = Accordion.cardToggle [] [ text "Card 1" ]
                    , toggleContainer = Nothing
                    , block =
                        Accordion.cardBlock [] [ text "Contants of Card 1"]
                    }
                , Accordion.card
                    { id = "card2"
                    , toggle = Accordion.cardToggle [] [ text "Card 2" ]
                    , toggleContainer = Nothing
                    , block =
                        Accordion.cardBlock [] [ text "Contants of Card 2"]
                    }
                ]
            }


    -- You need to do this wiring when you use animations !

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Accordion.subscriptions model.accordionState AccordionMsg




@docs accordion, card, cardToggle, cardBlock, toggleContainer, Config, initialState, State, subscriptions, Card, CardBlock, CardToggle, ToggleContainer




-}

import Html
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick, on, onWithOptions, Options)
import Json.Decode as Json
import DOM
import Dict exposing (Dict)
import AnimationFrame


{-| Configuration information that defines the view of your accordion

* `toMsg` A message construnctor functions that is used to step the view state forward
* `cards` List of cards to displayed
* `withAnimation` Determine whether you wish the slide up/down of the card contents to be animated


**Note: ** When you use animations you must also remember to wire up the [`subscriptions`](#subscriptions) function

-}
type alias Config msg =
    { toMsg : State -> msg
    , withAnimation : Bool
    , cards : List (Card msg)
    }


{-| Opaque representation of the view state for the accordion
-}
type State
    = State (Dict String CardState)


{-| Initial state for the accordion. Typically used from your main `init` function
-}
initialState : State
initialState =
    State Dict.empty


type alias CardState =
    { visibility : Visibility
    , height : Maybe Float
    }


type Visibility
    = Hidden
    | StartDown
    | AnimatingDown
    | StartUp
    | AnimatingUp
    | Shown


{-| Opaque representation of a card item
-}
type Card msg
    = Card
        { id : String
        , toggle : CardToggle msg
        , toggleContainer : Maybe (ToggleContainer msg)
        , block : CardBlock msg
        }


{-| Opaque representation of toggle element for initating slide up/down for a card
-}
type CardToggle msg
    = CardToggle
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


{-| Opaque representation for a toggle container element
-}
type ToggleContainer msg
    = ToggleContainer
        { elemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        , attributes : List (Html.Attribute msg)
        , childrenPreToggle : List (Html.Html msg)
        , childrenPostToggle : List (Html.Html msg)
        }


{-| Opaque representation of a card block element
-}
type CardBlock msg
    = CardBlock
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }



{-| When using animations you must remember to call this function for you main subscriptions function

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Accordion.subscriptions model.accordionState AccordionMsg

* `state` The current view state of the accordion
* `toMsg` Message constructor function that is used to step the view state forward
-}
subscriptions : State -> (State -> msg) -> Sub msg
subscriptions (State cardStates) toMsg =
    let
        updState =
            Dict.map
                (\id state ->
                    case state.visibility of
                        StartDown ->
                            { state | visibility = AnimatingDown }

                        StartUp ->
                            { state | visibility = AnimatingUp }

                        _ ->
                            state
                )
                cardStates
                |> State

        needsSub =
            Dict.toList cardStates
                |> List.any
                    (\( _, state ) ->
                        List.member state.visibility [StartDown, StartUp]
                    )
    in
        if needsSub then
            AnimationFrame.times (\_ -> toMsg updState)
        else
            Sub.none


{-| Create an interactive accordion element
    Accordion.accordion
        model.accordionState
        { toMsg = AccordionMsg
        , withAnimation = True
        , cards
            [ cardOne model -- view function to create a card
            , cardTwo model
            ]
        }


* `state` The current view state
* `config` The configuration for the display of the accordion
-}
accordion :
    State
    -> Config msg
    -> Html.Html msg
accordion state ({ cards } as config) =
    Html.div
        []
        (List.map (renderCard state config) cards)


{-| Creates a card item for use in an accordion

    Accordion.card
        { id = "myCard"
        , toggle = Accordion.cardToggle [] [ text "My card header"]
        , toggleContainer = Nothing
        , cardBlock =
            Accordion.cardBlock []
                [ text "Contents of My card"
                , p [] [ text "A paragraph in my card "]
                ]

        }

* card config record
    * `id` Unique id for your card
    * `toggle` The element responsible for toggling the display of your card content
    * `toggleContainer`Optional container element for your toggle for greater customization
    * `block` The main content of the card

-}
card :
    { id : String
    , block : CardBlock msg
    , toggle : CardToggle msg
    , toggleContainer : Maybe (ToggleContainer msg)
    }
    -> Card msg
card { id, toggle, toggleContainer, block } =
    Card
        { id = id
        , toggle = toggle
        , toggleContainer = toggleContainer
        , block = block
        }

{-| Creates a card toggle element used for toggling the display of you cards main content

* `attributes` List of attributes
* `children` List of child elements
-}
cardToggle : List (Html.Attribute msg) -> List (Html.Html msg) -> CardToggle msg
cardToggle attributes children =
    CardToggle
        { attributes = attributes
        , children = children
        }



{-| You may wish to wrap your card toggle in a containing element for customizing card headers in your accordion

* configuration record with the following fields
    * `elemFn` A html element function (example a h1, h2 etc)
    * attributes Html attributes for the container element
    * childrenPreToggle List of elements to be displayed before the toggle element
    * childrenPostToggle List of elements to displayed after the toggle element
-}
toggleContainer :
    { elemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
    , attributes : List (Html.Attribute msg)
    , childrenPreToggle : List (Html.Html msg)
    , childrenPostToggle : List (Html.Html msg)
    }
    -> ToggleContainer msg
toggleContainer { elemFn, attributes, childrenPreToggle, childrenPostToggle } =
    ToggleContainer
        { elemFn = elemFn
        , attributes = attributes
        , childrenPreToggle = childrenPreToggle
        , childrenPostToggle = childrenPostToggle
        }



{-| Creates the main (toggleable) content for a card item for use in an accordion

* `attributes` List of attributes
` `children` List of child elements
-}
cardBlock : List (Html.Attribute msg) -> List (Html.Html msg) -> CardBlock msg
cardBlock attributes children =
    CardBlock
        { attributes = attributes
        , children = children
        }


renderCard :
    State
    -> Config msg
    -> Card msg
    -> Html.Html msg
renderCard state config card =
    Html.div
        [ class "card" ]
        [ renderCardHeader state config card
        , renderCardBlock state config card
        ]


renderCardHeader :
    State
    -> Config msg
    -> Card msg
    -> Html.Html msg
renderCardHeader state config ((Card { toggleContainer }) as card) =
    Html.div
        [ class "card-header" ]
        (case toggleContainer of
            Nothing ->
                [ renderCardToggle state config False card ]

            Just (ToggleContainer { elemFn, attributes, childrenPreToggle, childrenPostToggle }) ->
                [ elemFn attributes <|
                    List.concat
                        [ childrenPreToggle
                        , [ renderCardToggle state config True card ]
                        , childrenPostToggle
                        ]
                ]
        )


renderCardToggle :
    State
    -> Config msg
    -> Bool
    -> Card msg
    -> Html.Html msg
renderCardToggle state config isContained ((Card { id, toggle }) as card) =
    let
        (CardToggle { attributes, children }) =
            toggle
    in
        Html.a
            ([ href <| "#" ++ id
             , onWithOptions
                "click"
                { stopPropagation = False
                , preventDefault = True
                }
               <|
                clickHandler state config (heightDecoder isContained) card
             ]
                ++ attributes
            )
            children


clickHandler :
    State
    -> Config msg
    -> Json.Decoder Float
    -> Card msg
    -> Json.Decoder msg
clickHandler state { toMsg, withAnimation } decoder (Card { id }) =
    let
        updState h =
            mapCardState
                id
                (\cardState ->
                    { height = Just h
                    , visibility = visibilityTransition withAnimation cardState.visibility
                    }
                )
                state
    in
        decoder
            |> Json.andThen
                (\v ->
                    Json.succeed <|
                        toMsg <|
                            updState v
                )


visibilityTransition : Bool -> Visibility -> Visibility
visibilityTransition withAnimation visibility =
    case ( withAnimation, visibility ) of
        ( True, Hidden ) ->
            StartDown

        ( True, StartDown ) ->
            AnimatingDown

        ( True, AnimatingDown ) ->
            Shown

        ( True, Shown ) ->
            StartUp

        ( True, StartUp ) ->
            AnimatingUp

        ( True, AnimatingUp ) ->
            Hidden

        ( False, Hidden ) ->
            Shown

        ( False, Shown ) ->
            Hidden

        _ ->
            Shown


heightDecoder : Bool -> Json.Decoder Float
heightDecoder isContained =
    DOM.target <|
        DOM.parentElement <|
            (if isContained then
                DOM.parentElement
             else
                identity
            )
            <|
                DOM.nextSibling <|
                    DOM.childNode 0 <|
                        DOM.offsetHeight


renderCardBlock :
    State
    -> Config msg
    -> Card msg
    -> Html.Html msg
renderCardBlock state config ((Card { id, block }) as card) =
    let
        (CardBlock { attributes, children }) =
            block
    in
        Html.div
            ([ Html.Attributes.id id ]
                ++ attributes
                ++ animationAttributes state config card)
            [ Html.div
                [ class "card-block" ]
                children
            ]


animationAttributes :
    State
    -> Config msg
    -> Card msg
    -> List (Html.Attribute msg)
animationAttributes state config ((Card { id }) as card) =
    let
        cardState =
            getOrInitCardState id state

        pixelHeight =
            Maybe.map (\v -> (toString v) ++ "px") cardState.height
                |> Maybe.withDefault "0"
    in
        case cardState.visibility of
            Hidden ->
                [ style [ ( "overflow", "hidden" ), ( "height", "0" ) ] ]

            StartDown ->
                [ style [ ( "overflow", "hidden" ), ( "height", "0" ) ] ]

            AnimatingDown ->
                [ transitionStyle pixelHeight
                , on "transitionend" <|
                    transitionHandler state config card
                ]

            AnimatingUp ->
                [ transitionStyle "0px"
                , on "transitionend" <|
                    transitionHandler state config card
                ]

            StartUp ->
                [ style [ ( "height", pixelHeight ) ] ]

            Shown ->
                [ style [ ( "height", pixelHeight ) ] ]


transitionHandler :
    State
    -> Config msg
    -> Card msg
    -> Json.Decoder msg
transitionHandler state { toMsg, withAnimation } (Card { id }) =
    mapCardState id
        (\cardState ->
            { cardState
                | visibility =
                    visibilityTransition withAnimation cardState.visibility
            }
        )
        state
        |> toMsg
        |> Json.succeed


transitionStyle : String -> Html.Attribute msg
transitionStyle height =
    style
        [ ( "position", "relative" )
        , ( "height", height )
        , ( "overflow", "hidden" )
        , ( "-webkit-transition-timing-function", "ease" )
        , ( "-o-transition-timing-function", "ease" )
        , ( "transition-timing-function", "ease" )
        , ( "-webkit-transition-duration", "0.35s" )
        , ( "-o-transition-duration", "0.35s" )
        , ( "transition-duration", "0.35s" )
        , ( "-webkit-transition-property", "height" )
        , ( "-o-transition-property", "height" )
        , ( "transition-property", "height" )
        ]


getOrInitCardState : String -> State -> CardState
getOrInitCardState id (State cardStates) =
    Dict.get id cardStates
        |> Maybe.withDefault
            { visibility = Hidden
            , height = Nothing
            }


mapCardState :
    String
    -> (CardState -> CardState)
    -> State
    -> State
mapCardState id mapperFn ((State cardStates) as state) =
    let
        updCardState =
            getOrInitCardState id state
                |> mapperFn
    in
        Dict.insert id updCardState cardStates
            |> State
