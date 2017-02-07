module Bootstrap.BadgeTest exposing (..)


import Bootstrap.Badge as Badge

import Html
import Test exposing (Test, test, describe)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, classes)


{-| @ltignore -}
all : Test
all =
    Test.concat [simpleBadge, simplePill, badgeWithOptions, pillWithOptions]


simpleBadge : Test
simpleBadge =
    let
        html = Badge.badge [] [Html.text "1"]
    in
        describe "Simple badge"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "1" ]

            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["badge", "badge-default"] ]

            ]


simplePill : Test
simplePill =
    let
        html = Badge.pill [] [Html.text "1"]
    in
        describe "Simple pill"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "1" ]

            , test "expect default classes and pill class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["badge", "badge-default", "badge-pill"] ]

            ]

badgeWithOptions : Test
badgeWithOptions =
    let
        html = Badge.badgeDanger [] [ Html.text "X"]
    in
        describe "Badge with options"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "X" ]

            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["badge", "badge-danger"] ]

            ]


pillWithOptions : Test
pillWithOptions =
    let
        html = Badge.pillDanger [] [ Html.text "X"]
    in
        describe "Pill with options"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "X" ]

            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["badge", "badge-danger", "badge-pill"] ]

            ]
