module Util exposing (toMarkdown)


import Html.Attributes exposing (style)
import Html
import Markdown


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
