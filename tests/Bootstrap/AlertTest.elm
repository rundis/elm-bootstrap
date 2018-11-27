module Bootstrap.AlertTest exposing
    ( Msg(..)
    , alertClosed
    , alertIsDismissable
    , alertWithAttributes
    , alertWithHeaders
    , alertWithLink
    , alertWithOptions
    , simpleAlerts
    )

import Bootstrap.Alert as Alert
import Expect
import Html
import Html.Attributes
import Test exposing (Test, describe, test)
import Test.Html.Event as Event
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)


type Msg
    = AlertMsg Alert.Visibility


simpleAlerts : Test
simpleAlerts =
    let
        alert txt alertFn =
            alertFn [] [ Html.text txt ]

        html =
            Html.div
                []
                [ alert "primary" Alert.simplePrimary
                , alert "secondary" Alert.simpleSecondary
                , alert "success" Alert.simpleSuccess
                , alert "info" Alert.simpleInfo
                , alert "warning" Alert.simpleWarning
                , alert "danger" Alert.simpleDanger
                , alert "light" Alert.simpleLight
                , alert "dark" Alert.simpleDark
                ]

        expectRoled roleTxt =
            html
                |> Query.fromHtml
                |> Query.find [ class ("alert-" ++ roleTxt) ]
                |> Query.has [ text roleTxt ]
    in
    describe "Simple alerts"
        [ test "Expect 8 alerts" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ class "alert" ]
                    |> Query.count (Expect.equal 8)
        , test "Expect primary" <|
            \() ->
                expectRoled "primary"
        , test "Expect secondary" <|
            \() ->
                expectRoled "secondary"
        , test "Expect success" <|
            \() ->
                expectRoled "success"
        , test "Expect info" <|
            \() ->
                expectRoled "info"
        , test "Expect warning" <|
            \() ->
                expectRoled "warning"
        , test "Expect danger" <|
            \() ->
                expectRoled "danger"
        , test "Expect light" <|
            \() ->
                expectRoled "light"
        , test "Expect dark" <|
            \() ->
                expectRoled "dark"
        ]


alertWithOptions : Test
alertWithOptions =
    let
        html alertType =
            Alert.config
                |> alertType
                |> Alert.view Alert.shown

        expectWithOption alertType nodeClass =
            html alertType
                |> Query.fromHtml
                |> Query.has [ class nodeClass ]
    in
    describe "Alert with options" <|
        [ test "Expect primary" <|
            \() -> expectWithOption Alert.primary "alert-primary"
        , test "Expect secondary" <|
            \() -> expectWithOption Alert.secondary "alert-secondary"
        , test "Expect success" <|
            \() -> expectWithOption Alert.success "alert-success"
        , test "Expect info" <|
            \() -> expectWithOption Alert.info "alert-info"
        , test "Expect warning" <|
            \() -> expectWithOption Alert.warning "alert-warning"
        , test "Expect danger" <|
            \() -> expectWithOption Alert.danger "alert-danger"
        , test "Expect dark" <|
            \() -> expectWithOption Alert.dark "alert-dark"
        , test "Expect light" <|
            \() -> expectWithOption Alert.light "alert-light"
        ]


alertIsDismissable : Test
alertIsDismissable =
    let
        html =
            Alert.config
                |> Alert.dismissable AlertMsg
                |> Alert.info
                |> Alert.children [ Html.text "X" ]
                |> Alert.view Alert.shown

        htmlWithAnimation =
            Alert.config
                |> Alert.dismissableWithAnimation AlertMsg
                |> Alert.info
                |> Alert.view Alert.shown
    in
    describe "Alert is dismissable"
        [ test "Expect close message on click" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "button" ]
                    |> Event.simulate Event.click
                    |> Event.expect (AlertMsg Alert.closed)
        , test "Expect dismissable with animation contains button with aria-label" <|
            \() ->
                htmlWithAnimation
                    |> Query.fromHtml
                    |> Query.find [ tag "button" ]
                    |> Query.has [ attribute <| Html.Attributes.attribute "aria-label" "close" ]
        ]


alertWithLink : Test
alertWithLink =
    let
        html =
            Alert.simpleInfo [] [ Alert.link [] [ Html.text "link" ] ]
    in
    describe "Alert with link"
        [ test "Expect link class and text" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "a" ]
                    |> Query.has [ class "alert-link", text "link" ]
        ]


alertWithHeaders : Test
alertWithHeaders =
    let
        html =
            Alert.simpleInfo []
                [ Alert.h1 [] [ Html.text "h1" ]
                , Alert.h2 [] [ Html.text "h2" ]
                , Alert.h3 [] [ Html.text "h3" ]
                , Alert.h4 [] [ Html.text "h4" ]
                , Alert.h5 [] [ Html.text "h5" ]
                , Alert.h6 [] [ Html.text "h6" ]
                ]

        expectH txt =
            html
                |> Query.fromHtml
                |> Query.find [ tag txt ]
                |> Query.has [ text txt ]
    in
    describe "Alert with headers"
        [ test "Expect link class and text" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ class "alert-header" ]
                    |> Query.count (Expect.equal 6)
        , test "Expect h1" <| \() -> expectH "h1"
        , test "Expect h2" <| \() -> expectH "h2"
        , test "Expect h3" <| \() -> expectH "h3"
        , test "Expect h4" <| \() -> expectH "h4"
        , test "Expect h5" <| \() -> expectH "h5"
        , test "Expect h6" <| \() -> expectH "h6"
        ]


alertWithAttributes : Test
alertWithAttributes =
    let
        html =
            Alert.simpleInfo [ Html.Attributes.class "my-class" ] []
    in
    describe "Alert with attributes"
        [ test "Expect has passed class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ classes [ "my-class" ] ]
        ]


alertClosed : Test
alertClosed =
    let
        html =
            Alert.config
                |> Alert.view Alert.closed
    in
    describe "Closed alert"
        [ test "Expect display:none" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ Test.Html.Selector.style "display" "none" ]
        ]
