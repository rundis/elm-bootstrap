module Bootstrap.CDN exposing (stylesheet, fontAwesome)

{-| Helper module for easily embedding css when you want to work with the library using the Elm Reactor


@docs stylesheet, fontAwesome



-}

import Html exposing (Html, node)
import Html.Attributes exposing (rel, href)


{-| Allows you to embed the Bootstrap CSS as a node in your view.

    import Bootstrap.CDN


    view : Model -> Html Msg
    view model =
        div []
            [ CDN.stylesheet -- css embedded inline.
            , yourContentHere
            , navbar model
            , mainContent model
            ]
-}
stylesheet : Html msg
stylesheet =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"
        ]
        []


{-| Font Awesome can also be conveniently included as an inline node. Font Awesome does not depend on `Bootstrap for Elm`.
-}
fontAwesome : Html msg
fontAwesome =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        ]
        []
