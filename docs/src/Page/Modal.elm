module Page.Modal
    exposing
        ( view
        , initialState
        , State
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.Modal as Modal
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Util


type alias State =
    { modalState : Modal.State
    , gridState : Modal.State
    }


initialState : State
initialState =
    { modalState = Modal.hiddenState
    , gridState = Modal.hiddenState
    }


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Modal"
        """Modals are streamlined, but flexible dialog prompts powered by Elm !
        They support a number of use cases from user notification to completely custom content and feature a handful of helpful subcomponents, sizes, and more."""
    , Util.pageContent
        (example state toMsg
            ++ grid state toMsg
        )
    ]


example : State -> (State -> msg) -> List (Html msg)
example state toMsg =
    [ h2 [] [ text "Example" ]
    , p [] [ text "Click the button below to show a simple example modal" ]
    , Util.example
        [ Button.button
            [ Button.outlineSuccess
            , Button.attrs [ onClick <| toMsg { state | modalState = Modal.visibleState } ]
            ]
            [ text "Open modal" ]
        , Modal.config (\ms -> toMsg { state | modalState = ms })
            |> Modal.small
            |> Modal.h3 [] [ text "Modal header" ]
            |> Modal.body [] [ p [] [ text "This is a modal for you !" ] ]
            |> Modal.footer []
                [ Button.button
                    [ Button.outlinePrimary
                    , Button.attrs [ onClick <| toMsg { state | modalState = Modal.hiddenState } ]
                    ]
                    [ text "Close" ]
                ]
            |> Modal.view state.modalState
        ]
    , Util.code exampleCode
    , Util.calloutInfo
        [ h3 [] [ text "Modal composition" ]
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


grid : State -> (State -> msg) -> List (Html msg)
grid state toMsg =
    [ h2 [] [ text "Using the Grid" ]
    , p [] [ text """Utilize the Bootstrap grid system within a modal by nesting Grid.containerFluid inside the Modal.body.
                    Then, use the normal grid system classes as you would anywhere else.""" ]
    , Util.example
        [ Button.button
            [ Button.outlineSuccess
            , Button.attrs [ onClick <| toMsg { state | gridState = Modal.visibleState } ]
            ]
            [ text "Open modal" ]
        , Modal.config (\ms -> toMsg { state | gridState = ms })
            |> Modal.large
            |> Modal.h3 [] [ text "Modal grid header" ]
            |> Modal.body []
                [ Grid.containerFluid [ class "bd-example-row" ]
                    [ Grid.row [ ]
                        [ Grid.col
                            [ Col.sm4 ] [ text "Col sm4" ]
                        , Grid.col
                            [ Col.sm8 ] [ text "Col sm8" ]
                        ]
                    , Grid.row [ ]
                        [ Grid.col
                            [ Col.md4 ] [ text "Col md4" ]
                        , Grid.col
                            [ Col.md8 ] [ text "Col md8" ]
                        ]
                    ]
                ]
            |> Modal.footer []
                [ Button.button
                    [ Button.outlinePrimary
                    , Button.attrs [ onClick <| toMsg { state | gridState = Modal.hiddenState } ]
                    ]
                    [ text "Close" ]
                ]
            |> Modal.view state.gridState

        , Util.calloutInfo
            [ p [] [ text "Try resizing the window with the modal open to observe the responsive behavior." ] ]

        , Util.code gridCode
        ]
    ]


gridCode : Html msg
gridCode =
    Util.toMarkdownElm """

-- ..
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col

div []
    [ Button.button
        [ Button.outlineSuccess
        , Button.attrs [ onClick <| ModalMsg Modal.visibleState ]
        ]
        [ text "Open modal" ]
        , Modal.config ModalMsg
            |> Modal.large
            |> Modal.h3 [] [ text "Modal grid header" ]
            |> Modal.body []
                [ Grid.containerFluid [ ]
                    [ Grid.row [ ]
                        [ Grid.col
                            [ Col.sm4 ] [ text "Col sm4" ]
                        , Grid.col
                            [ Col.sm8 ] [ text "Col sm8" ]
                        ]
                    , Grid.row [ ]
                        [ Grid.col
                            [ Col.md4 ] [ text "Col md4" ]
                        , Grid.col
                            [ Col.md8 ] [ text "Col md8" ]
                        ]
                    ]
                ]
            |> Modal.footer []
                [ Button.button
                    [ Button.outlinePrimary
                    , Button.attrs [ onClick <| ModalMsg Modal.hiddenState ]
                    ]
                    [ text "Close" ]
                ]
            |> Modal.view model.modalState
        ]
"""


