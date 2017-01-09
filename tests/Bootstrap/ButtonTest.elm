module Bootstrap.ButtonTest exposing (..)

import Bootstrap.Button as Button

import Html
import Html.Attributes as Attr
import Test exposing (Test, test, describe)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class, classes, attribute)



{-| @ltignore -}
all : Test
all =
    Test.concat
        [ vanillaButton
        , linkButton
        , roledButtons
        , outlinedButtons
        , buttonGroup
        , buttonGroupWithOptions
        , buttonToolbar
        ]



vanillaButton : Test
vanillaButton =
    let
        html = Button.button [] [Html.text "Click"]
    in
        describe "Plain button"
            [ test "expect button and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "button", text "Click"]

            , test "expect btn class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ class "btn"]

            ]


linkButton : Test
linkButton =
    let
        html = Button.linkButton [Button.roleDanger] [ Html.text "Click"]
    in
        describe "Plain link button"
            [ test "expect a and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "a", text "Click"]

            , test "expect btn class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["btn", "btn-danger"]]

            , test "expect role attr" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ attribute "role" "button"]

            ]


roledButtons : Test
roledButtons =
    let
        html =
            Html.div []
                [ Button.button [ Button.rolePrimary ] [ Html.text "primary" ]
                , Button.button [ Button.roleSecondary ] [ Html.text "secondary" ]
                , Button.button [ Button.roleSuccess ] [ Html.text "success" ]
                , Button.button [ Button.roleInfo ] [ Html.text "info" ]
                , Button.button [ Button.roleWarning ] [ Html.text "warning" ]
                , Button.button [ Button.roleDanger ] [ Html.text "danger" ]
                , Button.button [ Button.roleLink ] [ Html.text "link" ]
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
            ]



outlinedButtons : Test
outlinedButtons =
    let
        html =
            Html.div []
                [ Button.button [Button.outlinePrimary]  [Html.text "primary"]
                , Button.button [Button.outlineSecondary]  [Html.text "secondary"]
                , Button.button [Button.outlineSuccess]  [Html.text "success"]
                , Button.button [Button.outlineInfo]  [Html.text "info"]
                , Button.button [Button.outlineWarning]  [Html.text "warning"]
                , Button.button [Button.outlineDanger]  [Html.text "danger"]
                ]

    in
        describe "Outlined buttons"
            [ test "expect primary" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "btn-outline-primary"]
                        |> Query.has  [ text "primary"]

            , test "expect secondary" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "btn-outline-secondary"]
                        |> Query.has  [ text "secondary"]

            , test "expect success" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "btn-outline-success"]
                        |> Query.has  [ text "success"]

            , test "expect info" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "btn-outline-info"]
                        |> Query.has  [ text "info"]

            , test "expect warning" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "btn-outline-warning"]
                        |> Query.has  [ text "warning"]

            , test "expect danger" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "btn-outline-danger"]
                        |> Query.has  [ text "danger"]

            ]


fancyBlockButton : Test
fancyBlockButton =
    let
        html = Button.linkButton
                 [Button.block
                 , Button.large
                 , Button.roleDanger
                 , Button.attr <| Attr.class "rounded"
                 ]
                 [Html.text "Click"]

    in
        describe "Fancy Block Button"
            [ test "expect a and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "a", text "Click"]

            , test "expect btn class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["btn", "btn-danger", "btn-block", "rounded", "btn-lg"]]

            , test "expect role attr" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ attribute "role" "button"]

            ]


buttonGroup : Test
buttonGroup =
    let
        html =
            Button.buttonGroup []
                [ Button.buttonItem [] [ Html.text "Button1" ]
                , Button.buttonItem [ Button.roleDanger ] [ Html.text "Button1" ]
                ]
    in
        describe "Button Group "
            [ test "expect div and btn-group class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "div", class "btn-group" ]
            , test "expect role" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ attribute "role" "group" ]
            , test "expect 2 button children" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.findAll [ class "btn" ]
                        |> Query.count (Expect.equal 2)
            ]


buttonGroupWithOptions : Test
buttonGroupWithOptions =
    let
        html =
            Html.div []
                [ Button.buttonGroup [ Button.largeGroup] []
                , Button.buttonGroup [ Button.verticalGroup] []
                ]

    in
        describe "Button Group with options"
            [ test "expect 1 vertical group" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.findAll [ class "btn-group-vertical"]
                        |> Query.count( Expect.equal 1)

            , test "expect 1 large group" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.findAll [ class "btn-group-lg"]
                        |> Query.count( Expect.equal 1)
            ]


buttonToolbar : Test
buttonToolbar =
    let
        html =
            Button.buttonToolbar []
                [ Button.buttonGroupItem [] []
                , Button.buttonGroupItem [] []
                ]

    in
        describe "Button toolbar"
            [ test "expect div and btn-toolbar" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [tag "div", class "btn-toolbar"]

            , test "expect 2 button groups" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.findAll [ class "btn-group"]
                        |> Query.count( Expect.equal 2)
            ]



