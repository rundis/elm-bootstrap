module Bootstrap.Carousel
    exposing
        ( Msg
        , State
        , Config
        , StateOptions
        , initialState
        , initialStateWithOptions
        , defaultStateOptions
        , update
        , view
        , subscriptions
        , Cycling
        , config
        , slides
        , withControls
        , withIndicators
        , next
        , prev
        , toSlide
        , pause
        , cycle
        )

{-| A carousel is a slideshow for cycling through a series of content.

# Model
@docs State, StateOptions, initialState, initialStateWithOptions, defaultStateOptions, Cycling

# Update
@docs update, Msg, next, prev, toSlide, pause, cycle

# View
@docs Config, config, view, slides, withControls, withIndicators

# Subscriptions
@docs subscriptions
-}

import Html exposing (div, text, span, a)
import Html.Attributes as Attributes exposing (class, classList, attribute, href)
import Html.Events exposing (onClick, on, onMouseEnter, onMouseLeave)
import Html.Keyed as Keyed
import Json.Decode as Decode
import Bootstrap.Carousel.Slide as Slide
import Bootstrap.Carousel.SlideInternal as SlideInternal
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
    , cycling : Cycling
    , interval : Int
    , hovering : Hovering
    , keyboard : Bool
    , wrap : Bool
    , size : Int
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

* `Paused`: frozen on the current slide
* `Active`: immediately start cycling
* `WaitForUser`: Wait for the user to perform one transition, then cycle automatically
-}
type Cycling
    = Paused
    | Active
    | WaitForUser


type Hovering
    = Hovered
    | NotHovered
    | IgnoreHover



--- Init ---


{-| Configuration for the State
-}
type alias StateOptions =
    { interval : Maybe Int
    , keyboard : Bool
    , pauseOnHover : Bool
    , cycling : Cycling
    , wrap : Bool
    , startIndex : Int
    }


{-| -}
defaultStateOptions : StateOptions
defaultStateOptions =
    { interval = Just 5000
    , keyboard = True
    , pauseOnHover = True
    , cycling = Active
    , wrap = True
    , startIndex = 0
    }


{-| An initial state with customized options

    myOptions =
        { defaultStateOptions
            | interval = Just 2000
            , pauseOnHover = False
        }

    init = initialStateWithOptions myOptions

-}
initialStateWithOptions : StateOptions -> State
initialStateWithOptions options =
    State NotAnimating
        { currentIndex = options.startIndex
        , interval = Maybe.withDefault 0 options.interval
        , cycling = options.cycling
        , hovering =
            if options.pauseOnHover then
                NotHovered
            else
                IgnoreHover
        , keyboard = options.keyboard
        , wrap = options.wrap
        , size = 2
        }


{-| An initial State with the [`defaultStateOptions`](#defaultStateOptions)
-}
initialState : State
initialState =
    initialStateWithOptions defaultStateOptions


{-| When using automatic cycling you must remember to call this function in your main subscriptions function

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Carousel.subscriptions model.carouselState CarouselMsg

* `state` The current view state of the carousel
* `toMsg` Message constructor function that is used to step the view state forward
-}
subscriptions : State -> (Msg -> msg) -> Sub msg
subscriptions model toMsg =
    case model of
        State NotAnimating { interval, cycling, wrap, currentIndex, hovering, size } ->
            -- when conditions are satisfied, automatically cycle to the next slide
            let
                atEnd =
                    not wrap && currentIndex == size - 1
            in
                if cycling == Active && hovering /= Hovered && interval /= 0 && not atEnd then
                    Time.every (toFloat interval * Time.millisecond) (\_ -> toMsg <| StartTransition Next)
                else
                    Sub.none

        State (Start transition) _ ->
            -- request an animation frame to trigger the start of css transitions
            AnimationFrame.times (\_ -> toMsg SetAnimating)

        State (Animating transition) _ ->
            -- don't trigger new animations when already animating
            Sub.none



--- Update ---


{-| Internal Msg type
-}
type Msg
    = Cycle
    | Pause
    | StartTransition Transition
    | SetAnimating
    | EndTransition Int
    | SetHover Hovering


{-| Update the carousel

Typically called from your main update function

    update : Msg -> Model -> (Model, Cmd Msg)
    update message model =
        case message of
            CarouselMsg submsg ->
                ( { model | carouselState = Carousel.update submsg model.carouselState }
                , Cmd.none
                )

-}
update : Msg -> State -> State
update message ((State tstage ({ currentIndex, size } as settings)) as model) =
    case message of
        Pause ->
            State tstage { settings | cycling = Paused }

        Cycle ->
            State tstage { settings | cycling = Active }

        SetHover hovering ->
            State tstage { settings | hovering = hovering }

        StartTransition transition ->
            let
                newSettings =
                    case settings.cycling of
                        WaitForUser ->
                            -- the user has clicked something, so we can now automatically cycle
                            { settings | cycling = Active }

                        _ ->
                            settings
            in
                case tstage of
                    NotAnimating ->
                        if nextIndex (Start transition) currentIndex size /= currentIndex then
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

        EndTransition size ->
            case tstage of
                NotAnimating ->
                    -- happens once on pageload to get the number of slides into the State
                    State NotAnimating { settings | size = size }

                _ ->
                    State NotAnimating { settings | currentIndex = nextIndex tstage currentIndex size, size = size }


{-| Move the carousel to the next slide.


Useful for implementing custom behavior, like transitioning when some key is pressed

    update : Msg -> Model -> (Model, Cmd Msg)
    update message model =
        case message of
            KeyPress keycode ->
                if keycode == 39 then -- right arrow
                    ({ model | carouselState = Carousel.next model.carouselState }
                    , Cmd.none
                    }

                else
                    ( model
                    , Cmd.none
                    )

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


{-| Stop a carousel from automatically cycling.
-}
pause : State -> State
pause =
    update Pause


{-| (Re)start automatically cycling.
-}
cycle : State -> State
cycle =
    update Cycle


{-| Calculate the next index based on the current state
-}
nextIndex : TransitionStage Transition -> Int -> Int -> Int
nextIndex stage currentIndex size =
    let
        helper transition =
            case transition of
                Next ->
                    (currentIndex + 1) % size

                Prev ->
                    (currentIndex - 1) % size

                Number m ->
                    m % size
    in
        case stage of
            Start transition ->
                helper transition

            Animating transition ->
                helper transition

            NotAnimating ->
                currentIndex



--- View ---


{-| Opaque type that defines the view configuration of a carousel
-}
type Config msg
    = Config
        { toMsg : Msg -> msg
        , attributes : List (Html.Attribute msg)
        , slides : List (Slide.Config msg)
        , controls : Bool
        , indicators : Bool
        }


{-| Creates an initial/default view configuration for a carousel
-}
config : (Msg -> msg) -> List (Html.Attribute msg) -> Config msg
config toMsg attributes =
    Config
        { attributes = attributes
        , toMsg = toMsg
        , slides = []
        , controls = False
        , indicators = False
        }


{-| Add slides
-}
slides : List (Slide.Config msg) -> Config msg -> Config msg
slides newSlides (Config settings) =
    Config { settings | slides = newSlides }


{-| Add indicators
-}
withIndicators : Config msg -> Config msg
withIndicators (Config settings) =
    Config { settings | indicators = True }


{-| Adds previous and next controls
-}
withControls : Config msg -> Config msg
withControls (Config settings) =
    Config { settings | controls = True }


{-| Create a carousel element

    Carousel.config CarouselMsg []
        |> Carousel.withIndicators
        |> Carousel.slides
            [ slideOne model -- view function to create a Slide
            , slideTwo model
            ]
        |> Carousel.view model.carouselState

* `state` The current view state
* `config` The configuration for the display of the carousel
-}
view : State -> Config msg -> Html.Html msg
view ((State tstage { hovering, currentIndex, wrap }) as model) (Config settings) =
    let
        size =
            List.length settings.slides

        indicatorsHtml =
            if settings.indicators then
                indicators size (nextIndex tstage currentIndex size)
            else
                text ""

        slidesHtml =
            div [ class "carousel-inner", attribute "role" "listbox" ]
                (List.indexedMap (viewSlide model) settings.slides)

        controlsHtml =
            if settings.controls then
                if wrap || (currentIndex /= 0 && currentIndex /= size - 1) then
                    [ controlPrev, controlNext ]
                else if currentIndex == 0 then
                    [ controlNext ]
                else
                    [ controlPrev ]
            else
                []

        defaultCarouselAttributes =
            [ class "carousel slide"
              -- catch the transitionend event, to end an ongoing transition
            , on "transitionend" (Decode.succeed (settings.toMsg (EndTransition size)))
            ]
                ++ (if hovering /= IgnoreHover then
                        [ onMouseEnter (settings.toMsg <| SetHover Hovered)
                        , onMouseLeave (settings.toMsg <| SetHover NotHovered)
                        ]
                    else
                        []
                   )
    in
        div (settings.attributes ++ defaultCarouselAttributes)
            (slidesHtml
                :: List.map (Html.map settings.toMsg) ([ dirtyHack size, indicatorsHtml ] ++ controlsHtml)
            )


{-| In the State, we need to store the number of slides (the size), but we can't
   have access to the number of slides outside of the view. Here, we trigger a browser
   event (on page load, effectively) to get the number of slides into the update function, where it is stored in the State
-}
dirtyHack : Int -> Html.Html Msg
dirtyHack size =
    -- use keyed to ensure this element is drawn only once
    Keyed.node "div"
        []
        [ ( "dirtyHack"
          , Html.img
                [ on "load" (Decode.succeed (EndTransition size))
                , Attributes.src "http://package.elm-lang.org/assets/favicon.ico"
                , Attributes.style [ ( "display", "none" ) ]
                ]
                []
          )
        ]


{-| Sets the correct classes to the current and (potentially) next element.
-}
viewSlide : State -> Int -> Slide.Config msg -> Html.Html msg
viewSlide ((State tstage { currentIndex, size }) as model) index slide =
    let
        newIndex =
            nextIndex tstage currentIndex size
    in
        slide
            |> SlideInternal.addAttributes [ classList (transitionClasses index currentIndex newIndex tstage) ]
            |> SlideInternal.view


{-| Get the proper class names for a slide based on the current
index and the transition
-}
transitionClassNames : Int -> Transition -> { directionalClassName : String, orderClassName : String }
transitionClassNames currentIndex transition =
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

            Prev ->
                rightPrev


{-| Determine the correct classes for a slide

* `index` the index of the slide that is rendered
* `currentIndex` the current index of the carousel
* `newIndex` index that the carousel animates to
* `tstage` transition stage of the current animation
-}
transitionClasses : Int -> Int -> Int -> TransitionStage Transition -> List ( String, Bool )
transitionClasses index currentIndex newIndex tstage =
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
                        transitionClassNames currentIndex transition
                in
                    [ ( "active", True )
                    , ( directionalClassName, True )
                    ]
    else if index == newIndex then
        case tstage of
            NotAnimating ->
                []

            Start transition ->
                [ ( .orderClassName (transitionClassNames currentIndex transition), True )
                ]

            Animating transition ->
                let
                    { directionalClassName, orderClassName } =
                        transitionClassNames currentIndex transition
                in
                    [ ( directionalClassName, True )
                    , ( orderClassName, True )
                    ]
    else
        []


controlPrev : Html.Html Msg
controlPrev =
    a [ class "carousel-control-prev", attribute "role" "button", onClick (StartTransition Prev) ]
        [ span [ class "carousel-control-prev-icon", attribute "aria-hidden" "true" ] []
        , span [ class "sr-only" ] [ text "Previous" ]
        ]


controlNext : Html.Html Msg
controlNext =
    a [ class "carousel-control-next", attribute "role" "button", onClick (StartTransition Next) ]
        [ span [ class "carousel-control-next-icon", attribute "aria-hidden" "true" ] []
        , span [ class "sr-only" ] [ text "Next" ]
        ]


indicators : Int -> Int -> Html.Html Msg
indicators size activeIndex =
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
