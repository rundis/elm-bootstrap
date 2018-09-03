module Bootstrap.Carousel.Slide exposing
    ( Config, config, caption
    , SlideContent, image, customContent
    )

{-| A slide is used as part of a carousel

    Slide.config []
        (Slide.image [ Attributes.alt "slide 1" ] "https://...")
        |> Slide.caption []
            [ h3 [] [ text "First slide label" ]
            , p [] []
            ]


# Slide

@docs Config, config, caption


# Content

@docs SlideContent, image, customContent

-}

import Bootstrap.Carousel.SlideInternal as SlideInternal exposing (Config(..), SlideContent(..))
import Html exposing (div, text)
import Html.Attributes as Attributes exposing (class)


{-| Opaque type that defines the view configuration information of your slide
-}
type alias Config msg =
    SlideInternal.Config msg


{-| Opaque type that defines the content of a slide
-}
type alias SlideContent msg =
    SlideInternal.SlideContent msg


{-| Creates an initial/default view configuration for a slide
-}
config : List (Html.Attribute msg) -> SlideContent msg -> Config msg
config attributes content =
    Config
        { attributes = attributes
        , content = content
        , caption = Nothing
        }


{-| Add a caption to your slide

The captions are automatically hidden on small devices.

-}
caption : List (Html.Attribute msg) -> List (Html.Html msg) -> Config msg -> Config msg
caption attributes children (Config settings) =
    Config { settings | caption = Just { attributes = attributes, children = children } }


{-| Populate a slide with an image.

  - `attributes` List of attributes
  - `src` the `src` attribute for the image

-}
image : List (Html.Attribute msg) -> String -> SlideContent msg
image attributes src =
    Image { attributes = attributes, src = src }


{-| Populate a slide with whatever html you want
-}
customContent : Html.Html msg -> SlideContent msg
customContent html =
    Custom { html = html }
