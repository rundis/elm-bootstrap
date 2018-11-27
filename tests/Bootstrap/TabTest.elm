module Bootstrap.TabTest exposing (horizontalAlignment, pillsAndAttributes, simpleTabs)

import Bootstrap.Tab as Tab
import Expect
import Html exposing (h4, p, text)
import Html.Attributes as Attributes
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector as Selector exposing (attribute, class, classes, tag)


simpleTabs : Test
simpleTabs =
    let
        html =
            Tab.config (\_ -> ())
                |> Tab.items
                    [ Tab.item
                        { id = "tabItem1"
                        , link = Tab.link [] [ text "Tab 1" ]
                        , pane =
                            Tab.pane [ Attributes.class "mt-3" ]
                                [ h4 [] [ text "Tab 1 Heading" ]
                                , p [] [ text "Contents of tab 1." ]
                                ]
                        }
                    , Tab.item
                        { id = "tabItem2"
                        , link = Tab.link [] [ text "Tab 2" ]
                        , pane =
                            Tab.pane [ Attributes.class "mt-3" ]
                                [ h4 [] [ text "Tab 2 Heading" ]
                                , p [] [ text "This is something completely different." ]
                                ]
                        }
                    ]
                |> Tab.view Tab.initialState

        nav =
            html
                |> Query.fromHtml
                |> Query.find [ classes [ "nav", "nav-tabs" ] ]

        content =
            html
                |> Query.fromHtml
                |> Query.find [ class "tab-content" ]
    in
    describe "Simple tab"
        [ describe "nav"
            [ test "Expect 2 nav-items" <|
                \() ->
                    nav
                        |> Query.findAll [ class "nav-item" ]
                        |> Query.count (Expect.equal 2)
            , test "Expect link buttons to have children" <|
                \() ->
                    nav
                        |> Query.findAll [ tag "button" ]
                        |> Query.index 0
                        |> Query.has [ Selector.text "Tab 1" ]
            ]
        , describe "content"
            [ test "Expect 2 tab-panes" <|
                \() ->
                    content
                        |> Query.findAll [ class "tab-pane" ]
                        |> Query.count (Expect.equal 2)
            , test "Expect 2 mt-3 (custom attributes work)" <|
                \() ->
                    content
                        |> Query.findAll [ class "mt-3" ]
                        |> Query.count (Expect.equal 2)
            , test "Expect pane to have children" <|
                \() ->
                    content
                        |> Query.findAll [ class "tab-pane" ]
                        |> Query.index 0
                        |> Query.find [ tag "h4" ]
                        |> Query.has [ Selector.text "Tab 1 Heading" ]
            , test "Expect pane to have id attribute" <|
                \() ->
                    content
                        |> Query.findAll [ class "tab-pane" ]
                        |> Query.index 0
                        |> Query.has [ attribute <| Attributes.attribute "id" "tabItem1" ]
            ]
        ]


pillsAndAttributes : Test
pillsAndAttributes =
    let
        html =
            Tab.config (\_ -> ())
                |> Tab.pills
                |> Tab.attrs [ Attributes.name "myTabs" ]
                |> Tab.view Tab.initialState
    in
    describe "pills"
        [ test "Expect nav-pills class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "ul" ]
                    |> Query.has [ class "nav-pills" ]
        , test "Expect custom name attribute" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ tag "ul" ]
                    |> Query.has [ attribute <| Attributes.attribute "name" "myTabs" ]
        ]


horizontalAlignment : Test
horizontalAlignment =
    let
        html alignment =
            Tab.config (\_ -> ())
                |> alignment
                |> Tab.view Tab.initialState

        alignmentTest alignment className =
            test ("alignment of " ++ className) <|
                \() ->
                    html alignment
                        |> Query.fromHtml
                        |> Query.find [ class "nav-tabs" ]
                        |> Query.has [ class className ]
    in
    describe "alignment"
        [ alignmentTest Tab.center "justify-content-center"
        , alignmentTest Tab.right "justify-content-end"
        , alignmentTest Tab.justified "nav-justified"
        , alignmentTest Tab.fill "nav-fill"
        ]
