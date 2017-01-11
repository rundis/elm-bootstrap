module Bootstrap.CDN exposing (stylesheet, fontAwesome)

import Html exposing (Html, node)
import Html.Attributes exposing (rel, href)



stylesheet : Html msg
stylesheet =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"
        ]
        []


fontAwesome : Html msg
fontAwesome =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        ]
        []
