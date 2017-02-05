module Util exposing (toMarkdown, simplePageHeader, pageContent, example)

import Html.Attributes exposing (..)
import Html exposing (..)
import Markdown


simplePageHeader : String -> String -> Html msg
simplePageHeader title intro =
    div
        [ class "bd-pageheader" ]
        [ div
            [ class "container" ]
            [ h1 [] [ text title ]
            , p
                [ class "lead" ]
                [ text intro
                ]
            ]
        ]


pageContent : List (Html msg) -> Html msg
pageContent children =
    div [ class "container" ]
        [ div
            [ class "row" ]
            [ div
                [ class "col bd-content" ]
                children
            ]
        ]

example : List (Html msg) -> Html msg
example children =
    div [ class "bd-example" ]
        children


toMarkdown : String -> Html.Html msg
toMarkdown code =
    Markdown.toHtml
        [ style
            [ ( "background-color", "#f7f7f9" )
            , ( "border", "1px solid f7f7aa" )
            , ( "padding", "10px" )
            , ( "margin-top", "10px" )
            ]
        ]
        code
