module Page.Progress exposing (view, State, initialState)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Bootstrap.Progress as Progress
import Bootstrap.Accordion as Accordion
import Util
import Bootstrap.Checkbox as Checkbox
import Bootstrap.Form as Form
import Bootstrap.TextInput as Input
import Bootstrap.Grid as Grid


type alias State =
    { dummy : Int
    , options :
        { background : Option
        , striped : Bool
        , animated : Bool
        , label : String
        , height : String
        }
    }


type Option
    = Success
    | Info
    | Warning
    | Danger
    | Default
    | Striped
    | Animated


initialState : State
initialState =
    { dummy = 0
    , options =
        { background = Default
        , striped = False
        , animated = False
        , label = "Form.label"
        , height = "15"
        }
    }


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Progress"
        """Use our custom progress component for displaying simple or complex progress bars.
        We don’t use the HTML5 <progress> element, ensuring you can stack progress bars, animate them, and place text labels over them."""
    , Util.pageContent
        (quickStart ++ optioned state toMsg ++ stacked)
    ]


quickStart =
    [ h2 [] [ text "Getting started" ]
    , p [] [ text """In it's simplest form, you only need to set a progress value between 0-100.
                  The resulting progress bar will also add accessibility support.""" ]
    , Util.example
        [ Progress.progress []
        , Progress.progress [ Progress.value 20 ]
        , Progress.progress [ Progress.value 100 ]
        ]
    , div [ class "highlight" ]
        [ quickStartCode ]
    ]


quickStartCode : Html msg
quickStartCode =
    Util.toMarkdown """
```elm
div []
    [ Progress.progress []
    , Progress.progress [ Progress.value 20 ]
    , Progress.progress [ Progress.value 100 ]
    ]
```
"""


optioned : State -> (State -> msg) -> List (Html msg)
optioned state toMsg =
    [ h2 [] [ text "Configuring look and feel" ]
    , p [] [ text """You can configure the progress bar quite a bit""" ]
    , Util.example
        [ Progress.progress (Progress.value 50 :: progressOptions state.options)
        , optionsForm state toMsg
        ]
    ]


optionsForm : State -> (State -> msg) -> Html msg
optionsForm ({ options } as state) toMsg =
    let
        radioAttr opt =
            [ Form.radioAttr <| checked <| opt == state.options.background
            , Form.radioAttr <| onClick <| toMsg { state | options = { options | background = opt } }
            ]
    in
        div [ class "row" ]
            [ div
                [ class "col-4" ]
                [ Form.form
                    []
                    [ Form.radioGroup
                        { label =
                            Form.label
                                [ Form.labelAttr <| style [ ( "font-weight", "bold" ) ] ]
                                [ text "Background options" ]
                        , name = "myradios"
                        , radios =
                            [ Form.radio (radioAttr Default) "Default"
                            , Form.radio (radioAttr Success) "Form.success"
                            , Form.radio (radioAttr Info) "Form.info"
                            , Form.radio (radioAttr Warning) "Form.warning"
                            , Form.radio (radioAttr Danger) "Form.danger"
                            ]
                        }
                    ]
                ]
            , div
                [ class "col", style [ ( "margin-top", "8px" ) ] ]
                [ Checkbox.checkbox
                    [ Checkbox.attr <| checked options.striped
                    , Checkbox.attr <| onClick <| toMsg { state | options = { options | striped = not options.striped } }
                    ]
                    "Form.striped"
                , Checkbox.checkbox
                    [ Checkbox.attr <| checked options.animated
                    , Checkbox.attr <| onClick <| toMsg { state | options = { options | animated = not options.animated } }
                    ]
                    "Form.animated"
                , Input.text
                    [ Input.attr <| defaultValue options.label
                    , Input.attr <|
                        onInput
                            (\v ->
                                toMsg { state | options = { options | label = v } }
                            )
                    ]
                , Input.number
                    [ Input.attr <| Html.Attributes.min "1"
                    , Input.attr <| Html.Attributes.max "100"
                    , Input.attr <| defaultValue options.height
                    , Input.attr <|
                        onInput
                            (\v ->
                                toMsg { state | options = { options | height = v } }
                            )
                    ]
                ]
            ]


progressOptions :
    { background : Option
    , striped : Bool
    , animated : Bool
    , label : String
    , height : String
    }
    -> List (Progress.Option msg)
progressOptions { background, animated, striped, label, height } =
    [ Progress.label label
    , Progress.height (String.toInt height |> Result.withDefault 15)
    ]
        ++ (if striped then
                [ Progress.striped ]
            else
                []
           )
        ++ (if animated then
                [ Progress.animated ]
            else
                []
           )
        ++ (case background of
                Success ->
                    [ Progress.success ]

                Info ->
                    [ Progress.info ]

                Warning ->
                    [ Progress.warning ]

                Danger ->
                    [ Progress.danger ]

                _ ->
                    []
           )


stacked : List (Html msg)
stacked =
    [ h2 [] [ text "Getting started" ]
    , p [] [ text """You can even stack multiple progress bars to get pretty funky progress bars""" ]
    , Util.example
        [ Progress.progressMulti
            [ [ Progress.value 20, Progress.success, Progress.label "Success" ]
            , [ Progress.value 30, Progress.info, Progress.label "Info" ]
            , [ Progress.value 40, Progress.danger, Progress.label "Danger" ]
            ]
        ]
    , div [ class "highlight" ]
        [ stackedCode ]
    ]


stackedCode : Html msg
stackedCode =
    Util.toMarkdown """
```elm
Progress.progressMulti
    [ [ Progress.value 20, Progress.success, Progress.label "Success" ]
    , [ Progress.value 30, Progress.info, Progress.label "Info" ]
    , [ Progress.value 40, Progress.danger, Progress.label "Danger" ]
    ]

```
"""
