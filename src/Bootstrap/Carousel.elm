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


unTransitionState ts =
    case ts of
        Start x ->
            x

        Animating x ->
            x


type State
    = Static StateSettings
    | Transitioning (TransitionState Transition) StateSettings


initialState running interval mStartIndex =
    let
        startIndex =
            Maybe.withDefault 0 mStartIndex
    in
        Static { currentIndex = startIndex, activity = { state = running, interval = interval } }


getSettings model =
    case model of
        Static settings ->
            settings

        Transitioning _ settings ->
            settings


subscriptions : State -> (Msg -> msg) -> Sub msg
subscriptions model toMsg =
    case model of
        Static settings ->
            Sub.none

        Transitioning (Start transition) settings ->
            AnimationFrame.times (\_ -> toMsg SetAnimating)

        Transitioning (Animating transition) settings ->
            Sub.none


update : Msg -> State -> State
update message model =
    case model of
        Static ({ currentIndex, activity } as settings) ->
            case message of
                Pause ->
                    Static { settings | activity = { activity | state = Paused } }

                Cycle ->
                    Static { settings | activity = { activity | state = Active } }

                StartTransition transition ->
                    Transitioning (Start transition) settings

                SetAnimating ->
                    model

                EndTransition ->
                    model

        Transitioning transition ({ currentIndex, activity } as settings) ->
            case message of
                Pause ->
                    Transitioning transition { settings | activity = { activity | state = Paused } }

                Cycle ->
                    Transitioning transition { settings | activity = { activity | state = Active } }

                StartTransition transition ->
                    Transitioning (Start transition) settings

                SetAnimating ->
                    case transition of
                        Start t ->
                            Transitioning (Animating t) settings

                        Animating t ->
                            Transitioning (Animating t) settings

                EndTransition ->
                    Static { settings | currentIndex = nextIndex (unTransitionState transition) currentIndex }


transitionToClassnames : Transition -> { directionalClassName : String, bidirectionalClassName : String, orderClassName : String }
transitionToClassnames transition =
    let
        base =
            "carousel-item"
    in
        case transition of
            Next ->
                { directionalClassName = base ++ "-left", orderClassName = base ++ "-next", bidirectionalClassName = base ++ "-right" }

            _ ->
                { directionalClassName = base ++ "-right", orderClassName = base ++ "-prev", bidirectionalClassName = base ++ "-left" }


nextIndex : Transition -> Int -> Int
nextIndex transition currentIndex =
    case transition of
        Next ->
            (currentIndex + 1) % 3

        Prev ->
            (currentIndex - 1) % 3

        Number m ->
            m % 3

        None ->
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
        { currentIndex, activity } =
            getSettings model

        indicatorsHtml =
            if settings.indicators then
                indicators settings.id (List.length settings.slides) currentIndex
            else
                text ""

        slidesHtml =
            div [ class "carousel-inner", attribute "role" "listbox" ]
                (List.indexedMap
                    (\i slide ->
                        case model of
                            Static _ ->
                                if i == currentIndex then
                                    slide
                                        |> Slide.addActive
                                        |> Slide.view
                                else
                                    slide
                                        |> Slide.removeActive
                                        |> Slide.view

                            Transitioning (Start transition) _ ->
                                let
                                    names =
                                        transitionToClassnames transition
                                in
                                    if i == currentIndex then
                                        slide
                                            |> Slide.addActive
                                            |> Slide.view
                                    else if i == nextIndex transition currentIndex then
                                        slide
                                            |> Slide.removeActive
                                            |> Slide.addAttributes [ class names.orderClassName ]
                                            |> Slide.view
                                    else
                                        slide
                                            |> Slide.removeActive
                                            |> Slide.view

                            Transitioning (Animating transition) _ ->
                                let
                                    names =
                                        transitionToClassnames transition
                                in
                                    if i == currentIndex then
                                        slide
                                            |> Slide.addActive
                                            |> Slide.addAttributes [ class names.directionalClassName ]
                                            |> Slide.view
                                    else if i == nextIndex transition currentIndex then
                                        slide
                                            |> Slide.removeActive
                                            |> Slide.addAttributes [ class names.directionalClassName, class names.orderClassName ]
                                            |> Slide.view
                                    else
                                        slide
                                            |> Slide.removeActive
                                            |> Slide.view
                    )
                    settings.slides
                )

        controlsHtml =
            if settings.controls then
                [ controlPrev settings.id, controlNext settings.id ]
            else
                []

        defaultCarouselAttributes =
            [ Attributes.id settings.id
            , class "carousel slide"
            , on "transitionend" (Decode.succeed (settings.toMsg EndTransition))
            ]
    in
        div (List.concatMap carouselOptionToAttributes settings.options ++ defaultCarouselAttributes)
            (Html.map settings.toMsg indicatorsHtml :: slidesHtml :: (List.map (Html.map settings.toMsg) controlsHtml))


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


indicators : String -> Int -> Int -> Html.Html msg
indicators id size activeIndex =
    let
        item n =
            Html.li [ attribute "data-target" ("#" ++ id), attribute "data-slide-to" (toString n), classList [ ( "active", n == activeIndex ) ] ] []

        items =
            List.range 0 (size - 1)
                |> List.map item
    in
        Html.ol [ class "carousel-indicators" ] items



{-
   Carousel.config "myCarousel" [ Carousel.interval 5000 ]
       |> Carousel.slides []
       |> Carousel.withIndicators
       |> Carousel.withControls
-}


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
