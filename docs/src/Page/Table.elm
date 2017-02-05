module Page.Table exposing (view, State, initialState, Msg (..))


import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.Table as Table
import Bootstrap.Grid as Grid
import Bootstrap.Card as Card
import Bootstrap.Accordion as Accordion
import Util exposing (toMarkdown)
import Bootstrap.Checkbox as Checkbox


type alias State =
    { simpleState : Accordion.State
    , optionedState : Accordion.State
    , tableOptions : List TableOption
    }


type Msg =
    SimpleMsg Accordion.State



type TableOption
    = Striped
    | Small
    | Hover
    | Inverse
    | Bordered
    | Responsive


initialState : State
initialState =
    { simpleState = Accordion.initialState
    , optionedState = Accordion.initialState
    , tableOptions = [ Striped, Hover ]
    }


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
        [ h1 [] [ text "Table"]
        , Card.simpleCard
            [ Card.outlineWarning ]
            [ Card.text
                [ class "font-italic text-muted" ]
                [ text """The table module allows you easily create tables with different styling opitons.
                    In it's current version, there is no in buildt interactive support."""
                ]
            ]
        , viewSimpleTable state toMsg
        , viewOptionedTable state toMsg
        ]



viewSimpleTable : State -> (State -> msg) -> Html msg
viewSimpleTable state toMsg =
    Grid.row
        []
        [ Grid.col
            [ Grid.colWidth Grid.colXsTwelve ]
            [ h2 [] [ text "Simple table" ]
            , text "The simpleTable function allows you to easily create tables with the default table styling in Bootstrap."
            , Table.simpleTable
                ( Table.simpleThead
                    [ Table.th [] [ text "Col 1" ]
                    , Table.th [] [ text "Col 2" ]
                    , Table.th [] [ text "Col 3" ]
                    ]
                , Table.tbody []
                    [ Table.tr []
                        [ Table.td [] [ text "Hello" ]
                        , Table.td [] [ text "Hello" ]
                        , Table.td [] [ text "Hello" ]
                        ]
                    , Table.tr []
                        [ Table.td [] [ text "There" ]
                        , Table.td [] [ text "There" ]
                        , Table.td [] [ text "There" ]
                        ]
                    , Table.tr []
                        [ Table.td [] [ text "Dude" ]
                        , Table.td [] [ text "Dude" ]
                        , Table.td [] [ text "Dude" ]
                        ]
                    ]
                )
            , Accordion.accordion
                state.simpleState
                { toMsg = (\accState -> toMsg { state | simpleState = accState} )
                , withAnimation = False
                , cards =
                    [ Accordion.card
                        { id = "simpleTable"
                        , toggle = Accordion.cardToggle [] [ text "View code"]
                        , toggleContainer = Nothing
                        , block =
                            Accordion.cardBlock [] [simpleTableSampleCode]
                        }
                    ]
                }

            ]
        ]




simpleTableSampleCode : Html msg
simpleTableSampleCode =
    toMarkdown """
```elm

Table.simpleTable
    ( Table.simpleThead
        [ Table.th [] [ text "Col 1" ]
        , Table.th [] [ text "Col 2" ]
        , Table.th [] [ text "Col 3" ]
        ]
    , Table.tbody []
        [ Table.tr []
            [ Table.td [] [ text "Hello" ]
            , Table.td [] [ text "Hello" ]
            , Table.td [] [ text "Hello" ]
            ]
        , Table.tr []
            [ Table.td [] [ text "There" ]
            , Table.td [] [ text "There" ]
            , Table.td [] [ text "There" ]
            ]
        , Table.tr []
            [ Table.td [] [ text "Dude" ]
            , Table.td [] [ text "Dude" ]
            , Table.td [] [ text "Dude" ]
            ]
        ]
    )
```
"""




viewOptionedTable : State -> (State -> msg) -> Html msg
viewOptionedTable state toMsg =
    Grid.row
        []
        [ Grid.col
            [ Grid.colWidth Grid.colXsTwelve ]
            [ h2 [] [ text "Table with options" ]
            , text "When you want to take more control of how your table should be styled you need to use the table function."
            , optionChecks state toMsg
            , Table.table
                { options = tableOptions state
                , thead =  Table.simpleThead
                    [ Table.th [] [ text "Col 1" ]
                    , Table.th [] [ text "Col 2" ]
                    , Table.th [] [ text "Col 3" ]
                    ]
                , tbody =
                    Table.tbody []
                        [ Table.tr []
                            [ Table.td [] [ text "Hello" ]
                            , Table.td [] [ text "Hello" ]
                            , Table.td [] [ text "Hello" ]
                            ]
                        , Table.tr []
                            [ Table.td [] [ text "There" ]
                            , Table.td [] [ text "There" ]
                            , Table.td [] [ text "There" ]
                            ]
                        , Table.tr []
                            [ Table.td [] [ text "Dude" ]
                            , Table.td [] [ text "Dude" ]
                            , Table.td [] [ text "Dude" ]
                            ]
                        ]
                }
            , Accordion.accordion
                state.optionedState
                { toMsg = (\accState -> toMsg { state | optionedState = accState} )
                , withAnimation = False
                , cards =
                    [ Accordion.card
                        { id = "simpleTable"
                        , toggle = Accordion.cardToggle [] [ text "View code"]
                        , toggleContainer = Nothing
                        , block =
                            Accordion.cardBlock [] [ optionedTableSampleCode ]
                        }
                    ]
                }

            ]
        ]

tableOptions : State  -> List (Table.TableOption msg)
tableOptions state =
    List.map
        (\opt ->
            case opt of
                Striped ->
                    Table.striped

                Hover ->
                    Table.hover

                Small ->
                    Table.small

                Inverse ->
                    Table.inversed

                Bordered ->
                    Table.bordered

                Responsive ->
                    Table.responsive

        )
        state.tableOptions


optionChecks : State -> (State -> msg) -> Html msg
optionChecks state toMsg =
    let
        toggleOpt opt =
            if (List.any ((==) opt) state.tableOptions) then
                toMsg { state | tableOptions = List.filter ((/=) opt) state.tableOptions }
            else
               toMsg { state | tableOptions = opt :: state.tableOptions}


    in
        div
            []
            (List.map
                (\opt ->
                    Checkbox.checkbox
                        [ Checkbox.inline
                        , Checkbox.attr <| checked (List.any ((==) opt) state.tableOptions)
                        , Checkbox.attr <| onClick (toggleOpt opt)
                        ]
                        (toString opt)

                )
            [Striped, Hover, Small, Inverse, Bordered]
            )



optionedTableSampleCode : Html msg
optionedTableSampleCode =
    toMarkdown """
```elm

Table.table
    { options = [ Table.striped, Table.hover ]
    , head =  Table.simpleThead
        [ Table.th [] [ text "Col 1" ]
        , Table.th [] [ text "Col 2" ]
        , Table.th [] [ text "Col 3" ]
        ]
    , body =
        Table.tbody []
            [ Table.tr []
                [ Table.td [] [ text "Hello" ]
                , Table.td [] [ text "Hello" ]
                , Table.td [] [ text "Hello" ]
                ]
            , Table.tr []
                [ Table.td [] [ text "There" ]
                , Table.td [] [ text "There" ]
                , Table.td [] [ text "There" ]
                ]
            , Table.tr []
                [ Table.td [] [ text "Dude" ]
                , Table.td [] [ text "Dude" ]
                , Table.td [] [ text "Dude" ]
                ]
            ]
    }
```
"""
