module Page.Dropdown
    exposing
        ( view
        , State
        , initialState
        , subscriptions
        )

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Button as Button
import Bootstrap.Form as Form
import Bootstrap.Form.Radio as Radio
import Bootstrap.Form.Checkbox as Chk
import Util


type alias State =
    { basicState : Dropdown.State
    , customizedState : Dropdown.State
    , splitState : Dropdown.State
    , menuState : Dropdown.State
    , options : Options
    }


initialState : State
initialState =
    { basicState = Dropdown.initialState
    , customizedState = Dropdown.initialState
    , splitState = Dropdown.initialState
    , menuState = Dropdown.initialState
    , options = defaultOptions
    }


type alias Options =
    { coloring : Coloring
    , size : Size
    , dropUp : Bool
    , menuRight : Bool
    }


type Coloring
    = Primary
    | Secondary
    | Info
    | Warning
    | Danger
    | OutlinePrimary
    | OutlineSecondary
    | OutlineInfo
    | OutlineWarning
    | OutlineDanger


type Size
    = Small
    | Medium
    | Large


defaultOptions : Options
defaultOptions =
    { coloring = Primary
    , size = Medium
    , dropUp = False
    , menuRight = False
    }


subscriptions : State -> (State -> msg) -> Sub msg
subscriptions state toMsg =
    Sub.batch
        [ Dropdown.subscriptions state.basicState (\dd -> toMsg { state | basicState = dd })
        , Dropdown.subscriptions state.customizedState (\dd -> toMsg { state | customizedState = dd })
        , Dropdown.subscriptions state.splitState (\dd -> toMsg { state | splitState = dd })
        , Dropdown.subscriptions state.menuState (\dd -> toMsg { state | menuState = dd })
        ]


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Dropdown"
        """Dropdowns are toggleable, contextual overlays for displaying lists of links and more.
           They’re made interactive with a little bit of Elm. They’re toggled by clicking."""
    , Util.pageContent
        (basic state toMsg
            ++ customized state toMsg
            ++ split state toMsg
            ++ menu state toMsg
        )
    ]


basic : State -> (State -> msg) -> List (Html msg)
basic state toMsg =
    [ h2 [] [ text "Basic example" ]
    , p [] [ text "Since dropdowns are interactive, we need to do a little bit of wiring to use them." ]
    , Util.example
        [ Dropdown.dropdown
            state.basicState
            { options = []
            , toggleMsg = (\dd -> toMsg { state | basicState = dd })
            , toggleButton =
                Dropdown.toggle [ Button.outlinePrimary ] [ text "My dropdown" ]
            , items =
                [ Dropdown.buttonItem [] [ text "Item 1" ]
                , Dropdown.buttonItem [] [ text "Item 2" ]
                ]
            }
        ]
    , Util.code basicCode
    ]


basicCode : Html msg
basicCode =
    Util.toMarkdownElm """

-- Dropdowns depends on view state to keep track of whether it is (/should be) open or not
type alias Model =
    { myDrop1State : Dropdown.State }


-- init

init : (Model, Cmd Msg )
init =
    ( { myDrop1State = Dropdown.initialState} -- initially closed
    , Cmd.none
    )


-- Msg

type Msg
    = MyDrop1Msg Dropdown.State


-- In your update function you will to handle messages coming from the dropdown

update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        MyDrop1Msg state ->
            ( { model | myDrop1State = state }
            , Cmd.none
            )


-- Dropdowns relies on subscriptions to automatically close any open when clicking outside them

subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Dropdown.subscriptions model.myDrop1State MyDrop1Msg ]


-- Specify config and how the dropdown should look in your view (or view helper) function

view : Model -> Html Msg
view model =
    div []
        [ Dropdown.dropdown
            model.myDrop1State
            { options = [ ]
            , toggleMsg = MyDrop1Msg
            , toggleButton =
                Dropdown.toggle [ Button.primary ] [ text "My dropdown" ]
            , items =
                [ Dropdown.buttonItem [ onClick Item1Msg ] [ text "Item 1" ]
                , Dropdown.buttonItem [ onClick Item2Msg ] [ text "Item 2" ]
                ]
            }

        -- etc
        ]

"""


customized : State -> (State -> msg) -> List (Html msg)
customized state toMsg =
    [ h2 [] [ text "Customization" ]
    , p [] [ text "You can do quite a lot of customization on the dropdown and the dropdown button." ]
    , Util.example <|
        [ Dropdown.dropdown
            state.customizedState
            { options = customizedDropOptions state
            , toggleMsg = (\dd -> toMsg { state | customizedState = dd })
            , toggleButton =
                Dropdown.toggle (customizedButtonOptions state) [ text "My dropdown" ]
            , items =
                [ Dropdown.buttonItem [] [ text "Item 1" ]
                , Dropdown.buttonItem [] [ text "Item 2" ]
                ]
            }
        ]
            ++ [customizeForm state toMsg]
    ]


customizeForm : State -> (State -> msg) -> Html msg
customizeForm ({ options } as state) toMsg =
    let
        coloringAttrs opt rName =
            [ Radio.checked <| opt == options.coloring
            , Radio.name rName
            , Radio.onClick <| toMsg { state | options = { options | coloring = opt } }
            ]

        sizeAttrs opt =
            [ Radio.inline
            , Radio.name "sizes"
            , Radio.checked <| opt == options.size
            , Radio.onClick <| toMsg { state | options = { options | size = opt } }
            ]
    in
        Form.form [ class "container mt-3" ]
            [ h4 [] [ text "Dropdown customization" ]
            , Form.row []
                [ Form.col []
                    [ Chk.custom
                        [ Chk.inline
                        , Chk.checked options.dropUp
                        , Chk.onCheck
                            (\b -> toMsg { state | options = { options | dropUp = b } })
                        ]
                        "Dropdown.dropUp"
                    ]
                ]
            , Form.row []
                [ Form.col []
                    [ Form.group []
                        [ Form.label
                            [ style [ ( "font-weight", "bold" ) ] ]
                            [ text "Button Coloring" ]
                        , div []
                            [ Radio.custom (coloringAttrs Primary "coloring") "Button.primary"
                            , Radio.custom (coloringAttrs Secondary "coloring") "Button.secondary"
                            , Radio.custom (coloringAttrs Info "coloring") "Button.info"
                            , Radio.custom (coloringAttrs Warning "coloring") "Button.warning"
                            , Radio.custom (coloringAttrs Danger "coloring") "Button.danger"
                            ]
                        ]
                    ]
                , Form.col []
                    [ Form.group []
                        [ Form.label
                            [ ]
                            [ text "" ]
                        , div []
                            [ Radio.custom (coloringAttrs OutlinePrimary "outlcoloring") "Button.outlinePrimary"
                            , Radio.custom (coloringAttrs OutlineSecondary "outlcoloring") "Button.outlineSecondary"
                            , Radio.custom (coloringAttrs OutlineInfo "outlcoloring") "Button.outlineInfo"
                            , Radio.custom (coloringAttrs OutlineWarning "outlcoloring") "Button.outlineWarning"
                            , Radio.custom (coloringAttrs OutlineDanger "outlcoloring") "Button.outlineDanger"
                            ]
                        ]
                    ]
                ]
            , Form.row []
                [ Form.col []
                    [ Form.label
                        [ style [ ( "font-weight", "bold" ) ]]
                        [ text "Button sizes" ]
                    , div []
                        [ Radio.custom (sizeAttrs Small) "Button.small"
                        , Radio.custom (sizeAttrs Medium) "Default"
                        , Radio.custom (sizeAttrs Large) "Button.large"
                        ]
                    ]
                ]
        ]


customizedDropOptions : State -> List Dropdown.DropdownOption
customizedDropOptions { options } =
    (if options.dropUp then
        [ Dropdown.dropUp ]
     else
        []
    )
        ++ (if options.menuRight then
                [ Dropdown.alignMenuRight ]
            else
                []
           )


customizedButtonOptions : State -> List (Button.Option msg)
customizedButtonOptions { options } =
    (case options.coloring of
        Primary ->
            [ Button.primary ]

        Secondary ->
            [ Button.secondary ]

        Info ->
            [ Button.info ]

        Warning ->
            [ Button.warning ]

        Danger ->
            [ Button.danger ]

        OutlinePrimary ->
            [ Button.outlinePrimary ]

        OutlineSecondary ->
            [ Button.outlineSecondary ]

        OutlineInfo ->
            [ Button.outlineInfo ]

        OutlineWarning ->
            [ Button.outlineWarning ]

        OutlineDanger ->
            [ Button.outlineDanger ]
    )
        ++ (case options.size of
                Small ->
                    [ Button.small ]

                Medium ->
                    []

                Large ->
                    [ Button.large ]
           )


split : State -> (State -> msg) -> List (Html msg)
split state toMsg =
    [ h2 [] [ text "Split button dropdowns" ]
    , p [] [ text "You can also create split button dropdowns. The left button has a normal button action, whilst the right (caret) button toggles the dropdown menu." ]
    , Util.example
        [ Dropdown.splitDropdown
            state.splitState
            { options = []
            , toggleMsg = (\dd -> toMsg { state | splitState = dd })
            , toggleButton =
                Dropdown.splitToggle
                    { options = [ Button.secondary ]
                    , togglerOptions = [ Button.secondary ]
                    , children = [ text "My split dropdown" ]
                    }
            , items =
                [ Dropdown.buttonItem [] [ text "Item 1" ]
                , Dropdown.buttonItem [] [ text "Item 2" ]
                ]
            }
        ]
    , Util.code splitCode
    ]


splitCode : Html msg
splitCode =
    Util.toMarkdownElm """
Dropdown.splitDropdown
    model.mySplitDropdownState
    { options = []
    , toggleMsg = MySplitDropdownMsg
    , toggleButton =
        Dropdown.splitToggle
            { options = [ Button.secondary]
            , togglerOptions = [ Button.secondary ]
            , children = [ text "My split dropdown" ]
            }
    , items =
        [ Dropdown.buttonItem [] [ text "Item 1" ]
        , Dropdown.buttonItem [] [ text "Item 2" ]
        ]
    }
"""


menu : State -> (State -> msg) -> List (Html msg)
menu state toMsg =
    [ h2 [] [ text "Menu headers and dividers" ]
    , p [] [ text "You may use menu header and divder elements to organize your dropdown items." ]
    , Util.example
        [ Dropdown.dropdown
            state.menuState
            { options = []
            , toggleMsg = (\dd -> toMsg { state | menuState = dd })
            , toggleButton =
                Dropdown.toggle [ Button.warning ] [ text "My dropdown" ]
            , items =
                [ Dropdown.header [ text "Header" ]
                , Dropdown.buttonItem [] [ text "Item 1" ]
                , Dropdown.buttonItem [] [ text "Item 2" ]
                , Dropdown.divider
                , Dropdown.header [ text "Another heading" ]
                , Dropdown.buttonItem [] [ text "Item 3" ]
                , Dropdown.buttonItem [] [ text "Item 4" ]
                ]
            }
        ]
    , Util.code menuCode
    ]


menuCode : Html msg
menuCode =
    Util.toMarkdownElm """

Dropdown.dropdown
    model.myDropdownState
    { options = []
    , toggleMsg = MyDropdownMsg
    , toggleButton =
        Dropdown.toggle [ Button.warning ] [ text "My dropdown" ]
    , items =
        [ Dropdown.header [ text "Header"]
        , Dropdown.buttonItem [] [ text "Item 1" ]
        , Dropdown.buttonItem [] [ text "Item 2" ]
        , Dropdown.divider
        , Dropdown.header [ text "Another heading" ]
        , Dropdown.buttonItem [] [ text "Item 3" ]
        , Dropdown.buttonItem [] [ text "Item 4" ]
        ]
    }
"""
