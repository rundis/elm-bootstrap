module Bootstrap.AccordionTest exposing (..)

import Bootstrap.Accordion as Accordion
import Bootstrap.Card.Block as Block
import Expect
import Html as Html exposing (div, text)
import Html.Attributes as Attr
import Test exposing (Test, describe, test)
import Test.Html.Query as Query
import Test.Html.Selector exposing (attribute, class, tag)


type Msg
    = AccordionMsg Accordion.State


type alias Model =
    { accordionState : Accordion.State }


initModel : Model
initModel =
    { accordionState = Accordion.initialState }


accordionHasCorrectOuterClass : Test
accordionHasCorrectOuterClass =
    let
        model =
            initModel

        html =
            div []
                [ Accordion.config AccordionMsg
                    |> Accordion.withAnimation
                    |> Accordion.cards
                        [ Accordion.card
                            { id = "card1"
                            , options = []
                            , header = Accordion.header [] <| Accordion.toggle [] [ text "Card 1" ]
                            , blocks = [ Accordion.block [] [ Block.text [] [ text "Lorem ipsum etc" ] ] ]
                            }
                        , Accordion.card
                            { id = "card2"
                            , options = []
                            , header = Accordion.header [] <| Accordion.toggle [] [ text "Card 2" ]
                            , blocks = [ Accordion.block [] [ Block.text [] [ text "Lorem ipsum etc" ] ] ]
                            }
                        ]
                    |> Accordion.view model.accordionState
                ]
    in
    describe "Accordion with 2 cards"
        [ test "ensure parent has correct class" <|
            \() ->
                html
                    |> Query.fromHtml
                    |> Query.findAll [ tag "div" ]
                    |> Query.first
                    |> Query.has [ class "accordion" ]
        ]
