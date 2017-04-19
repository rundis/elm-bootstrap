module Bootstrap.Carousel
    exposing
        ( Msg
        , State
        , Config
        , initialState
        , initialStateWithOptions
        , defaultStateOptions
        , update
        , view
        , subscriptions
        , AutoPlay(..)
        , config
        , slides
        , withControls
        , withIndicators
        , next
        , prev
        , toSlide
        )

{-| A carousel is a slideshow for cycling through a series of content.

# Model
@docs State, initialState, initialStateWithOptions, defaultStateOptions, AutoPlay

# Update
@docs update, next, prev, toSlide

# View
@docs Config, config, view, slides, withControlers, withIndicators

# Subscriptions
@docs subscriptions
-}

import Html exposing (div, text, span, a)
import Html.Attributes as Attributes exposing (class, classList, attribute, href)
import Html.Events exposing (onClick, on, onMouseEnter, onMouseLeave)
import Html.Keyed as Keyed
import Json.Decode as Decode
import Bootstrap.Slide as Slide
import Time
import AnimationFrame


--- Model ---


{-| State is indexed by the `TransitionStage Transition` type,
to easily pattern match on the states the model can be in.
-}
type State
    = State (TransitionStage Transition) StateSettings


type alias StateSettings =
    { currentIndex : Int
    , running : AutoPlay
    , interval : Int
    , hovered : Maybe Bool
    , keyboard : Bool
    , wrap : Bool
    }


{-| Our state can be in three stages of animating

* `NotAnimating`: No animation is happening. A new animation can be started
* `Start`: Used to trigger proper css animations, Is swapped to Animating on the next animation frame. No new animation can be started
* `Animating`: A transition is in progress. No new animation can be started.
-}
type TransitionStage a
    = Start a
    | Animating a
    | NotAnimating


{-| Move to another slide
-}
type Transition
    = Next
    | Prev
    | Number Int


{-| when to start automatically cycling the slides

* `Inactive`: never start cycling
* `Paused`: frozen on the current slide
* `Active`: immediately start cycling
* `WaitForUser`: Wait for the user to perform one transition, then cycle automatically
-}
type AutoPlay
    = Inactive
    | Paused
    | Active
    | WaitForUser



--- Init ---


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
    , ride = Active
    , wrap = True
    , startIndex = 0
    }


initialStateWithOptions : StateOptions -> State
initialStateWithOptions options =
    State NotAnimating
        { currentIndex = options.startIndex
        , interval = Maybe.withDefault 0 options.interval
        , running = options.ride
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
            -- don't trigger new animations when already animating
            Sub.none



--- Update ---


type Msg
    = Cycle
    | Pause
    | StartTransition Transition
    | SetAnimating
    | EndTransition
    | SetHover Bool


update : Msg -> State -> State
update message ((State tstage ({ currentIndex, hovered } as settings)) as model) =
    case message of
        Pause ->
            State tstage { settings | running = Paused }

        Cycle ->
            State tstage { settings | running = Active }

        SetHover isHovered ->
            State tstage { settings | hovered = Maybe.map (\_ -> isHovered) hovered }

        StartTransition transition ->
            let
                newSettings =
                    case settings.running of
                        WaitForUser ->
                            -- the user has clicked something, so we can now automatically cycle
                            { settings | running = Active }

                        _ ->
                            settings
            in
                case tstage of
                    NotAnimating ->
                        if nextIndex (Start transition) currentIndex /= currentIndex then
                            State (Start transition) newSettings
                        else
                            -- don't do anything if animating to the current index
                            State tstage newSettings

                    _ ->
                        -- don't start another animation when one is running
                        State tstage newSettings

        SetAnimating ->
            case tstage of
                NotAnimating ->
                    model

                Start transition ->
                    State (Animating transition) settings

                Animating transition ->
                    State (Animating transition) settings

        EndTransition ->
            case tstage of
                NotAnimating ->
                    -- should never happen
                    model

                _ ->
                    State NotAnimating { settings | currentIndex = nextIndex tstage currentIndex }


{-| Move the carousel to the next slide.

When the transition is invalid, nothing will happen.
-}
next : State -> State
next =
    update (StartTransition Next)


{-| Move the carousel to the previous slide.

When the transition is invalid, nothing will happen.
-}
prev : State -> State
prev =
    update (StartTransition Prev)


{-| Move the carousel to the nth slide

When the transition is invalid, nothing will happen.
-}
toSlide : Int -> State -> State
toSlide n =
    update (StartTransition (Number n))


{-| Calculate the next index based on the current state

This is hardcoded to cycle between the first 3 slides for now
-}
nextIndex : TransitionStage Transition -> Int -> Int
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
    in
        case state of
            Start transition ->
                helper transition

            Animating transition ->
                helper transition

            NotAnimating ->
                currentIndex



--- View ---


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


view : State -> Config msg -> Html.Html msg
view model (Config settings) =
    let
        (State tstage { currentIndex, wrap }) =
            model

        size =
            List.length settings.slides

        indicatorsHtml =
            if settings.indicators then
                indicators settings.id (List.length settings.slides) (nextIndex tstage currentIndex)
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

        defaultCarouselAttributes =
            -- catch the transitionend event, to end an ongoing transition
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
viewSlide ((State tstage { currentIndex }) as model) index slide =
    let
        newIndex =
            nextIndex tstage currentIndex

        classNames transition =
            let
                base =
                    "carousel-item"

                leftNext =
                    { directionalClassName = base ++ "-left", orderClassName = base ++ "-next" }

                rightPrev =
                    { directionalClassName = base ++ "-right", orderClassName = base ++ "-prev" }
            in
                case transition of
                    Next ->
                        leftNext

                    Number n ->
                        if n > currentIndex then
                            leftNext
                        else
                            rightPrev

                    _ ->
                        rightPrev

        classes =
            if index == currentIndex then
                case tstage of
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
                case tstage of
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
    a [ class "carousel-control-prev", attribute "role" "button", onClick (StartTransition Prev) ]
        [ span [ class "carousel-control-prev-icon", attribute "aria-hidden" "true" ] []
        , span [ class "sr-only" ] [ text "Previous" ]
        ]


controlNext : String -> Html.Html Msg
controlNext id =
    a [ class "carousel-control-next", attribute "role" "button", onClick (StartTransition Next) ]
        [ span [ class "carousel-control-next-icon", attribute "aria-hidden" "true" ] []
        , span [ class "sr-only" ] [ text "Next" ]
        ]


indicators : String -> Int -> Int -> Html.Html Msg
indicators id size activeIndex =
    let
        item n =
            Html.li
                [ classList [ ( "active", n == activeIndex ) ]
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
