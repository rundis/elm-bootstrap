module Page.Modal exposing
    (view
    , initialState
    , State
    )

import Html exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.Modal as Modal
import Bootstrap.Button as Button
import Util

type alias State =
    { modalState : Modal.State }


initialState : State
initialState =
    { modalState = Modal.hiddenState }


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Modal"
        """Modals are streamlined, but flexible dialog prompts powered by Elm !
        They support a number of use cases from user notification to completely custom content and feature a handful of helpful subcomponents, sizes, and more."""
    , Util.pageContent
        (example state toMsg)
    ]



example : State -> (State -> msg) -> List (Html msg)
example state toMsg =
    [ h2 [] [text "Example"]
    , p [] [ text "Click the button below to show a simple example modal"]
    , Util.example
        [ Button.button
            [ Button.outlineSuccess
            , Button.attrs [ onClick <| toMsg { state | modalState = Modal.visibleState} ]
            ]
            [ text "Open modal"]
        , Modal.config (\ms -> toMsg { state | modalState = ms})
            |> Modal.small
            |> Modal.h3 [] [ text "Modal header" ]
            |> Modal.body [] [ p [] [ text "This is a modal for you !"] ]
            |> Modal.footer []
                [Button.button
                    [ Button.outlinePrimary
                    , Button.attrs [ onClick <| toMsg { state | modalState = Modal.hiddenState} ]
                    ]
                    [ text "Close" ]
                ]
            |> Modal.view state.modalState
        ]
    , Util.code exampleCode
    , Util.calloutInfo
        [ h3 [] [ text "Modal composition"]
        , ul []
            [ textLi "You start out by using the config function providing the modal *Msg as it's argument"
            , textLi "Then compose your modal with optional options, header, body and footer. The order is not important."
            , textLi "Finally to turn the modal into Elm Html you call the view function, passing it the current state of the modal"
            ]
        ]
    ]

textLi : String -> Html msg
textLi str =
    li [] [ text str ]


exampleCode : Html msg
exampleCode =
    Util.toMarkdownElm """


-- The modal uses view state that you should keep track of in your model

type alias Model =
        { modalState : Modal.State }


-- Initialize your model

init : ( Model, Cmd Msg )
init =
    ( { modalState : Modal.initalState}, Cmd.none )


-- Define a message for your modal

type Msg
    = ModalMsg Modal.State


-- Handle modal messages in your update function

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        ModelMsg state ->
            ( { model | modalState = state } , Cmd.none )


-- Configure your modal view using pipeline friendly functions.

view : Model -> Html msg
view model =
    div []
        [ Button.button
            [ Button.outlineSuccess
            , Button.attrs [ onClick <| ModalMsg Modal.visibleState} ]
            ]
            [ text "Open modal"]
        , Modal.config ModalMsg
            |> Modal.small
            |> Modal.h3 [] [ text "Modal header" ]
            |> Modal.body [] [ p [] [ text "This is a modal for you !"] ]
            |> Modal.footer []
                [ Button.button
                    [ Button.outlinePrimary
                    , Button.attrs [ onClick <| toMsg { state | modalState = Modal.hiddenState} ]
                    ]
                    [ text "Close" ]
                ]
            |> Modal.view model.modalState
        ]

"""
