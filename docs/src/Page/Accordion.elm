module Page.Accordion
    exposing
        ( view
        , State
        , initialState
        , subscriptions
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Accordion as Accordion
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Card as Card
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Text as Text
import Util


type alias State =
    { exampleState : Accordion.State
    , advancedState : Accordion.State
    }


initialState : State
initialState =
    { exampleState = Accordion.initialState
    , advancedState = Accordion.initialState
    }


subscriptions : State -> (State -> msg) -> Sub msg
subscriptions state toMsg =
    Sub.batch
        [ Accordion.subscriptions state.exampleState (\ac -> toMsg { state | exampleState = ac })
        , Accordion.subscriptions state.advancedState (\ac -> toMsg { state | advancedState = ac })
        ]


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Accordion"
        """An accordion is a group of stacked cards where you can toggle the visibility (slide up/down) of each card"""
    , Util.pageContent
        (example state toMsg
            ++ advanced state toMsg
        )
    ]


example : State -> (State -> msg) -> List (Html msg)
example state toMsg =
    [ h2 [] [ text "Basic example" ]
    , p [] [ text "Accordions are interactive elements and needs view state to work. To use an accordion there is a little bit of wiring involved." ]
    , Util.example
        [ Accordion.accordion
            state.exampleState
            { toMsg = (\ac -> toMsg { state | exampleState = ac })
            , withAnimation = True
            , cards =
                [ Accordion.card
                    { id = "card1"
                    , options = []
                    , header =
                        Accordion.header [] <| Accordion.toggle [] [ text "Card 1" ]
                    , blocks =
                        [ Accordion.block []
                            [ Card.text [] [ text "Lorem ipsum etc" ] ]
                        ]
                    }
                , Accordion.card
                    { id = "card2"
                    , options = []
                    , header =
                        Accordion.header [] <| Accordion.toggle [] [ text "Card 2" ]
                    , blocks =
                        [ Accordion.block []
                            [ Card.text [] [ text "Lorem ipsum etc" ] ]
                        ]
                    }
                ]
            }
        ]
    , Util.code exampleCode
    ]


exampleCode : Html msg
exampleCode =
    Util.toMarkdownElm """


import Bootstrap.Accordion as Accordion
import Bootstrap.Card as Card  -- We reuse functions from the Card module to build/configure accordion content

-- You need to keep track of the view state of the Accordion

type alias Model =
        { accordionState = Accordion.state }


-- Initialize the accordion state in your init function

init: (Model, Cmd Msg)
    ( { accordionState = Accordion.initialState }, Cmd.none )


-- To step the view state of the accordion forward, you'll need a msg
type Msg
    = AccordionMsg Accordion.State



-- Your update function should update the view state of the accordion upon receiving accordion messages

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        AccordionMsg state ->
            ( { model | accordionState = state } , Cmd.none )


-- Displaying an accordion requires the view state and a config record as parameters

view : Model -> Html Msg
view model =
    Accordion.accordion
        model.accordionState
        { toMsg = AccordionMsg
        , withAnimation = True
        , cards =
            [ Accordion.card
                { id = "card1"
                , options = []
                , header =
                    Accordion.header [] <| Accordion.toggle [] [ text "Card 1" ]
                , blocks =
                    [ Accordion.block []
                        [ Card.text [] [ text "Lorem ipsum etc" ] ]
                    ]
                }
            , Accordion.card
                { id = "card2"
                , options = []
                , header =
                    Accordion.header [] <| Accordion.toggle [] [ text "Card 2" ]
                , blocks =
                    [ Accordion.block []
                        [ Card.text [] [ text "Lorem ipsum etc" ] ]
                    ]
                }
            ]
        }

-- You need to do this wiring when you use animations !

subscriptions : Model -> Sub Msg
subscriptions model =
    Accordion.subscriptions model.accordionState AccordionMsg

"""


advanced : State -> (State -> msg) -> List (Html msg)
advanced state toMsg =
    [ h2 [] [ text "Customized headers and content" ]
    , p []
        [ text """You can customize the individual accordion cards quite a bit.
                  Accordion cards reuses quite a bit of functionality from the Card module, so you will be using function from that module when writing the view for an accordion."""
        ]
    , Util.example
        [ Accordion.accordion
            state.advancedState
            { toMsg = (\ac -> toMsg { state | advancedState = ac })
            , withAnimation = True
            , cards =
                [ Accordion.card
                    { id = "card1"
                    , options = [ Card.outlineSuccess, Card.align Text.alignXsCenter ]
                    , header =
                        Accordion.headerH3 []
                            (Accordion.toggle [] [ text " Card 1" ])
                            |> Accordion.prependHeader
                                [ span [ class "fa fa-car" ] [] ]
                    , blocks =
                        [ Accordion.block [ Card.blockAlign Text.alignXsLeft ]
                            [ Card.titleH4 [] [ text "Block title" ]
                            , Card.text [] [ text "Lorem ipsum etc" ] ]
                        , Accordion.block [ Card.blockAlign Text.alignXsRight ]
                            [ Card.titleH4 [] [ text "Block2 title" ]
                            , Card.text [] [ text "Lorem ipsum etc" ] ]
                        ]
                    }
                , Accordion.card
                    { id = "card2"
                    , options = [ Card.outlineSuccess, Card.align Text.alignXsCenter ]
                    , header =
                        Accordion.headerH3 []
                            (Accordion.toggle [] [ text " Card 2"] )
                            |> Accordion.prependHeader
                                [ span [ class "fa fa-taxi" ] [] ]
                    , blocks =
                        [ Accordion.block []
                            [ Card.text [] [ text "Lorem ipsum etc" ] ]
                        , Accordion.listGroup
                            [ ListGroup.li [] [ text "List item 1"]
                            , ListGroup.li [] [ text "List item 2"]
                            ]
                        ]
                    }
                ]
            }
        ]
    , Util.code advancedCode
    ]


advancedCode : Html msg
advancedCode =
    Util.toMarkdownElm """
Accordion.accordion
    model.accordionState
    { toMsg = AccordionMsg
    , withAnimation = True
    , cards =
        [ Accordion.card
            { id = "card1"
            , options = [ Card.outlineSuccess, Card.align Text.alignXsCenter ]
            , header =
                Accordion.headerH3 []
                    (Accordion.toggle [] [ text " Card 1" ])
                    |> Accordion.prependHeader
                        [ span [ class "fa fa-car" ] [] ]
            , blocks =
                [ Accordion.block [ Card.blockAlign Text.alignXsLeft ]
                    [ Card.titleH4 [] [ text "Block title" ]
                    , Card.text [] [ text "Lorem ipsum etc" ] ]
                , Accordion.block [ Card.blockAlign Text.alignXsRight ]
                    [ Card.titleH4 [] [ text "Block2 title" ]
                    , Card.text [] [ text "Lorem ipsum etc" ] ]
                ]
            }
        , Accordion.card
            { id = "card2"
            , options = [ Card.outlineSuccess, Card.align Text.alignXsCenter ]
            , header =
                Accordion.headerH3 []
                    (Accordion.toggle [] [ text " Card 2"] )
                    |> Accordion.prependHeader
                        [ span [ class "fa fa-taxi" ] [] ]
            , blocks =
                [ Accordion.block []
                    [ Card.text [] [ text "Lorem ipsum etc" ] ]
                , Accordion.listGroup
                    [ ListGroup.li [] [ text "List item 1"]
                    , ListGroup.li [] [ text "List item 2"]
                    ]
                ]
            }
        ]
    }
"""
