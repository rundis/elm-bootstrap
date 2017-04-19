module Bootstrap.Carousel exposing (..)

{-|
item-left
-}

import Html exposing (div, text, span, a)
import Html.Attributes as Attributes exposing (class, classList, attribute, href)
import Html.Events exposing (onClick, on)
import Html.Keyed as Keyed
import Json.Decode as Decode
import Bootstrap.Slide as Slide
import Time
import AnimationFrame


{-| Opaque type that defines the view configuration of your carousel
-}
type Config msg
    = Config
        { id : String
        , toMsg : Msg -> msg
        , options : List (CarouselOption msg)
        , slides : List (Slide.Config msg)
        , controls : Bool
        , indicators : Bool
        }


type Transition
    = Next
    | Prev
    | Number Int
    | None


type Msg
    = Cycle
    | Pause
    | StartTransition Transition
    | SetAnimating
    | EndTransition


type RunningState
    = Inactive
    | Paused
    | Active


type alias Activity =
    { state : RunningState, interval : Int }


type alias StateSettings =
    { currentIndex : Int, activity : Activity }


type TransitionState a
    = Start a
    | Animating a
    | NotAnimating


{-| State is indexed by the `TransitionState Transition` type,
to easily pattern match on the states the model can be in.
-}
type State
    = State (TransitionState Transition) StateSettings


initialState : RunningState -> Int -> Maybe Int -> State
initialState running interval mStartIndex =
    let
        startIndex =
            Maybe.withDefault 0 mStartIndex
    in
        State NotAnimating { currentIndex = startIndex, activity = { state = running, interval = interval } }


{-| The subscriptions

currently only requests an animation frame when starting a transition. will
also do interval-based transition to the next slide later.
-}
subscriptions : State -> (Msg -> msg) -> Sub msg
subscriptions model toMsg =
    case model of
        State NotAnimating settings ->
            Sub.none

        State (Start transition) settings ->
            AnimationFrame.times (\_ -> toMsg SetAnimating)

        State (Animating transition) settings ->
            Sub.none


update : Msg -> State -> State
update message ((State tstate ({ currentIndex, activity } as settings)) as model) =
    case message of
        Pause ->
            State tstate { settings | activity = { activity | state = Paused } }

        Cycle ->
            State tstate { settings | activity = { activity | state = Active } }

        StartTransition transition ->
            State (Start transition) settings

        SetAnimating ->
            case tstate of
                NotAnimating ->
                    model

                Start transition ->
                    State (Animating transition) settings

                Animating transition ->
                    State (Animating transition) settings

        EndTransition ->
            case tstate of
                NotAnimating ->
                    -- should never happen
                    model

                _ ->
                    State NotAnimating { settings | currentIndex = nextIndex tstate currentIndex }


{-| Calculate the next index based on the current state

This is hardcoded to cycle between the first 3 slides for now
-}
nextIndex : TransitionState Transition -> Int -> Int
nextIndex state currentIndex =
    let
        helper transition =
            case transition of
                Next ->
                    (currentIndex + 1) % 3

                Prev ->
                    (currentIndex - 1) % 3

                Number m ->
                    m % 3

                None ->
                    currentIndex
    in
        case state of
            Start transition ->
                helper transition

            Animating transition ->
                helper transition

            NotAnimating ->
                currentIndex


config : String -> (Msg -> msg) -> List (CarouselOption msg) -> Config msg
config id toMsg options =
    Config
        { id = id
        , toMsg = toMsg
        , options = options
        , slides = []
        , controls = False
        , indicators = False
        }


view : State -> Config msg -> Html.Html msg
view model (Config settings) =
    let
        (State tstate { currentIndex, activity }) =
            model

        indicatorsHtml =
            if settings.indicators then
                indicators settings.id (List.length settings.slides) (nextIndex tstate currentIndex)
            else
                text ""

        slidesHtml =
            div [ class "carousel-inner", attribute "role" "listbox" ]
                (List.indexedMap (viewSlide model) settings.slides)

        controlsHtml =
            if settings.controls then
                [ controlPrev settings.id, controlNext settings.id ]
            else
                []

        {- catch the transitionend event, to end an ongoing transition -}
        defaultCarouselAttributes =
            [ Attributes.id settings.id
            , class "carousel slide"
            , on "transitionend" (Decode.succeed (settings.toMsg EndTransition))
            ]
    in
        div (List.concatMap carouselOptionToAttributes settings.options ++ defaultCarouselAttributes)
            (Html.map settings.toMsg indicatorsHtml :: slidesHtml :: (List.map (Html.map settings.toMsg) controlsHtml))


{-| Sets the correct classes to the current and (potentially) next element.
-}
viewSlide : State -> Int -> Slide.Config msg -> Html.Html msg
viewSlide ((State tstate { currentIndex }) as model) index slide =
    let
        newIndex =
            nextIndex tstate currentIndex

        classNames transition =
            let
                base =
                    "carousel-item"
            in
                case transition of
                    Next ->
                        { directionalClassName = base ++ "-left", orderClassName = base ++ "-next" }

                    Number n ->
                        if n > currentIndex then
                            { directionalClassName = base ++ "-left", orderClassName = base ++ "-next" }
                        else
                            { directionalClassName = base ++ "-right", orderClassName = base ++ "-prev" }

                    _ ->
                        { directionalClassName = base ++ "-right", orderClassName = base ++ "-prev" }

        classes =
            if index == currentIndex then
                case tstate of
                    NotAnimating ->
                        [ ( "active", True ) ]

                    Start transition ->
                        [ ( "active", True )
                        ]

                    Animating transition ->
                        let
                            { directionalClassName } =
                                classNames transition
                        in
                            [ ( "active", True )
                            , ( directionalClassName, True )
                            ]
            else if index == newIndex then
                case tstate of
                    NotAnimating ->
                        []

                    Start transition ->
                        [ ( .orderClassName (classNames transition), True )
                        ]

                    Animating transition ->
                        let
                            { directionalClassName, orderClassName } =
                                classNames transition
                        in
                            [ ( directionalClassName, True )
                            , ( orderClassName, True )
                            ]
            else
                []
    in
        slide
            |> Slide.removeActive
            |> Slide.addAttributes [ classList classes ]
            |> Slide.view


slides : List (Slide.Config msg) -> Config msg -> Config msg
slides newSlides (Config settings) =
    Config { settings | slides = newSlides }


withIndicators : Config msg -> Config msg
withIndicators (Config settings) =
    Config { settings | indicators = True }


withControls : Config msg -> Config msg
withControls (Config settings) =
    Config { settings | controls = True }


controlPrev : String -> Html.Html Msg
controlPrev id =
    a [ class "carousel-control-prev", href ("#" ++ id), attribute "role" "button", attribute "data-slide" "prev", onClick (StartTransition Prev) ]
        [ span [ class "carousel-control-prev-icon", attribute "aria-hidden" "true" ] []
        , span [ class "sr-only" ] [ text "Previous" ]
        ]


controlNext : String -> Html.Html Msg
controlNext id =
    a [ class "carousel-control-next", href ("#" ++ id), attribute "role" "button", attribute "data-slide" "next", onClick (StartTransition Next) ]
        [ span [ class "carousel-control-next-icon", attribute "aria-hidden" "true" ] []
        , span [ class "sr-only" ] [ text "Next" ]
        ]


indicators : String -> Int -> Int -> Html.Html Msg
indicators id size activeIndex =
    let
        item n =
            Html.li
                [ attribute "data-target" ("#" ++ id)
                , attribute "data-slide-to" (toString n)
                , classList [ ( "active", n == activeIndex ) ]
                , onClick (StartTransition (Number n))
                ]
                []

        items =
            List.range 0 (size - 1)
                |> List.map item
    in
        Html.ol [ class "carousel-indicators" ] items


type AutoPlay
    = AfterFirst
    | OnLoad


type CarouselOption msg
    = Interval Int
    | Keyboard Bool
    | PauseOnHover Bool
    | AutoPlay AutoPlay
    | Wrap Bool
    | Attrs (List (Html.Attribute msg))


boolToJsString bool =
    case bool of
        True ->
            "true"

        False ->
            "false"


interval : Int -> CarouselOption msg
interval =
    Interval


keyboard : Bool -> CarouselOption msg
keyboard =
    Keyboard


pauseOnHover : Bool -> CarouselOption msg
pauseOnHover =
    PauseOnHover


autoPlay : AutoPlay -> CarouselOption msg
autoPlay =
    AutoPlay


wrap : Bool -> CarouselOption msg
wrap =
    Wrap


attrs : List (Html.Attribute msg) -> CarouselOption msg
attrs =
    Attrs


carouselOptionToAttributes : CarouselOption msg -> List (Html.Attribute msg)
carouselOptionToAttributes option =
    case option of
        Interval n ->
            [ attribute "data-interval" (toString n) ]

        Keyboard b ->
            [ attribute "data-keyboard" (boolToJsString b) ]

        PauseOnHover pause ->
            let
                value =
                    if pause then
                        "hover"
                    else
                        "null"
            in
                [ attribute "data-pause" value ]

        AutoPlay setting ->
            let
                value =
                    case setting of
                        AfterFirst ->
                            "false"

                        OnLoad ->
                            "carousel"
            in
                [ attribute "data-ride" value ]

        Wrap b ->
            [ attribute "data-wrap" (boolToJsString b) ]

        Attrs attrs ->
            attrs
