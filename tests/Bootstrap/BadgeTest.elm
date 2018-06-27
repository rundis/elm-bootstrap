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
            , describe "All options" <|
                List.map
                    (\( constructor, class ) ->
                        test ("Option " ++ class) <|
                            \() ->
                                constructor [] [ Html.text "X" ]
                                    |> Query.fromHtml
                                    |> Query.has [ classes [ "badge", class ] ]
                    )
                    [ ( Badge.badgePrimary, "badge-primary" )
                    , ( Badge.badgeSecondary, "badge-secondary" )
                    , ( Badge.badgeSuccess, "badge-success" )
                    , ( Badge.badgeInfo, "badge-info" )
                    , ( Badge.badgeWarning, "badge-warning" )
                    , ( Badge.badgeDanger, "badge-danger" )
                    , ( Badge.badgeLight, "badge-light" )
                    , ( Badge.badgeDark, "badge-dark" )
                    ]
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
