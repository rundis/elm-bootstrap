module Bootstrap.Carousel exposing (..)

{-|
item-left
-}

import Html exposing (div, text, span, a)
import Html.Attributes as Attributes exposing (class, classList, attribute, href)
import Html.Events exposing (onClick, on, onMouseEnter, onMouseLeave)
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
    | SetHover Bool


type alias StateSettings =
    { currentIndex : Int
    , running : RunningState
    , interval : Int
    , hovered : Maybe Bool
    , keyboard : Bool
    , wrap : Bool
    }


type TransitionState a
    = Start a
    | Animating a
    | NotAnimating


{-| State is indexed by the `TransitionState Transition` type,
to easily pattern match on the states the model can be in.
-}
type State
    = State (TransitionState Transition) StateSettings


type alias StateOptions =
    { interval : Maybe Int
    , keyboard : Bool
    , pauseOnHover : Bool
    , ride : AutoPlay
    , wrap : Bool
    , startIndex : Int
    }


defaultStateOptions : StateOptions
defaultStateOptions =
    { interval = Just 5000
    , keyboard = True
    , pauseOnHover = True
    , ride = OnLoad
    , wrap = True
    , startIndex = 0
    }


type AutoPlay
    = AfterFirst
    | OnLoad
    | NoAutoPlay


type RunningState
    = Inactive
    | Paused
    | Active
    | WaitForUser


initialStateWithOptions : StateOptions -> State
initialStateWithOptions options =
    State NotAnimating
        { currentIndex = options.startIndex
        , interval = Maybe.withDefault 0 options.interval
        , running =
            case options.ride of
                OnLoad ->
                    Active

                AfterFirst ->
                    WaitForUser

                NoAutoPlay ->
                    Inactive
        , hovered =
            if options.pauseOnHover then
                Just False
            else
                Nothing
        , keyboard = options.keyboard
        , wrap = options.wrap
        }


initialState : State
initialState =
    initialStateWithOptions defaultStateOptions


{-| The subscriptions

-}
subscriptions : State -> (Msg -> msg) -> Sub msg
subscriptions model toMsg =
    case model of
        State NotAnimating settings ->
            let
                interval =
                    settings.interval

                active =
                    settings.running == Active
            in
                if active && settings.hovered == Just False && interval /= 0 then
                    Time.every (toFloat interval * Time.millisecond) (\_ -> toMsg <| StartTransition Next)
                else
                    Sub.none

        State (Start transition) settings ->
            -- request an animation frame to trigger the start of css transitions
            AnimationFrame.times (\_ -> toMsg SetAnimating)

        State (Animating transition) settings ->
            -- don't trigger new animations when animating
            Sub.none


update : Msg -> State -> State
update message ((State tstate ({ currentIndex, hovered } as settings)) as model) =
    case message of
        Pause ->
            State tstate { settings | running = Paused }

        Cycle ->
            State tstate { settings | running = Active }

        SetHover isHovered ->
            State tstate { settings | hovered = Maybe.map (\_ -> isHovered) hovered }

        StartTransition transition ->
            let
                newSettings =
                    case settings.running of
                        WaitForUser ->
                            -- the user has clicked something, so we can now cycle
                            { settings | running = Active }

                        _ ->
                            settings
            in
                case tstate of
                    NotAnimating ->
                        if nextIndex (Start transition) currentIndex /= currentIndex then
                            State (Start transition) newSettings
                        else
                            -- don't do anything if animating to the current index
                            State tstate newSettings

                    _ ->
                        -- don't start another animation when one is running
                        State tstate newSettings

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


view : State -> Config msg -> Html.Html msg
view model (Config settings) =
    let
        (State tstate { currentIndex, wrap }) =
            model

        size =
            List.length settings.slides

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
                if wrap || (currentIndex /= 0 && currentIndex /= size - 1) then
                    [ controlPrev settings.id, controlNext settings.id ]
                else if currentIndex == 0 then
                    [ controlNext settings.id ]
                else
                    [ controlPrev settings.id ]
            else
                []

        {- catch the transitionend event, to end an ongoing transition -}
        defaultCarouselAttributes =
            [ Attributes.id settings.id
            , class "carousel slide"
            , on "transitionend" (Decode.succeed (settings.toMsg EndTransition))
            , onMouseEnter (settings.toMsg <| SetHover True)
            , onMouseLeave (settings.toMsg <| SetHover False)
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


type CarouselOption msg
    = Attrs (List (Html.Attribute msg))


config : String -> (Msg -> msg) -> List (CarouselOption msg) -> Config msg
config id toMsg options =
    Config
        { id = id
        , options = options
        , toMsg = toMsg
        , slides = []
        , controls = False
        , indicators = False
        }


attrs : List (Html.Attribute msg) -> CarouselOption msg
attrs =
    Attrs


carouselOptionToAttributes : CarouselOption msg -> List (Html.Attribute msg)
carouselOptionToAttributes option =
    case option of
        Attrs attrs ->
            attrs
