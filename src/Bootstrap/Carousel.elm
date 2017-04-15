module Bootstrap.Carousel exposing (..)

{-| -}

import Html exposing (div, text, span, a)
import Html.Attributes as Attributes exposing (class, classList, attribute, href)
import Html.Events exposing (onClick)
import Html.Keyed as Keyed
import Bootstrap.Slide as Slide
import Time


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


type Msg
    = Cycle
    | Pause
    | Number Int
    | Prev
    | Next


type RunningState
    = Inactive
    | Paused
    | Active


type alias Activity =
    { state : RunningState, interval : Int }


type State
    = State { currentIndex : Int, activity : Activity }


subscriptions (State { activity }) =
    case activity.state of
        Active ->
            Time.every (toFloat activity.interval * Time.millisecond) (\_ -> Next)

        _ ->
            Sub.none


update : Msg -> State -> State
update message (State ({ currentIndex, activity } as settings)) =
    case message of
        Next ->
            State { settings | currentIndex = (currentIndex + 1) % 2 }

        Prev ->
            State { settings | currentIndex = currentIndex - 1 }

        Number m ->
            State { settings | currentIndex = m }

        Pause ->
            State { settings | activity = { activity | state = Paused } }

        Cycle ->
            State { settings | activity = { activity | state = Active } }


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


view : Config msg -> State -> Html.Html msg
view (Config settings) (State { currentIndex, activity }) =
    let
        indicatorsHtml =
            if settings.indicators then
                indicators settings.id (List.length settings.slides) currentIndex
            else
                text ""

        slidesHtml =
            div [ class "carousel-inner", attribute "role" "listbox" ]
                (List.indexedMap
                    (\i slide ->
                        if i == currentIndex then
                            slide
                                |> Slide.addActive
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
    in
        div (List.concatMap carouselOptionToAttributes settings.options ++ [ Attributes.id settings.id, class "carousel slide" ])
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
    a [ class "carousel-control-prev", href ("#" ++ id), attribute "role" "button", attribute "data-slide" "prev", onClick Prev ]
        [ span [ class "carousel-control-prev-icon", attribute "aria-hidden" "true" ] []
        , span [ class "sr-only" ] [ text "Previous" ]
        ]


controlNext : String -> Html.Html Msg
controlNext id =
    a [ class "carousel-control-next", href ("#" ++ id), attribute "role" "button", attribute "data-slide" "next", onClick Next ]
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
