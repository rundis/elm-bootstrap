module Bootstrap.AlertTest exposing (..)


import Bootstrap.Alert as Alert

import Html
import Test exposing (Test, test, describe)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class, classes)


{-| @ltignore -}
all : Test
all =
    Test.concat [simpleAlerts, alertWithLink, alertWithHeaders]



simpleAlerts : Test
simpleAlerts =
    let
        html =
            Html.div
                []
                [ Alert.success [Html.text "success"]
                , Alert.info [Html.text "info"]
                , Alert.warning [Html.text "warning"]
                , Alert.danger [Html.text "danger"]
                ]

    in
        describe "Simple alerts"
            [ test "Expect 4 alerts" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.findAll [ class "alert" ]
                        |> Query.count (Expect.equal 4)
            , test "Expect success" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "alert-success" ]
                        |> Query.has [ text "success"]

            , test "Expect info" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "alert-info" ]
                        |> Query.has [ text "info"]

            , test "Expect warning" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "alert-warning" ]
                        |> Query.has [ text "warning"]

            , test "Expect danger" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ class "alert-danger" ]
                        |> Query.has [ text "danger"]

            ]

alertWithLink : Test
alertWithLink =
    let
        html =
            Alert.info
                [Alert.link [] [Html.text "link"]]
    in
        describe "Alert with link"
            [ test "Expect link class and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "a" ]
                        |> Query.has [ class "alert-link", text "link"]
            ]


alertWithHeaders : Test
alertWithHeaders =
    let
        html =
            Alert.info
                [ Alert.h1 [] [Html.text "h1"]
                , Alert.h2 [] [Html.text "h2"]
                , Alert.h3 [] [Html.text "h3"]
                , Alert.h4 [] [Html.text "h4"]
                , Alert.h5 [] [Html.text "h5"]
                , Alert.h6 [] [Html.text "h6"]
                ]
    in
        describe "Alert with headers"
            [ test "Expect link class and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.findAll [ class "alert-header" ]
                        |> Query.count (Expect.equal 6)

            , test "Expect h1" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "h1" ]
                        |> Query.has [ text "h1"]
            , test "Expect h2" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "h2" ]
                        |> Query.has [ text "h2"]
            , test "Expect h3" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "h3" ]
                        |> Query.has [ text "h3"]
            , test "Expect h4" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "h4" ]
                        |> Query.has [ text "h4"]
            , test "Expect h5" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "h5" ]
                        |> Query.has [ text "h5"]
            , test "Expect h6" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "h6" ]
                        |> Query.has [ text "h6"]
            ]

