module Bootstrap.CDN exposing (stylesheet, fontAwesome)



{-| Helper module for easily embedding css when you want to work with the library using the Elm Raactor


@docs stylesheet, fontAwesome



-}

import Html exposing (Html, node)
import Html.Attributes exposing (rel, href)


{-| Allows you to embed the bootstrap css as a node in your view

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


{-| For your convenience you can also include font-awesome as an inline node. Worth knowing that this `Bootstrap for Elm` has no dependencies on font awesome
-}
fontAwesome : Html msg
fontAwesome =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        ]
        []
