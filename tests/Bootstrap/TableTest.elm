module Bootstrap.TableTest exposing (defaultTable, defaultTbody, defaultThead, styledTable, styledTdOrRowInBody, styledThOrRowInHead, styledThead, superSimple)

import Bootstrap.Table as Table
import Expect
import Html
import Html.Attributes as Attr
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)


superSimple : Test
superSimple =
    let
        html =
            Table.simpleTable
                ( Table.simpleThead
                    [ Table.th [] [ Html.text "col1" ]
                    , Table.th [] [ Html.text "col2" ]
                    ]
                , Table.tbody []
                    [ Table.tr []
                        [ Table.td [] [ Html.text "col1row1" ]
                        , Table.td [] [ Html.text "col2row1" ]
                        ]
                    , Table.tr []
                        [ Table.td [] [ Html.text "col1row2" ]
                        , Table.td [] [ Html.text "col2row2" ]
                        ]
                    ]
                )
    in
    describe "Super simple table"
        [ test "expect class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ class "table" ]
        , test "expect thead" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.first
                    |> Query.has [ tag "thead" ]
        , test "expect ths" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "thead" ]
                    |> Query.children [ tag "tr" ]
                    |> Query.first
                    |> Query.children []
                    |> Query.each (Query.has [ tag "th" ])
        , test "expect tbody" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.children []
                    |> Query.index 1
                    |> Query.has [ tag "tbody" ]
        , test "expect tds" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.findAll [ tag "td" ]
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
                            [ "table", "table-bordered", "table-hover", "table-sm", "table-dark" ]
                        ]
        , test "expect wrapped in div when responsive" <|
            \() ->
                defaultTable [ Table.responsive ]
                    |> Query.fromHtml
                    |> Query.has [ class "table-responsive", tag "div" ]
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
                    |> Query.find [ tag "thead" ]
                    |> Query.has [ class "thead-dark" ]
        , test "expect default" <|
            \() ->
                tblHtml Table.defaultHead
                    |> Query.fromHtml
                    |> Query.find [ tag "thead" ]
                    |> Query.has [ class "thead-default" ]
        ]


styledTdOrRowInBody : Test
styledTdOrRowInBody =
    let
        html tableOptions =
            Table.table
                { options = tableOptions
                , thead = Table.simpleThead [ Table.th [] [] ]
                , tbody =
                    Table.tbody []
                        [ Table.tr
                            [ Table.rowAttr <| Attr.align "left"
                            , Table.rowSuccess
                            ]
                            [ Table.td
                                [ Table.cellActive
                                , Table.cellAttr <| Attr.align "left"
                                ]
                                [ Html.text "cell" ]
                            ]
                        ]
                }
    in
    describe "Styled cell in body "
        [ test "expect td active class and custom attribute" <|
            \() ->
                html []
                    |> Query.fromHtml
                    |> Query.find [ tag "td" ]
                    |> Query.has [ class "table-active", attribute <| Attr.attribute "align" "left" ]
        , test "expect td active bg class when table inversed" <|
            \() ->
                html [ Table.inversed ]
                    |> Query.fromHtml
                    |> Query.find [ tag "td" ]
                    |> Query.has [ class "bg-active" ]
        , test "expect tr success class and custom attribute" <|
            \() ->
                html []
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.first
                    |> Query.has [ class "table-success", attribute <| Attr.attribute "align" "left" ]
        , test "expect tr success bg class when table inversed" <|
            \() ->
                html [ Table.inversed ]
                    |> Query.fromHtml
                    |> Query.find [ tag "tbody" ]
                    |> Query.children []
                    |> Query.first
                    |> Query.has [ class "bg-success" ]
        ]


styledThOrRowInHead : Test
styledThOrRowInHead =
    let
        html tableOptions headOptions =
            Table.table
                { options = tableOptions
                , thead =
                    Table.thead
                        headOptions
                        [ Table.tr
                            [ Table.rowInfo ]
                            [ Table.th
                                [ Table.cellActive ]
                                [ Html.text "col" ]
                            ]
                        ]
                , tbody =
                    Table.tbody []
                        [ Table.tr [] [ Table.td [] [] ] ]
                }
    in
    describe "Styled cell in head"
        [ test "expect th active class" <|
            \() ->
                html [] []
                    |> Query.fromHtml
                    |> Query.find [ tag "th" ]
                    |> Query.has [ class "table-active" ]
        , test "expect th active bg class when table inversed" <|
            \() ->
                html [ Table.inversed ] []
                    |> Query.fromHtml
                    |> Query.find [ tag "th" ]
                    |> Query.has [ class "bg-active" ]
        , test "expect th active bg class when thead inversed" <|
            \() ->
                html [] [ Table.inversedHead ]
                    |> Query.fromHtml
                    |> Query.find [ tag "th" ]
                    |> Query.has [ class "bg-active" ]
        , test "expect tr info class" <|
            \() ->
                html [] []
                    |> Query.fromHtml
                    |> Query.find [ tag "thead" ]
                    |> Query.children []
                    |> Query.first
                    |> Query.has [ class "table-info" ]
        , test "expect tr info bg class when table inversed" <|
            \() ->
                html [] [ Table.inversedHead ]
                    |> Query.fromHtml
                    |> Query.find [ tag "thead" ]
                    |> Query.children []
                    |> Query.first
                    |> Query.has [ class "bg-info" ]
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
