module Bootstrap.Accordion
    exposing
        ( accordion
        , cardToggle
        , cardBlock
        , card
        , toggleContainer
        , cardHidden
        , cardVisible
        , subscriptions
        , CardState
        , Card
        , CardBlock
        , CardToggle
        , ToggleContainer
        )

import Html
import Html.Attributes exposing (class, href, style)
import Html.Events exposing (onClick, on)
import Json.Decode as Json
import DOM
import AnimationFrame


type CardState
    = CardState
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


type Card msg
    = Card
        { toggle : CardToggle msg
        , toggleContainer : Maybe (ToggleContainer msg)
        , block : CardBlock msg
        , state : CardState
        , toMsg : CardState -> msg
        , withAnimation : Bool
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


subscriptions : (CardState -> msg) -> CardState -> Sub msg
subscriptions toMsg (CardState state) =
    case state.visibility of
        StartDown ->
            AnimationFrame.times
                (\_ -> toMsg <| CardState { state | visibility = AnimatingDown })

        StartUp ->
            AnimationFrame.times
                (\_ -> toMsg <| CardState { state | visibility = AnimatingUp })

        _ ->
            Sub.none


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
    , withAnimation : Bool
    }
    -> Card msg
card { toggle, toggleContainer, block, state, toMsg, withAnimation } =
    Card
        { toggle = toggle
        , toggleContainer = toggleContainer
        , block = block
        , state = state
        , toMsg = toMsg
        , withAnimation = withAnimation
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
renderCard card =
    Html.div
        [ class "card" ]
        [ renderCardHeader card
        , renderCardBlock card
        ]


renderCardHeader :
    Card msg
    -> Html.Html msg
renderCardHeader ((Card { toggleContainer }) as card) =
    Html.div
        [ class "card-header" ]
        (case toggleContainer of
            Nothing ->
                [ renderCardToggle False card ]

            Just (ToggleContainer { elemFn, attributes, childrenPreToggle, childrenPostToggle }) ->
                [ elemFn attributes <|
                    List.concat
                        [ childrenPreToggle
                        , [ renderCardToggle True card ]
                        , childrenPostToggle
                        ]
                ]
        )


renderCardToggle :
    Bool
    -> Card msg
    -> Html.Html msg
renderCardToggle isContained ((Card { toggle }) as card) =
    --  (CardToggle { attributes, children }) toMsg cardState =
    let
        (CardToggle { attributes, children }) =
            toggle
    in
        Html.a
            ([ href "#"
             , on "click" <| clickHandler (heightDecoder isContained) card
             ]
                ++ attributes
            )
            children


clickHandler :
    Json.Decoder Float
    -> Card msg
    -> Json.Decoder msg
clickHandler decoder (Card { toMsg, state, withAnimation }) =
    let
        (CardState stateRec) =
            state
    in
        decoder
            |> Json.andThen
                (\v ->
                    Json.succeed <|
                        toMsg <|
                            CardState
                                { stateRec
                                    | height = Just v
                                    , visibility = visibilityTransition withAnimation stateRec.visibility
                                }
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
    Card msg
    -> Html.Html msg
renderCardBlock (Card { toMsg, state, withAnimation, block }) =
    --toMsg (CardBlock { children }) state =
    let
        (CardBlock { children }) =
            block
    in
        Html.div
            (animationAttributes toMsg state withAnimation)
            --class <| visibilityClass state.visibility ]
            [ Html.div
                [ class "card-block" ]
                children
            ]


animationAttributes :
    (CardState -> msg)
    -> CardState
    -> Bool
    -> List (Html.Attribute msg)
animationAttributes toMsg ((CardState { visibility, height }) as cardState) withAnimation =
    let
        pixelHeight =
            Maybe.map (\v -> (toString v) ++ "px") height
                |> Maybe.withDefault "0"
    in
        case visibility of
            Hidden ->
                [ style [ ( "overflow", "hidden" ), ( "height", "0" ) ] ]

            StartDown ->
                [ style [ ( "overflow", "hidden" ), ( "height", "0" ) ] ]

            AnimatingDown ->
                [ transitionStyle pixelHeight
                , on "transitionend" <|
                    transitionHandler toMsg cardState withAnimation
                ]

            AnimatingUp ->
                [ transitionStyle "0px"
                , on "transitionend" <|
                    transitionHandler toMsg cardState withAnimation
                ]

            StartUp ->
                [ style [ ( "height", pixelHeight ) ] ]

            Shown ->
                [ style [ ( "height", pixelHeight ) ] ]


transitionHandler : (CardState -> msg) -> CardState -> Bool -> Json.Decoder msg
transitionHandler toMsg (CardState state) withAnimation =
    Json.succeed <|
        toMsg <|
            CardState
                { state | visibility = visibilityTransition withAnimation state.visibility }


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
