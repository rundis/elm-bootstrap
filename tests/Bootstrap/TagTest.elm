module Bootstrap.TagTest exposing (..)


import Bootstrap.Tag as Tag

import Html
import Test exposing (Test, test, describe)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, classes)


{-| @ltignore -}
all : Test
all =
    Test.concat [simpleTag, simplePill, tagWithOptions, pillWithOptions]


simpleTag : Test
simpleTag =
    let
        html = Tag.simpleTag [Html.text "1"]
    in
        describe "Simple tag"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "1" ]

            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["tag", "tag-default"] ]

            ]


simplePill : Test
simplePill =
    let
        html = Tag.simplePill [Html.text "1"]
    in
        describe "Simple pill"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "1" ]

            , test "expect default classes and pill class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["tag", "tag-default", "tag-pill"] ]

            ]

tagWithOptions : Test
tagWithOptions =
    let
        html = Tag.tag [Tag.floatXsLeft, Tag.roleDanger] [ Html.text "X"]
    in
        describe "Tag with options"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "X" ]

            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["tag", "float-xs-left", "tag-danger"] ]

            ]


pillWithOptions : Test
pillWithOptions =
    let
        html = Tag.pill [Tag.floatXsLeft, Tag.roleDanger] [ Html.text "X"]
    in
        describe "Pill with options"
            [ test "expect span and text" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ tag "span", text "X" ]

            , test "expect default classes" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has  [ classes ["tag", "float-xs-left", "tag-danger", "tag-pill"] ]

            ]
