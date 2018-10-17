module Bootstrap.ButtonTest exposing (Msg(..), fancyBlockButton, linkButton, outlinedButtons, roledButtons, vanillaButton)

import Bootstrap.Button as Button
import Html
import Html.Attributes as Attr
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)


type Msg
    = Msg


vanillaButton : Test
vanillaButton =
    let
        html =
            Button.button [ Button.onClick Msg ] [ Html.text "Click" ]
    in
    describe "Plain button"
        [ test "expect button and text" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ tag "button", text "Click" ]
        , test "expect btn class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ class "btn" ]
        , test "expect event" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Event.simulate Event.click
                    |> Event.expect Msg
        ]


linkButton : Test
linkButton =
    let
        html =
            Button.linkButton [ Button.danger ] [ Html.text "Click" ]
    in
    describe "Plain link button"
        [ test "expect a and text" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ tag "a", text "Click" ]
        , test "expect btn class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ classes [ "btn", "btn-danger" ] ]
        , test "expect role attr" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ attribute <| Attr.attribute "role" "button" ]
        ]


roledButtons : Test
roledButtons =
    let
        html =
            Html.div []
                [ Button.button [ Button.primary ] [ Html.text "primary" ]
                , Button.button [ Button.secondary ] [ Html.text "secondary" ]
                , Button.button [ Button.success ] [ Html.text "success" ]
                , Button.button [ Button.info ] [ Html.text "info" ]
                , Button.button [ Button.warning ] [ Html.text "warning" ]
                , Button.button [ Button.danger ] [ Html.text "danger" ]
                , Button.button [ Button.roleLink ] [ Html.text "link" ]
                , Button.button [ Button.disabled True ] [ Html.text "disabled" ]
                ]
    in
    describe "Roled buttons"
        [ test "expect primary" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-primary" ]
                    |> Query.has [ text "primary" ]
        , test "expect secondary" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-secondary" ]
                    |> Query.has [ text "secondary" ]
        , test "expect success" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-success" ]
                    |> Query.has [ text "success" ]
        , test "expect info" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-info" ]
                    |> Query.has [ text "info" ]
        , test "expect warning" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-warning" ]
                    |> Query.has [ text "warning" ]
        , test "expect danger" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-danger" ]
                    |> Query.has [ text "danger" ]
        , test "expect link" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-link" ]
                    |> Query.has [ text "link" ]
        , test "expect disabled" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "disabled", attribute <| Attr.disabled True ]
                    |> Query.has [ text "disabled" ]
        ]


outlinedButtons : Test
outlinedButtons =
    let
        html =
            Html.div []
                [ Button.button [ Button.outlinePrimary ] [ Html.text "primary" ]
                , Button.button [ Button.outlineSecondary ] [ Html.text "secondary" ]
                , Button.button [ Button.outlineSuccess ] [ Html.text "success" ]
                , Button.button [ Button.outlineInfo ] [ Html.text "info" ]
                , Button.button [ Button.outlineWarning ] [ Html.text "warning" ]
                , Button.button [ Button.outlineDanger ] [ Html.text "danger" ]
                ]
    in
    describe "Outlined buttons"
        [ test "expect primary" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-outline-primary" ]
                    |> Query.has [ text "primary" ]
        , test "expect secondary" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-outline-secondary" ]
                    |> Query.has [ text "secondary" ]
        , test "expect success" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-outline-success" ]
                    |> Query.has [ text "success" ]
        , test "expect info" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-outline-info" ]
                    |> Query.has [ text "info" ]
        , test "expect warning" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-outline-warning" ]
                    |> Query.has [ text "warning" ]
        , test "expect danger" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "btn-outline-danger" ]
                    |> Query.has [ text "danger" ]
        ]


fancyBlockButton : Test
fancyBlockButton =
    let
        html =
            Button.linkButton
                [ Button.block
                , Button.large
                , Button.danger
                , Button.attrs [ Attr.class "rounded" ]
                ]
                [ Html.text "Click" ]
    in
    describe "Fancy Block Button"
        [ test "expect a and text" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ tag "a", text "Click" ]
        , test "expect btn class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ classes [ "btn", "btn-danger", "btn-block", "rounded", "btn-lg" ] ]
        , test "expect role attr" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ attribute <| Attr.attribute "role" "button" ]
        ]
