module Bootstrap.Slide exposing (Config, SlideOption, SlideContent, view, config, caption, customContent, image, active, addActive, removeActive)

{-| helper module for slides
-}

import Html exposing (div, text)
import Html.Attributes as Attributes exposing (class)
import Html.Keyed as Keyed


{-| Config type
-}
type Config msg
    = Config
        { options : List (SlideOption msg)
        , content : SlideContent msg
        , caption : Maybe { attributes : List (Html.Attribute msg), children : List (Html.Html msg) }
        }


type SlideOption msg
    = Active
    | Attrs (List (Html.Attribute msg))


active =
    Active


addActive (Config settings) =
    Config { settings | options = settings.options ++ [ Active ] }


removeActive (Config settings) =
    Config { settings | options = List.filter (\option -> option /= Active) settings.options }


slideAttributes : List (SlideOption msg) -> List (Html.Attribute msg)
slideAttributes options =
    let
        optionToAttribute option =
            case option of
                Active ->
                    [ class "active" ]

                Attrs attrs ->
                    attrs
    in
        [ class "carousel-item" ]
            ++ List.concatMap optionToAttribute options


config : List (SlideOption msg) -> SlideContent msg -> Config msg
config options content =
    Config
        { options = options
        , content = content
        , caption = Nothing
        }


caption : List (Html.Attribute msg) -> List (Html.Html msg) -> Config msg -> Config msg
caption attributes children (Config settings) =
    Config { settings | caption = Just { attributes = attributes, children = children } }



{-
   Slide.config [ Slide.active ]
           (Slide.image [ Attributes.alt "slide 1" ] "https://...")
       |> Slide.caption []
           [ h3 [] [ text "First slide label" ]
           , p [] []
           ]
       |> Slide.view
-}


type SlideContent msg
    = Image { attributes : List (Html.Attribute msg), src : String }
    | Custom { html : Html.Html msg }


image : List (Html.Attribute msg) -> String -> SlideContent msg
image attributes src =
    Image { attributes = attributes, src = src }


customContent : Html.Html msg -> SlideContent msg
customContent html =
    Custom { html = html }


view : Config msg -> Html.Html msg
view (Config { options, content, caption }) =
    let
        captionHtml =
            case caption of
                Nothing ->
                    text ""

                Just { attributes, children } ->
                    div (attributes ++ [ class "carousel-caption d-none d-md-block" ]) children
    in
        div (slideAttributes options) <|
            case content of
                Image { attributes, src } ->
                    [ Html.img (attributes ++ [ class "d-block img-fluid", Attributes.src src ]) []
                    , captionHtml
                    ]

                Custom { html } ->
                    [ html
                    , captionHtml
                    ]
