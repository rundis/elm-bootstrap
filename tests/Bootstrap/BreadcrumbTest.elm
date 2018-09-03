module Bootstrap.BreadcrumbTest exposing (testWithTwoItems, testWithoutItems)

import Bootstrap.Breadcrumb as Breadcrumb
import Expect
import Html exposing (div, text)
import Html.Attributes as Attr
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, tag)


testWithoutItems : Test
testWithoutItems =
    let
        html =
            Breadcrumb.container []
    in
    describe "Test without items"
        [ test "Expect an empty text node only" <|
            \() ->
                html
                    |> Expect.equal (text "")
        ]


testWithTwoItems : Test
testWithTwoItems =
    let
        html =
            div []
                [ Breadcrumb.container
                    [ Breadcrumb.item [] [ text "home" ]
                    , Breadcrumb.item [] [ text "page" ]
                    ]
                ]
    in
    describe "Tests with two items"
        [ test "Expect the navigation with an aria-label" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "nav" ]
                    |> Query.has [ attribute <| Attr.attribute "aria-label" "breadcrumb" ]
        , test "Expect the navigation with the role 'navigation'" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "nav" ]
                    |> Query.has [ attribute <| Attr.attribute "role" "navigation" ]
        , test "Expect the orderen list with the class 'breadcrumb'" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "ol" ]
                    |> Query.has [ class "breadcrumb" ]
        , test "Expect two list items" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.count (Expect.equal 2)
        , test "Expect list items with class the 'breadcrumb-item'" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.each (Query.has [ class "breadcrumb-item" ])
        , test "Expect first element to contain 'home'" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.index 0
                    |> Query.contains [ text "home" ]
        , test "Expect second element to contain 'page'" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.index 1
                    |> Query.contains [ text "page" ]
        , test "Expect first element without an aria-current" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.index 0
                    |> Query.hasNot [ attribute <| Attr.attribute "aria-current" "page" ]
        , test "Expect second/last element with an aria-current" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "li" ]
                    |> Query.index 1
                    |> Query.has [ attribute <| Attr.attribute "aria-current" "page" ]
        ]
