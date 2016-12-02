module Bootstrap.Accordion
    exposing
        ( accordion
        , cardToggle
        , cardBlock
        , card
        , toggleContainer
        , cardHidden
        , cardVisible
        , CardState
        , Card
        , CardBlock
        , CardToggle
        , ToggleContainer
        )

import Html
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick, on)
import Json.Decode as Json
import DOM




type CardState
    = CardState
        { visibility : Visibility
        , height : Maybe Float
        }

type Visibility
    = Hidden
    | Animating
    | Shown


type Card msg
    = Card
        { toggle : CardToggle msg
        , toggleContainer : Maybe (ToggleContainer msg)
        , block : CardBlock msg
        , state : CardState
        , toMsg : CardState -> msg
        }


type CardToggle msg
    = CardToggle
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


type ToggleContainer msg
    = ToggleContainer
        { elemFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
        , attributes : List (Html.Attribute msg)
        , childrenPreToggle : List (Html.Html msg)
        , childrenPostToggle : List (Html.Html msg)
        }


type CardBlock msg
    = CardBlock { children : List (Html.Html msg) }


cardVisible : CardState
cardVisible =
    CardState
        { visibility = Shown
        , height = Nothing
        }


cardHidden : CardState
cardHidden =
    CardState
        { visibility = Hidden
        , height = Nothing
        }


accordion : List (Card msg) -> Html.Html msg
accordion cards =
    Html.div
        []
        (List.map renderCard cards)


card :
    { block : CardBlock msg
    , state : CardState
    , toMsg : CardState -> msg
    , toggle : CardToggle msg
    , toggleContainer : Maybe (ToggleContainer msg)
    }
    -> Card msg
card { toggle, toggleContainer, block, state, toMsg } =
    Card
        { toggle = toggle
        , toggleContainer = toggleContainer
        , block = block
        , state = state
        , toMsg = toMsg
        }


cardToggle : List (Html.Attribute msg) -> List (Html.Html msg) -> CardToggle msg
cardToggle attributes children =
    CardToggle
        { attributes = attributes
        , children = children
        }


toggleContainer :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> List (Html.Html msg)
    -> ToggleContainer msg
toggleContainer elemFn attributes childrenPreToggle childrenPostToggle =
    ToggleContainer
        { elemFn = elemFn
        , attributes = attributes
        , childrenPreToggle = childrenPreToggle
        , childrenPostToggle = childrenPostToggle
        }



-- Hm ... why no attributes here


cardBlock : List (Html.Html msg) -> CardBlock msg
cardBlock children =
    CardBlock
        { children = children }


renderCard : Card msg -> Html.Html msg
renderCard (Card { toggle, toggleContainer, block, toMsg, state }) =
    Html.div
        [ class "card" ]
        [ renderCardHeader toggle toggleContainer toMsg state
        , renderCardBlock block state
        ]


renderCardHeader :
    CardToggle msg
    -> Maybe (ToggleContainer msg)
    -> (CardState -> msg)
    -> CardState
    -> Html.Html msg
renderCardHeader toggle toggleContainer toMsg state =
    let
        toggleElem =
            renderCardToggle toggle toMsg state
    in
        Html.div
            [ class "card-header" ]
            (case toggleContainer of
                Nothing ->
                    [ toggleElem ]

                Just (ToggleContainer { elemFn, attributes, childrenPreToggle, childrenPostToggle }) ->
                    [ elemFn attributes <|
                        List.concat
                            [ childrenPreToggle
                            , [ toggleElem ]
                            , childrenPostToggle
                            ]
                    ]
            )


renderCardToggle :
    CardToggle msg
    -> (CardState -> msg)
    -> CardState
    -> Html.Html msg
renderCardToggle (CardToggle { attributes, children }) toMsg ((CardState state) as cardState) =
    Html.a
        ([ href "#"
         , onClick <| handleClick toMsg cardState
         , on "click" <| clickHandler toMsg cardState
         ]
            ++ attributes
        )
        children


clickHandler : (CardState -> msg) -> CardState -> Json.Decoder msg
clickHandler toMsg (CardState state) =
    geometryDecoder
        |> Json.andThen
            (\v ->
                let
                    _ = Debug.log "Height: " v
                in
                    Json.succeed
                        <| toMsg
                            <| CardState
                                {state | height = Just v
                                       , visibility = visibilityTransition state.visibility
                                }
            )

visibilityTransition : Visibility -> Visibility
visibilityTransition visibility =
    case visibility of
        Hidden ->
            Shown

        Animating ->
            visibility

        Shown ->
            Hidden



geometryDecoder : Json.Decoder Float
geometryDecoder =
    DOM.target
        <| DOM.parentElement
        <| DOM.parentElement
        <| DOM.nextSibling
        <| DOM.offsetHeight


handleClick : (CardState -> msg) -> CardState -> msg
handleClick toMsg (CardState state) =
    toMsg <|
        CardState <|
            case state.visibility of
                Hidden ->
                    { state | visibility = Shown }

                Animating ->
                    state

                Shown ->
                    { state | visibility = Hidden }


renderCardBlock : CardBlock msg -> CardState -> Html.Html msg
renderCardBlock (CardBlock { children }) (CardState state) =
    Html.div
        [ class <| visibilityClass state.visibility ]
        [ Html.div
            [ class "card-block" ]
            children
        ]


visibilityClass : Visibility -> String
visibilityClass visibility =
    case visibility of
        Hidden ->
            "collapse"

        Animating ->
            "collapsing"

        Shown ->
            "collapse in"
