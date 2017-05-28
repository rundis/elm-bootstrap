module Bootstrap.Progress
    exposing
        ( progress
        , progressMulti
        , value
        , height
        , label
        , customLabel
        , success
        , info
        , warning
        , danger
        , striped
        , animated
        , attrs
        , wrapperAttrs
        , Option
        )

{-| You can use the custom progress elment for displaying simple or complex progress bars.
It doesn't use the HTML5 `<progress>` element, ensuring you can stack progress bars, animate them, and place text labels over them.


# Progress bar
@docs progress


## Options
@docs value, height, label, customLabel, success, info, warning, danger, striped, animated, attrs, wrapperAttrs, Option


# Stacking multiple
@docs progressMulti

-}

import Html exposing (Html, Attribute)
import Html.Attributes as Attributes exposing (class, classList, style, attribute)


{-| Opaque type representing available display options for the progress bar
-}
type Option msg
    = Value Float
    | Height (Maybe Int)
    | Label (List (Html.Html msg))
    | Roled (Maybe Role)
    | Striped Bool
    | Animated Bool
    | Attrs (List (Attribute msg))
    | WrapperAttrs (List (Attribute msg))


type Role
    = Success
    | Info
    | Warning
    | Danger


type Options msg
    = Options
        { value : Float
        , height : Maybe Int
        , label : List (Html msg)
        , role : Maybe Role
        , striped : Bool
        , animated : Bool
        , attributes : List (Attribute msg)
        , wrapperAttributes : List (Attribute msg)
        }


{-| Create a progress bar with various customization options

    Progress.progress
        [ Progress.primary
        , Progress.value 30
        ]

* `options` List of options

**NOTE: ** If you have duplicate options, the last one "wins"
-}
progress : List (Option msg) -> Html msg
progress modifiers =
    let
        (Options options) =
            List.foldl applyOption defaultOptions modifiers
    in
        Html.div
            ( class "progress" :: options.wrapperAttributes)
            [ renderBar modifiers ]


{-| Create a progress containing multiple progress bars next to each other

    Progress.progressMulti
        [ [ Progress.info, Progress.value 25 ]
        , [ Progress.success, Progress.value 30 ]
        ]

-}
progressMulti : List (List (Option msg)) -> Html msg
progressMulti bars =
    Html.div
        [ class "progress" ]
        (List.map renderBar bars)


renderBar : List (Option msg) -> Html msg
renderBar modifiers =
    let
        ((Options opts) as options) =
            List.foldl applyOption defaultOptions modifiers
    in
        Html.div
            (toAttributes options)
            opts.label


{-| Option to specify the progress amount for a bar in percent. Should be a value between 0 and 100
-}
value : Float -> Option msg
value val =
    Value val


{-| Option to specify the height (in pixels) for the progress bar
-}
height : Int -> Option msg
height height =
    Height <| Just height


{-| Option to specify a text label for a progress bar

The label will only display when you have set a [`value`](#value)
-}
label : String -> Option msg
label text =
    Label [ Html.text text ]


{-| Option to specify a funky custom label for a progress bar
-}
customLabel : List (Html msg) -> Option msg
customLabel children =
    Label children


{-| Option to give a progress bar a success background color
-}
success : Option msg
success =
    Roled <| Just Success


{-| Option to give a progress bar an info background color
-}
info : Option msg
info =
    Roled <| Just Info


{-| Option to give a progress bar a warning background color
-}
warning : Option msg
warning =
    Roled <| Just Warning


{-| Option to give a progress bar a danger background color
-}
danger : Option msg
danger =
    Roled <| Just Danger


{-| Option to make the progress bar animated

**NOTE: ** Giving this option will automatically also make the background [`striped`](#striped)
-}
animated : Option msg
animated =
    Animated True


{-| Option to make the progress bar background striped
-}
striped : Option msg
striped =
    Striped True


{-| Option to specify one ore more custom Html.Attribute for the progress bar
-}
attrs : List (Attribute msg) -> Option msg
attrs attrs =
    Attrs attrs


{-| Option to specify one ore more custom Html.Attribute for the progress bar wrapper/container
(say you need to add a on click handler or something like that)
-}
wrapperAttrs : List (Attribute msg) -> Option msg
wrapperAttrs attrs =
    WrapperAttrs attrs



applyOption : Option msg -> Options msg -> Options msg
applyOption modifier (Options options) =
    Options <|
        case modifier of
            Value value ->
                { options | value = value }

            Height height ->
                { options | height = height }

            Label label ->
                { options | label = label }

            Roled role ->
                { options | role = role }

            Striped striped ->
                { options | striped = striped }

            Animated animated ->
                { options | animated = animated }

            Attrs attrs ->
                { options | attributes = attrs }

            WrapperAttrs attrs ->
                { options | wrapperAttributes = attrs }


toAttributes : Options msg -> List (Attribute msg)
toAttributes (Options options) =
    List.concat
        [ [ attribute "role" "progressbar"
          , attribute "aria-value-now" <| toString options.value
          , attribute "aria-valuemin" "0"
          , attribute "aria-valuemax" "100"
          , style [ ( "width", toString options.value ++ "%" ) ]
          , classList
                [ ( "progress-bar", True )
                , ( "progress-bar-striped", options.striped || options.animated )
                , ( "progress-bar-animated", options.animated )
                ]
          ]
        , case options.height of
            Just height ->
                [ style [ ( "height", toString height ++ "px" ) ] ]

            Nothing ->
                []
        , case options.role of
            Just role ->
                [ roleClass role ]

            Nothing ->
                []
        , options.attributes
        ]


defaultOptions : Options msg
defaultOptions =
    Options <|
        { value = 0
        , height = Nothing
        , label = []
        , role = Nothing
        , striped = False
        , animated = False
        , attributes = []
        , wrapperAttributes = []
        }


roleClass : Role -> Attribute msg
roleClass role =
    class <|
        case role of
            Success ->
                "bg-success"

            Info ->
                "bg-info"

            Warning ->
                "bg-warning"

            Danger ->
                "bg-danger"
