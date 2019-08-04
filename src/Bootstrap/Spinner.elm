module Bootstrap.Spinner exposing
    ( spinner
    , grow, small, large, color, attrs, Option
    , srMessage
    )

{-| Indicate the loading state of a component or page with Bootstrap spinners


# Creating

@docs spinner


# Options

@docs grow, small, large, color, attrs, Option


# Helpers

@docs srMessage

-}

import Bootstrap.Internal.Text as TextInternal
import Bootstrap.Text as Text
import Html
import Html.Attributes exposing (class, classList, style)


{-| Opaque type for spinner options.
-}
type Option msg
    = Kind SpinnerKind
    | Size SpinnerSize
    | Color Text.Color
    | Attrs (List (Html.Attribute msg))


type SpinnerKind
    = Border
    | Growing


type SpinnerSize
    = Normal
    | Small
    | Large


type alias Options msg =
    { kind : SpinnerKind
    , size : SpinnerSize
    , color : Maybe Text.Color
    , attributes : List (Html.Attribute msg)
    }


{-| Create a spinner element for fun and profit.

    Spinner.spinner
        [ Spinner.grow
        , Spinner.large
        , Spinner.color Text.secondary
        , Spinner.attrs
        ]
        [ Spinner.srMessage "Loading..." ]

-}
spinner : List (Option msg) -> List (Html.Html msg) -> Html.Html msg
spinner options children =
    let
        opts =
            List.foldl applyModifier defaultOptions options
    in
    Html.div (toAttributes opts) children


{-| Helper function to create a screen reader message element.
-}
srMessage : String -> Html.Html msg
srMessage msg =
    Html.span [ class "sr-only" ] [ Html.text msg ]


{-| Make the spinner smaller.
-}
small : Option msg
small =
    Size Small


{-| Make the spinner larger.
-}
large : Option msg
large =
    Size Large


{-| Make the spinner grow/shrink (default border spinner).
-}
grow : Option msg
grow =
    Kind Growing


{-| Set the spinner color by using one of the available Bootstrap.Text colors.
-}
color : Text.Color -> Option msg
color color_ =
    Color color_


{-| Use this function to handle any Html.Attribute option you wish for your spinner
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    Attrs attrs_


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Kind spinnerKind ->
            { options | kind = spinnerKind }

        Size spinnerSize ->
            { options | size = spinnerSize }

        Color color_ ->
            { options | color = Just color_ }

        Attrs list ->
            { options | attributes = list }


defaultOptions : Options msg
defaultOptions =
    { kind = Border
    , size = Normal
    , color = Nothing
    , attributes = []
    }


toAttributes : Options msg -> List (Html.Attribute msg)
toAttributes options =
    List.filterMap identity
        [ Just <| kindClass options.kind
        , Maybe.map TextInternal.textColorClass options.color
        ]
        ++ (sizeAttributes options.size options.kind
                |> Maybe.withDefault []
           )
        ++ [ Html.Attributes.attribute "role" "status" ]
        ++ options.attributes


kindClass : SpinnerKind -> Html.Attribute msg
kindClass =
    class << kindClassName


kindClassName : SpinnerKind -> String
kindClassName kind_ =
    case kind_ of
        Border ->
            "spinner-border"

        Growing ->
            "spinner-grow"


sizeAttributes : SpinnerSize -> SpinnerKind -> Maybe (List (Html.Attribute msg))
sizeAttributes size_ kind_ =
    case size_ of
        Normal ->
            Nothing

        Small ->
            Just [ class <| kindClassName kind_ ++ "-sm" ]

        Large ->
            Just <| [ style "width" "3rem", style "height" "3rem" ]
