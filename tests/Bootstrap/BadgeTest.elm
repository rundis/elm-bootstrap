module Bootstrap.BadgeTest exposing (..)

import Bootstrap.Badge as Badge
import Html
import Test exposing (Test, test, describe)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, classes)





badge : Test
badge =
    let
        html =
            Badge.badgeDanger [] [ Html.text "X" ]
    in
        describe "Badge with options"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "span", text "X" ]
            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ classes [ "badge", "badge-danger" ] ]
            ]

pill : Test
pill =
    let
        html =
            Badge.pillDanger [] [ Html.text "X" ]
    in
        describe "Pill with options"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "span", text "X" ]
            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ classes [ "badge", "badge-danger", "badge-pill" ] ]
            ]
