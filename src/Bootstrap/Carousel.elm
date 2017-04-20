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
        , Cycling(..)
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
@docs State, initialState, initialStateWithOptions, defaultStateOptions, Cycling

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
    , cycling : Cycling
    , interval : Int
    , hovered : Maybe Bool
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

* `Inactive`: never start cycling
* `Paused`: frozen on the current slide
* `Active`: immediately start cycling
* `WaitForUser`: Wait for the user to perform one transition, then cycle automatically
-}
type Cycling
    = Inactive
    | Paused
    | Active
    | WaitForUser



--- Init ---


type alias StateOptions =
    { interval : Maybe Int
    , keyboard : Bool
    , pauseOnHover : Bool
    , cycling : Cycling
    , wrap : Bool
    , startIndex : Int
    }


defaultStateOptions : StateOptions
defaultStateOptions =
    { interval = Just 5000
    , keyboard = True
    , pauseOnHover = True
    , cycling = Active
    , wrap = True
    , startIndex = 0
    }


initialStateWithOptions : StateOptions -> State
initialStateWithOptions options =
    State NotAnimating
        { currentIndex = options.startIndex
        , interval = Maybe.withDefault 0 options.interval
        , cycling = options.cycling
        , hovered =
            if options.pauseOnHover then
                Just False
            else
                Nothing
        , keyboard = options.keyboard
        , wrap = options.wrap
        , size = 2
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
                    settings.cycling == Active

                atEnd =
                    not settings.wrap && settings.currentIndex == settings.size - 1

                notHovered =
                    settings.hovered == Just False
            in
                if active && notHovered && interval /= 0 && not atEnd then
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
    | EndTransition Int
    | SetHover Bool
    | SetSize Int


update : Msg -> State -> State
update message ((State tstage ({ currentIndex, hovered, size } as settings)) as model) =
    case message of
        Pause ->
            State tstage { settings | cycling = Paused }

        Cycle ->
            State tstage { settings | cycling = Active }

        SetHover isHovered ->
            State tstage { settings | hovered = Maybe.map (\_ -> isHovered) hovered }

        SetSize size ->
            case tstage of
                NotAnimating ->
                    State NotAnimating { settings | size = size }

                Start transition ->
                    if nextIndex tstage currentIndex size >= size then
                        State NotAnimating { settings | size = size }
                    else
                        State (Start transition) { settings | size = size }

                Animating transition ->
                    if nextIndex tstage currentIndex size >= size then
                        State NotAnimating { settings | size = size }
                    else
                        State (Animating transition) { settings | size = size }

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
                    -- should never happen
                    model

                _ ->
                    State NotAnimating { settings | currentIndex = nextIndex tstage currentIndex size, size = size }


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


{-| Opaque type that defines the view configuration of your carousel
-}
type Config msg
    = Config
        { id : String
        , toMsg : Msg -> msg
        , attributes : List (Html.Attribute msg)
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
                indicators settings.id (List.length settings.slides) (nextIndex tstage currentIndex size)
            else
                text ""

        slidesHtml =
            div [ class "carousel-inner", attribute "role" "listbox" ]
                (List.indexedMap (viewSlide model) settings.slides)

        controlsHtml =
            if settings.controls then
                if currentIndex == size - 1 then
                    []
                else if wrap || (currentIndex /= 0 && currentIndex /= size - 1) then
                    [ controlPrev settings.id, controlNext settings.id ]
                else if currentIndex == 0 then
                    [ controlNext settings.id ]
                else
                    [ controlPrev settings.id ]
            else
                []

        {- In the State, we need to store the number of slides (the size), but we can't
           have access to the number of slides outside of the view. Here, we trigger a browser
           event to get the number of slides into the update function, to be stored in the State
        -}
        dirtyHack =
            Html.img
                [ on "load" (Decode.succeed (settings.toMsg (SetSize size)))
                , Attributes.src "http://package.elm-lang.org/assets/favicon.ico"
                , Attributes.style [ ( "display", "none" ) ]
                ]
                []

        defaultCarouselAttributes =
            -- catch the transitionend event, to end an ongoing transition
            [ Attributes.id settings.id
            , class "carousel slide"
            , on "transitionend" (Decode.succeed (settings.toMsg (EndTransition size)))
            , onMouseEnter (settings.toMsg <| SetHover True)
            , onMouseLeave (settings.toMsg <| SetHover False)
            ]
    in
        div (settings.attributes ++ defaultCarouselAttributes)
            (useless :: Html.map settings.toMsg indicatorsHtml :: slidesHtml :: (List.map (Html.map settings.toMsg) controlsHtml))


{-| Sets the correct classes to the current and (potentially) next element.
-}
viewSlide : State -> Int -> Slide.Config msg -> Html.Html msg
viewSlide ((State tstage { currentIndex, size }) as model) index slide =
    let
        newIndex =
            nextIndex tstage currentIndex size

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


config : String -> (Msg -> msg) -> List (Html.Attribute msg) -> Config msg
config id toMsg attributes =
    Config
        { id = id
        , attributes = attributes
        , toMsg = toMsg
        , slides = []
        , controls = False
        , indicators = False
        }


img3 =
    """
data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%22800%22%20height%3D%22400%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20viewBox%3D%220%200%20800%20400%22%20preserveAspectRatio%3D%22none%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%23holder_15b81742454%20text%20%7B%20fill%3A%23333%3Bfont-weight%3Anormal%3Bfont-family%3AHelvetica%2C%20monospace%3Bfont-size%3A40pt%20%7D%20%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cg%20id%3D%22holder_15b81742454%22%3E%3Crect%20width%3D%22800%22%20height%3D%22400%22%20fill%3D%22%23555%22%3E%3C%2Frect%3E%3Cg%3E%3Ctext%20x%3D%22277.0078125%22%20y%3D%22217.7%22%3EThird%20slide%3C%2Ftext%3E%3C%2Fg%3E%3C%2Fg%3E%3C%2Fsvg%3E
"""
