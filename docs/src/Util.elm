module Util exposing (..)

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

exampleRow : List (Html msg) -> Html msg
exampleRow children =
    div [ class "bd-example-row" ]
        children



exampleAndRow : List (Html msg) -> Html msg
exampleAndRow children =
    div [ class "bd-example bd-example-row" ]
        children




toMarkdown : String -> Html.Html msg
toMarkdown code =
    Markdown.toHtml
        []
        code


toMarkdownElm : String -> Html.Html msg
toMarkdownElm code =
    Markdown.toHtml
        []
        ("```elm" ++ code ++ "```")


code : Html.Html msg -> Html.Html msg
code codeElem =
    div
        [ class "highlight"]
        [ codeElem ]


calloutInfo : List (Html msg) -> Html msg
calloutInfo children =
    div [ class "bd-callout bd-callout-info" ] children

calloutWarning : List (Html msg) -> Html msg
calloutWarning children =
    div [ class "bd-callout bd-callout-warning" ] children


