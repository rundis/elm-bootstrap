module Bootstrap.BadgeTest exposing (badge, pill)

import Bootstrap.Badge as Badge
import Html
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (classes, tag, text)


badge : Test
badge =
    let
        html =
            Badge.badgeDanger [] [ Html.text "X" ]

        expectBadgeClass constructor class =
            constructor [] [ Html.text "X" ]
                |> Query.fromHtml
                |> Query.has [ classes [ "badge", class ] ]
    in
    describe "Badge with options"
        [ test "expect span and text" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ tag "span", text "X" ]
        , describe "All options" <|
            [ test "Expect primary" <|
                \() -> expectBadgeClass Badge.badgePrimary "badge-primary"
            , test "Expect secondary" <|
                \() -> expectBadgeClass Badge.badgeSecondary "badge-secondary"
            , test "Expect success" <|
                \() -> expectBadgeClass Badge.badgeSuccess "badge-success"
            , test "Expect info" <|
                \() -> expectBadgeClass Badge.badgeInfo "badge-info"
            , test "Expect warning" <|
                \() -> expectBadgeClass Badge.badgeWarning "badge-warning"
            , test "Expect danger" <|
                \() -> expectBadgeClass Badge.badgeDanger "badge-danger"
            , test "Expect light" <|
                \() -> expectBadgeClass Badge.badgeLight "badge-light"
            , test "Expect dark" <|
                \() -> expectBadgeClass Badge.badgeDark "badge-dark"
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
