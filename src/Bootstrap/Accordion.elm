module Bootstrap.Accordion exposing
    ( view, config, cards, withAnimation, onlyOneOpen, isOpen, Config, initialState, initialStateCardOpen, State
    , card, block, listGroup, header, toggle, headerH1, headerH2, headerH3, headerH4, headerH5, headerH6, appendHeader, prependHeader, Card, CardBlock, Header, Toggle
    , subscriptions
    )

{-| An accordion is a group of stacked cards where you can toggle the visibility (slide up/down) of each card

    type alias Model =
        { accordionState = Accordion.state }


    init : (Model, Cmd Msg)
    init =
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
        Accordion.config AccordionMsg
            |> Accordion.withAnimation
            |> Accordion.cards
                [ Accordion.card
                    { id = "card1"
                    , options = []
                    , header =
                        Accordion.header [] <| Accordion.toggle [] [ text "Card 1" ]
                    , blocks =
                        [ Accordion.block []
                            [ Block.text [] [ text "Lorem ipsum etc" ] ]
                        ]
                    }
                , Accordion.card
                    { id = "card2"
                    , options = []
                    , header =
                        Accordion.header [] <| Accordion.toggle [] [ text "Card 2" ]
                    , blocks =
                        [ Accordion.block []
                            [ Block.text [] [ text "Lorem ipsum etc" ] ]
                        ]
                    }
                ]
            |> Accordion.view model.accordionState


    -- You need to do this wiring when you use animations !

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Accordion.subscriptions model.accordionState AccordionMsg


## Accordion

@docs view, config, cards, withAnimation, onlyOneOpen, isOpen, Config, initialState, initialStateCardOpen, State


## Contents

@docs card, block, listGroup, header, toggle, headerH1, headerH2, headerH3, headerH4, headerH5, headerH6, appendHeader, prependHeader, Card, CardBlock, Header, Toggle


## Animation

@docs subscriptions

-}

import Bootstrap.Card as Card
import Bootstrap.Card.Block as Block
import Bootstrap.Card.Internal as CardInternal
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Utilities.DomHelper as DomHelper
import Browser.Events
import Dict exposing (Dict)
import Html
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (custom, on, onClick)
import Json.Decode as Json


{-| Opaque type that defines the view configuration information of your accordion

  - You create an initial configuration by calling the [`config`](#config) function
  - The [`withAnimtion`](#withAnimation) function allows you to define that the contents of cards should animate up/down
  - The [`cards`](#cards) function defines the List of cards to be displayed

-}
type Config msg
    = Config (ConfigRec msg)


type alias ConfigRec msg =
    { toMsg : State -> msg
    , withAnimation : Bool
    , onlyOneOpen : Bool
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


{-| Initial state with card that matches given id expanded.
-}
initialStateCardOpen : String -> State
initialStateCardOpen id =
    State <| Dict.fromList [ ( id, CardState Shown Nothing ) ]


type alias CardState =
    { visibility : Visibility
    , height : Maybe Float
    }


type Visibility
    = Hidden
    | StartDown
    | StartUp
    | Shown


{-| Opaque representation of a card item
-}
type Card msg
    = Card
        { id : String
        , options : List (Card.Option msg)
        , header : Header msg
        , blocks : List (CardBlock msg)
        }


{-| Opaque representation of toggle element for initiating slide up/down for a card
-}
type Toggle msg
    = Toggle
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


{-| Opaque representation of a card block element
-}
type alias CardBlock msg =
    CardInternal.CardBlock msg


{-| Opaque type representing the header for an accordion card
-}
type Header msg
    = Header
        { elemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        , attributes : List (Html.Attribute msg)
        , toggle : Toggle msg
        , childrenPreToggle : List (Html.Html msg)
        , childrenPostToggle : List (Html.Html msg)
        }


{-| When using animations you must remember to call this function for your main subscriptions function

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Accordion.subscriptions model.accordionState AccordionMsg

  - `state` The current view state of the accordion
  - `toMsg` Message constructor function that is used to step the view state forward

-}
subscriptions : State -> (State -> msg) -> Sub msg
subscriptions (State cardStates) toMsg =
    let
        updState =
            Dict.map
                (\id state ->
                    case state.visibility of
                        StartDown ->
                            { state | visibility = Shown }

                        StartUp ->
                            { state | visibility = Hidden }

                        _ ->
                            state
                )
                cardStates
                |> State

        needsSub =
            Dict.toList cardStates
                |> List.any
                    (\( _, state ) ->
                        List.member state.visibility [ StartDown, StartUp ]
                    )
    in
    if needsSub then
        Browser.Events.onAnimationFrame (\_ -> toMsg updState)

    else
        Sub.none


{-| Creates an initial/default view configuration for an accordion.
-}
config : (State -> msg) -> Config msg
config toMsg =
    Config
        { toMsg = toMsg
        , withAnimation = False
        , onlyOneOpen = False
        , cards = []
        }


{-| Set option for using animations for sliding card contents up/down.

_Note_: You must remember to hook up the [`subscriptions`](#subscriptions) function
when using this option.

-}
withAnimation : Config msg -> Config msg
withAnimation (Config configRec) =
    Config
        { configRec | withAnimation = True }


{-| Set option for only allowing one (or zero) open cards at any one time.
-}
onlyOneOpen : Config msg -> Config msg
onlyOneOpen (Config configRec) =
    Config
        { configRec | onlyOneOpen = True }


{-| Check if given card is open/expanded (or when animating, on it's way to become open/expanded).

**NOTE: If you give a non-existing id it will return False (:**

-}
isOpen : String -> State -> Bool
isOpen id (State cardStates) =
    case Dict.get id cardStates of
        Just { visibility } ->
            visibility == Shown || visibility == StartDown

        Nothing ->
            False


{-| Create an interactive accordion element

    Accordion.config AccordionMsg
        |> Accordion.withAnimation
        |> Accordion.cards
            [ cardOne model -- view function to create a card
            , cardTwo model
            ]
        |> Accordion.view model.accordionState

  - `state` The current view state
  - `config` The configuration for the display of the accordion

-}
view :
    State
    -> Config msg
    -> Html.Html msg
view state (Config configRec) =
    Html.div
        [ class "accordion" ]
        (List.map (renderCard state configRec) configRec.cards)


{-| Define the cards that your accordion should consist of
-}
cards : List (Card msg) -> Config msg -> Config msg
cards cards_ (Config configRec) =
    Config
        { configRec | cards = cards_ }


{-| Creates a card item for use in an accordion

  - card config record
      - `id` Unique id for your card
      - `options` List of card styling options
      - `header` Card header containing a toggle to hide/show the details of a card
      - `blocks` The main content elements of the card

-}
card :
    { id : String
    , options : List (Card.Option msg)
    , blocks : List (CardBlock msg)
    , header : Header msg
    }
    -> Card msg
card rec =
    Card
        { id = rec.id
        , options = rec.options
        , header = rec.header
        , blocks = rec.blocks
        }


{-| Creates a card toggle element used for toggling the display of the main content of your cards

  - `attributes` List of attributes
  - `children` List of child elements

-}
toggle : List (Html.Attribute msg) -> List (Html.Html msg) -> Toggle msg
toggle attributes children =
    Toggle
        { attributes = attributes
        , children = children
        }


{-| Create a header (div) for an accordion card. It must contain a [`toggle`](#toggle)
element which will be responsible for display/hide the details of an individual card.

You may optionally [`prepend`](#prependHeader) or [`append`](#appendHeader) children to the header for further customization.

  - attributes - List of attributes
  - toggle - A toggle element

-}
header : List (Html.Attribute msg) -> Toggle msg -> Header msg
header =
    headerPrivate Html.div


{-| Create an accordion card header but rather than a div, using a h1 element
-}
headerH1 : List (Html.Attribute msg) -> Toggle msg -> Header msg
headerH1 =
    headerPrivate Html.h1


{-| Create an accordion card header but rather than a div, using a h2 element
-}
headerH2 : List (Html.Attribute msg) -> Toggle msg -> Header msg
headerH2 =
    headerPrivate Html.h2


{-| Create an accordion card header but rather than a div, using a h3 element
-}
headerH3 : List (Html.Attribute msg) -> Toggle msg -> Header msg
headerH3 =
    headerPrivate Html.h3


{-| Create an accordion card header but rather than a div, using a h4 element
-}
headerH4 : List (Html.Attribute msg) -> Toggle msg -> Header msg
headerH4 =
    headerPrivate Html.h4


{-| Create an accordion card header but rather than a div, using a h5 element
-}
headerH5 : List (Html.Attribute msg) -> Toggle msg -> Header msg
headerH5 =
    headerPrivate Html.h5


{-| Create an accordion card header but rather than a div, using a h6 element
-}
headerH6 : List (Html.Attribute msg) -> Toggle msg -> Header msg
headerH6 =
    headerPrivate Html.h6


{-| Add elements before the toggle element in a accordion card header. Order matters if you're using
both prependHeader and appendHeader. Specifically, it should be toggle |> appendHeader |>
prependHeader.
-}
prependHeader : List (Html.Html msg) -> Header msg -> Header msg
prependHeader elements (Header header_) =
    Header { header_ | childrenPreToggle = elements ++ header_.childrenPreToggle }


{-| Add elements after the toggle element in a accordion card header. Order matters if you're using
both prependHeader and appendHeader. Specifically, it should be toggle |> appendHeader |>
prependHeader.
-}
appendHeader : List (Html.Html msg) -> Header msg -> Header msg
appendHeader elements (Header header_) =
    Header { header_ | childrenPostToggle = header_.childrenPostToggle ++ elements }


headerPrivate :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> Toggle msg
    -> Header msg
headerPrivate elemFn attributes toggle_ =
    Header
        { elemFn = elemFn
        , attributes = attributes
        , toggle = toggle_
        , childrenPreToggle = []
        , childrenPostToggle = []
        }


{-| Create a block element for use in an accordion card.

    Accordion.block []
        [ Block.text [] [ text "Just some text" ] ]

  - `blockOptions` List of block options
  - `blockItems` List of block items

-}
block :
    List (Block.Option msg)
    -> List (Block.Item msg)
    -> CardBlock msg
block =
    CardInternal.block


{-| Create a List Group element for use in an accordion.
List groups are block elements just like [`block`](#block)

    Accordion.listGroup
        [ ListGroup.li [] [ text "Item 1" ]
        , ListGroup.li [] [ text "Item 2" ]
        ]

  - `items` List of List group items

-}
listGroup :
    List (ListGroup.Item msg)
    -> CardBlock msg
listGroup =
    CardInternal.listGroup


renderCard :
    State
    -> ConfigRec msg
    -> Card msg
    -> Html.Html msg
renderCard state configRec ((Card { options }) as card_) =
    Html.div
        (CardInternal.cardAttributes options ++ [ class "card" ])
        [ renderCardHeader state configRec card_
        , renderCardBlock state configRec card_
        ]


renderCardHeader :
    State
    -> ConfigRec msg
    -> Card msg
    -> Html.Html msg
renderCardHeader state configRec ((Card cardRec) as card_) =
    let
        (Header headerRec) =
            cardRec.header
    in
    headerRec.elemFn
        (headerRec.attributes ++ [ class "card-header" ])
        (headerRec.childrenPreToggle
            ++ [ renderToggle state configRec card_ ]
            ++ headerRec.childrenPostToggle
        )


renderToggle :
    State
    -> ConfigRec msg
    -> Card msg
    -> Html.Html msg
renderToggle state configRec ((Card cardRec) as card_) =
    let
        (Header headerRec) =
            cardRec.header

        (Toggle { attributes, children }) =
            headerRec.toggle
    in
    Html.button
        ([ class "btn btn-link"
         , custom "click" <|
            clickHandler state configRec heightDecoder card_
         ]
            ++ attributes
        )
        children


clickHandler :
    State
    -> ConfigRec msg
    -> Json.Decoder Float
    -> Card msg
    ->
        Json.Decoder
            { message : msg
            , stopPropagation : Bool
            , preventDefault : Bool
            }
clickHandler ((State cardStates) as state) configRec decoder (Card { id }) =
    let
        currentCardState =
            Dict.get id cardStates
                |> Maybe.withDefault
                    { visibility = Hidden
                    , height = Nothing
                    }

        initStates =
            Dict.insert id currentCardState cardStates

        updOthersHidden h =
            Dict.map
                (\i c ->
                    if i == id then
                        { height = Just h
                        , visibility = visibilityTransition configRec.withAnimation c.visibility
                        }

                    else if c.visibility == Shown && configRec.withAnimation == True && configRec.onlyOneOpen == True then
                        { c | visibility = StartUp }

                    else if c.visibility == Shown && configRec.withAnimation == False && configRec.onlyOneOpen == True then
                        { c | visibility = Hidden }

                    else
                        c
                )
                initStates
                |> State
    in
    decoder
        |> Json.andThen
            (\v ->
                Json.succeed
                    { message = configRec.toMsg <| updOthersHidden v
                    , stopPropagation = True
                    , preventDefault = True
                    }
            )


visibilityTransition : Bool -> Visibility -> Visibility
visibilityTransition withAnimation_ visibility =
    case ( withAnimation_, visibility ) of
        ( True, Hidden ) ->
            StartDown

        ( True, StartDown ) ->
            Shown

        ( True, Shown ) ->
            StartUp

        ( True, StartUp ) ->
            Hidden

        ( False, Hidden ) ->
            Shown

        ( False, Shown ) ->
            Hidden

        _ ->
            Shown


heightDecoder : Json.Decoder Float
heightDecoder =
    Json.field "currentTarget" <|
        DomHelper.parentElement <|
            DomHelper.nextSibling <|
                DomHelper.childNode 0 <|
                    DomHelper.offsetHeight


renderCardBlock :
    State
    -> ConfigRec msg
    -> Card msg
    -> Html.Html msg
renderCardBlock state configRec ((Card { id, blocks }) as card_) =
    Html.div
        ([ Html.Attributes.id id ] ++ animationAttributes state configRec card_)
        [ Html.div [] (CardInternal.renderBlocks blocks) ]


animationAttributes :
    State
    -> ConfigRec msg
    -> Card msg
    -> List (Html.Attribute msg)
animationAttributes state configRec (Card { id }) =
    let
        cardState =
            getOrInitCardState id state

        pixelHeight =
            Maybe.map (\v -> String.fromFloat v ++ "px") cardState.height
                |> Maybe.withDefault "0"

        styles =
            transitionStyle configRec.withAnimation
    in
    case cardState.visibility of
        Hidden ->
            styles "0px"

        StartDown ->
            styles "0px"

        StartUp ->
            styles pixelHeight

        Shown ->
            case cardState.height of
                Just x ->
                    styles pixelHeight

                Nothing ->
                    styles "100%"


transitionStyle : Bool -> String -> List (Html.Attribute msg)
transitionStyle withAnimation_ height =
    [ style "position" "relative"
    , style "height" height
    , style "overflow" "hidden"
    ]
        ++ (if withAnimation_ == True then
                [ style "-webkit-transition-timing-function" "ease"
                , style "-o-transition-timing-function" "ease"
                , style "transition-timing-function" "ease"
                , style "-webkit-transition-duration" "0.35s"
                , style "-o-transition-duration" "0.35s"
                , style "transition-duration" "0.35s"
                , style "-webkit-transition-property" "height"
                , style "-o-transition-property" "height"
                , style "transition-property" "height"
                ]

            else
                []
           )


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
