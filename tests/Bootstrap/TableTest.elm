module Bootstrap.TableTest exposing (..)

import Bootstrap.Table as Table

import Html
import Html.Attributes as Attr
import Test exposing (Test, test, describe)
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class, classes, attribute)



all = ""



superSimple : Test
superSimple =
    let
        html =
            Table.simpleTable
                ( Table.simpleThead
                    [ Table.th [] [ Html.text "col1"]
                    , Table.th [] [ Html.text "col2"]
                    ]
                , Table.tbody []
                    [ Table.tr []
                        [ Table.td [] [Html.text "col1row1"]
                        , Table.td [] [Html.text "col2row1"]
                        ]
                    , Table.tr []
                        [ Table.td [] [Html.text "col1row2"]
                        , Table.td [] [Html.text "col2row2"]
                        ]
                    ]
                )
    in
        describe "Super simple table"
            [ test "expect class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ class "table"]

            , test "expect thead" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.children []
                        |> Query.first
                        |> Query.has [ tag "thead"]

            , test "expect ths" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "thead" ]
                        |> Query.children [ tag "tr"]
                        |> Query.first
                        |> Query.children []
                        |> Query.each (Query.has [tag "th"])

            , test "expect tbody" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.children []
                        |> Query.index 1
                        |> Query.has [ tag "tbody"]

            , test "expect tds" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.find [ tag "tbody" ]
                        |> Query.findAll [ tag "td"]
                        |> Query.count (Expect.equal 4)

            ]



styledTable : Test
styledTable =
    let
        html =
            defaultTable
                [ Table.bordered
                , Table.inversed
                , Table.small
                , Table.hover
                ]
    in
        describe "Styled table"
            [ test "expect class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has
                            [ classes
                                [ "table", "table-bordered", "table-hover", "table-sm", "table-inverse" ]
                            ]

            , test "expect wrapped in div when responsive" <|
                \() ->
                    defaultTable [ Table.responsive ]
                        |> Query.fromHtml
                        |> Query.has [ class "table-responsive", tag "div"]
            ]

reflowedTable : Test
reflowedTable =
    let
        html =
            defaultTable [ Table.reflow ]

    in
        describe "Reflowed table"
            [ test "expect class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ class "table-reflow"]

            ]



styledThead : Test
styledThead =
    let
        tblHtml option =
            Table.table
                { options = []
                , thead = defaultThead [ option ]
                , tbody = defaultTbody
                }

    in
        describe "Styled thead "
            [ test "expect inversed" <|
                \() ->
                    tblHtml Table.inversedHead
                        |> Query.fromHtml
                        |> Query.find [ tag "thead"]
                        |> Query.has [ class "thead-inverse"]

            , test "expect default" <|
                \() ->
                    tblHtml Table.defaultHead
                        |> Query.fromHtml
                        |> Query.find [ tag "thead"]
                        |> Query.has [ class "thead-default"]
            ]



defaultTable : List (Table.TableOption msg) -> Html.Html msg
defaultTable options =
    Table.table
        { options = options
        , thead = defaultThead []
        , tbody = defaultTbody
        }


defaultThead : List (Table.TableHeadOption msg) -> Table.THead msg
defaultThead options =
    Table.thead options
        [ Table.tr []
            [ Table.th [] [ Html.text "col1" ]
            , Table.th [] [ Html.text "col2" ]
            ]
        ]


defaultTbody : Table.TBody msg
defaultTbody =
    Table.tbody []
        [ Table.tr []
            [ Table.td [] [ Html.text "col1row1" ]
            , Table.td [] [ Html.text "col2row1" ]
            ]
        , Table.tr []
            [ Table.td [] [ Html.text "col1row2" ]
            , Table.td [] [ Html.text "col2row2" ]
            ]
        ]
