module Bootstrap.CDN exposing (stylesheet, stylesheetFlex)

import Html exposing (Html, node)
import Html.Attributes exposing (rel, href)



stylesheet : Html msg
stylesheet =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap.min.css"
        ]
        []

stylesheetFlex : Html msg
stylesheetFlex =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.5/css/bootstrap-flex.min.css"
        ]
        []
