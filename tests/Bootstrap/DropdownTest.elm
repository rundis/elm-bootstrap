module Bootstrap.DropdownTest exposing (ToggleMsg(..), dropDown, splitDropDown, state)

import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Expect
import Html
import Html.Attributes as Attr
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, classes, tag, text)


state : Dropdown.State
state =
    Dropdown.initialState


type ToggleMsg
    = ToggleMsg Dropdown.State


dropDown : Test
dropDown =
    let
        html =
            Dropdown.dropdown
                state
                { options = [ Dropdown.alignMenuRight ]
                , toggleMsg = ToggleMsg
                , toggleButton =
                    Dropdown.toggle [ Button.warning ] [ Html.text "MyDropdown1" ]
                , items =
                    [ Dropdown.buttonItem [] [ Html.text "Item 1" ]
                    , Dropdown.buttonItem [] [ Html.text "Item 2" ]
                    , Dropdown.divider
                    , Dropdown.header [ Html.text "header" ]
                    , Dropdown.buttonItem [ Attr.class "disabled" ] [ Html.text "DoNothing1" ]
                    , Dropdown.buttonItem [] [ Html.text "DoNothing2" ]
                    ]
                }
    in
    describe "Dropdown"
        [ test "expect wrapping div and class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ class "btn-group", tag "div" ]
        , test "expect button toggle" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.children [ tag "button" ]
                    |> Query.first
                    |> Query.has
                        [ classes [ "btn", "btn-warning", "dropdown-toggle" ]
                        , tag "button"
                        , text "MyDropdown1"
                        ]
        , test "expect dropdown menu" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.children [ tag "div" ]
                    |> Query.first
                    |> Query.has
                        [ classes [ "dropdown-menu", "dropdown-menu-right" ] ]
        , test "expect menu items" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ class "dropdown-item" ]
                    |> Query.count (Expect.equal 4)
        , test "expect menu header" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "dropdown-menu" ]
                    |> Query.findAll []
                    |> Query.index 3
                    |> Query.has [ class "dropdown-header", tag "h6", text "header" ]
        , test "expect menu divider" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.find [ class "dropdown-menu" ]
                    |> Query.findAll []
                    |> Query.index 2
                    |> Query.has [ class "dropdown-divider", tag "div" ]
        ]


splitDropDown : Test
splitDropDown =
    let
        html =
            Dropdown.splitDropdown
                state
                { options = [ Dropdown.dropUp ]
                , toggleMsg = ToggleMsg
                , toggleButton =
                    Dropdown.splitToggle
                        { options = [ Button.info ]
                        , togglerOptions = [ Button.info ]
                        , children = [ Html.text "Split" ]
                        }
                , items =
                    [ Dropdown.buttonItem [] [ Html.text "Item 1" ] ]
                }
    in
    describe "Split dropdown"
        [ test "expect wrapping div and class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.has [ class "btn-group", tag "div" ]
        , test "expect main button" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.children [ tag "button" ]
                    |> Query.first
                    |> Query.has [ classes [ "btn", "btn-info" ], tag "button" ]
        , test "expect toggle button" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.children [ tag "button" ]
                    |> Query.index 1
                    |> Query.has
                        [ classes [ "btn", "btn-info", "dropdown-toggle", "dropdown-toggle-split" ]
                        , tag "button"
                        , attribute <| Attr.attribute "type" "button"
                        ]
        ]
