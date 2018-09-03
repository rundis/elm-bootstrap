module Bootstrap.Carousel.SlideInternal exposing (Config(..), SlideContent(..), addAttributes, view)

{-| Config type
-}

import Html exposing (div, text)
import Html.Attributes as Attributes exposing (class)


type Config msg
    = Config
        { attributes : List (Html.Attribute msg)
        , content : SlideContent msg
        , caption : Maybe { attributes : List (Html.Attribute msg), children : List (Html.Html msg) }
        }


type SlideContent msg
    = Image { attributes : List (Html.Attribute msg), src : String }
    | Custom { html : Html.Html msg }


{-| Function to add extra attributes to an existing slide. Used to put the proper classes for css transitions
on a slide in a carousel.
-}
addAttributes newAttributes (Config settings) =
    Config { settings | attributes = settings.attributes ++ newAttributes }


{-| Convert a slide config to html

Not exposed because it does not make sense to have a standalone slide outside of a carousel.

-}
view : Config msg -> Html.Html msg
view (Config { attributes, content, caption }) =
    let
        captionHtml =
            case caption of
                Nothing ->
                    text ""

                Just rec ->
                    div (rec.attributes ++ [ class "carousel-caption d-none d-md-block" ]) rec.children
    in
    div (attributes ++ [ class "carousel-item" ]) <|
        case content of
            Image rec ->
                [ Html.img (rec.attributes ++ [ class "d-block img-fluid", Attributes.src rec.src ]) []
                , captionHtml
                ]

            Custom { html } ->
                [ html
                , captionHtml
                ]
