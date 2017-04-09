module Bootstrap.ListGroupTest exposing (..)

import Bootstrap.ListGroup as ListGroup
import Html exposing (text)
import Html.Attributes as Attr exposing (href)
import Test exposing (Test, test, describe)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector as Selector exposing (tag, class, classes, attribute, disabled)


{-| @ltignore
-}
all : Test
all =
    Test.concat
        [ vanillaListGroup
        , keyedListGroup
        , contextualListGroup
        , customListGroup
        , contextualListGroup
        ]


vanillaListGroup : Test
vanillaListGroup =
    let
        html =
            ListGroup.ul
                [ ListGroup.li [] [ text "List item 1" ]
                ]

        active =
            ListGroup.ul
                [ ListGroup.li [ ListGroup.active ] [ text "List item 1" ]
                ]

        disabled =
            ListGroup.ul
                [ ListGroup.li [ ListGroup.disabled ] [ text "List item 1" ]
                ]
    in
        describe "vanilla ListGroup"
            [ test "expect ul with list-group class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "ul", class "list-group" ]
            , test "expect li with list-group-item class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "li", class "list-group-item" ]
            , test "expect li is not disabled" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "li", Selector.disabled False ]
            , test "expect li has content" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "li", Selector.text "List item 1" ]
            , test "expect li with active class" <|
                \() ->
                    active
                        |> Query.fromHtml
                        |> Query.has [ tag "li", class "active" ]
            , test "expect li with disabled class and attribute" <|
                \() ->
                    disabled
                        |> Query.fromHtml
                        |> Query.has [ tag "li", class "disabled", Selector.disabled True ]
            ]


{-| The fact that an element is keyed is not visible from the dom, so
this just tests that the keyed versions produce the same html as the "vanilla" ones
-}
keyedListGroup : Test
keyedListGroup =
    let
        keyed =
            ListGroup.keyedUl
                [ ( "List item 1", ListGroup.li [] [ text "List item 1" ] )
                ]

        customKeyed =
            ListGroup.keyedCustom
                [ ( "List item 1", ListGroup.button [] [ text "List item 1" ] )
                ]
    in
        describe "keyed ListGroup"
            [ test "expect ul with list-group class" <|
                \() ->
                    keyed
                        |> Query.fromHtml
                        |> Query.has [ tag "ul", class "list-group" ]
            , test "expect li with list-group-item class" <|
                \() ->
                    keyed
                        |> Query.fromHtml
                        |> Query.has [ tag "li", class "list-group-item" ]
            , test "expect div with list-group class" <|
                \() ->
                    customKeyed
                        |> Query.fromHtml
                        |> Query.has [ tag "div", class "list-group" ]
            , test "expect button with list-group-item class" <|
                \() ->
                    customKeyed
                        |> Query.fromHtml
                        |> Query.has [ tag "button", class "list-group-item", class "list-group-item-action" ]
            ]


customListGroup : Test
customListGroup =
    let
        anchors =
            ListGroup.custom
                [ ListGroup.anchor [ ListGroup.active, ListGroup.attrs [ href "javascript:void();" ] ] [ text "List item 1" ]
                , ListGroup.anchor [ ListGroup.attrs [ href "javascript:void();" ] ] [ text "List item 2" ]
                , ListGroup.anchor [ ListGroup.disabled, ListGroup.attrs [ href "http://www.google.com" ] ] [ text "List item 3" ]
                ]

        buttons =
            ListGroup.custom
                [ ListGroup.button [ ListGroup.active ] [ text "List item 1" ]
                , ListGroup.button [] [ text "List item 2" ]
                , ListGroup.button [ ListGroup.disabled ] [ text "List item 3" ]
                ]
    in
        describe "Custom ListGroup"
            [ test "expect div with list-group class" <|
                \() ->
                    anchors
                        |> Query.fromHtml
                        |> Query.has [ tag "div", class "list-group" ]
            , test "expect a with list-group-item class" <|
                \() ->
                    anchors
                        |> Query.fromHtml
                        |> Query.has [ tag "a", class "list-group-item", class "list-group-item-action" ]
            , test "expect div with list-group class" <|
                \() ->
                    buttons
                        |> Query.fromHtml
                        |> Query.has [ tag "div", class "list-group" ]
            , test "expect button with list-group-item class" <|
                \() ->
                    buttons
                        |> Query.fromHtml
                        |> Query.has [ tag "button", class "list-group-item", class "list-group-item-action" ]
            ]


contextual : String -> Html.Html msg -> Test
contextual name html =
    describe name
        [ test "expect success" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "list-group-item-success" ]
                    |> Query.has [ Selector.text "success" ]
        , test "expect info" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "list-group-item-info" ]
                    |> Query.has [ Selector.text "info" ]
        , test "expect warning" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "list-group-item-warning" ]
                    |> Query.has [ Selector.text "warning" ]
        , test "expect danger" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "list-group-item-danger" ]
                    |> Query.has [ Selector.text "danger" ]
        ]


contextualListGroup : Test
contextualListGroup =
    let
        contextualList =
            ListGroup.ul
                [ ListGroup.li [ ListGroup.success ] [ text "success" ]
                , ListGroup.li [ ListGroup.info ] [ text "info" ]
                , ListGroup.li [ ListGroup.warning ] [ text "warning" ]
                , ListGroup.li [ ListGroup.danger ] [ text "danger" ]
                ]

        contextualButtonList =
            ListGroup.custom
                [ ListGroup.button [ ListGroup.success ] [ text "success" ]
                , ListGroup.button [ ListGroup.info ] [ text "info" ]
                , ListGroup.button [ ListGroup.warning ] [ text "warning" ]
                , ListGroup.button [ ListGroup.danger ] [ text "danger" ]
                ]
    in
        describe "contextual ListGroup"
            [ contextual "ListGroup with contextual items" contextualList
            , contextual "custom ListGroup with contextual items" contextualButtonList
            ]
