module Bootstrap.AccordionTest exposing (..)

import Bootstrap.Accordion as Accordion
import Bootstrap.Card.Block as Card
import Html
import Test exposing (Test, test, describe)
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class, classes, attribute, id, style)


type Msg
    = AccordionMsg Accordion.State


oneCardAccordion : Accordion.State -> Html.Html Msg
oneCardAccordion state =
    Accordion.config AccordionMsg
        |> Accordion.withAnimation
        |> Accordion.cards
            [ Accordion.card
                { id = "card1"
                , options = []
                , header =
                    Accordion.header [] <| Accordion.toggle [] [ Html.text "Card 1" ]
                , blocks =
                    [ Accordion.block []
                        [ Card.text [] [ Html.text "Lorem ipsum etc" ] ]
                    ]
                }
            ]
        |> Accordion.view state


accordion : Test
accordion =
    let
        stateDefault =
            Accordion.initialState

        stateOpen =
            Accordion.initialStateWithOptions [ Accordion.StateOptions "card1" Accordion.Shown ]

        stateClosed =
            Accordion.initialStateWithOptions [ Accordion.StateOptions "card1" Accordion.Hidden ]

        htmlDefault =
            oneCardAccordion stateDefault

        htmlOpen =
            oneCardAccordion stateOpen

        htmlClosed =
            oneCardAccordion stateClosed
    in
        describe "Accordion"
            [ test "expect default card to be closed" <|
                \() ->
                    htmlDefault
                        |> Query.fromHtml
                        |> Query.find [ id "card1" ]
                        |> Query.has
                            [ style [ ( "height", "0" ), ( "overflow", "hidden" ) ] ]
            , test "expect card with option `shown` to be open (no height of 0)" <|
                \() ->
                    htmlOpen
                        |> Query.fromHtml
                        |> Query.find [ id "card1" ]
                        |> Query.hasNot
                            [ style [ ( "height", "0" ) ] ]
            , test "expect card with option `shown` to be open (no hidden overflow)" <|
                \() ->
                    htmlOpen
                        |> Query.fromHtml
                        |> Query.find [ id "card1" ]
                        |> Query.hasNot
                            [ style [ ( "overflow", "hidden" ) ] ]
            , test "expect card with option `hidden` to be closed" <|
                \() ->
                    htmlClosed
                        |> Query.fromHtml
                        |> Query.find [ id "card1" ]
                        |> Query.has
                            [ style [ ( "height", "0" ), ( "overflow", "hidden" ) ] ]
            ]
