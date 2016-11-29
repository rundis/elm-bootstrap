module Bootstrap.CDN exposing (stylesheet, stylesheetFlex, fontAwesome)

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


fontAwesome : Html msg
fontAwesome =
    node "link"
        [ rel "stylesheet"
        , href "https://maxcdn.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css"
        ]
        []
