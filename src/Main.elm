module Main exposing (..)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Grid as Grid
import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Tag as Tag
import Bootstrap.Form as Form
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Dict


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type alias Model =
    { dummy : String
    , dropdownState : Dropdown.State
    , splitDropState : Dropdown.State
    , navDropState : Dropdown.State
    , modalState : Modal.State
    , tabState : Tab.State
    , accordionState : Dict.Dict String Accordion.CardState
    }


init : ( Model, Cmd Msg )
init =
    ( { dummy = "init"
      , dropdownState = Dropdown.initialState
      , splitDropState = Dropdown.initialState
      , navDropState = Dropdown.initialState
      , modalState = Modal.hiddenState
      , tabState = Tab.state 0
      , accordionState =
            Dict.fromList
                [ ( "card1", Accordion.cardHidden )
                , ( "card2", Accordion.cardHidden )
                ]
      }
    , Cmd.none
    )


type Msg
    = NoOp
    | DropdownMsg Dropdown.State
    | SplitMsg Dropdown.State
    | NavDropMsg Dropdown.State
    | Item1Msg
    | Item2Msg
    | SplitMainMsg
    | SplitItem1Msg
    | SplitItem2Msg
    | ModalMsg Modal.State
    | TabMsg Tab.State
    | AccordionMsg String Accordion.CardState


update : Msg -> Model -> ( Model, Cmd msg )
update msg ({ accordionState } as model) =
    case (Debug.log "MSG" msg) of
        NoOp ->
            ( { model | dummy = "NoOp" }, Cmd.none )

        Item1Msg ->
            ( { model | dummy = "item1" }, Cmd.none )

        Item2Msg ->
            ( { model | dummy = "item2" }, Cmd.none )

        DropdownMsg state ->
            ( { model | dropdownState = state }
            , Cmd.none
            )

        SplitMainMsg ->
            ( { model | dummy = "splitmain" }, Cmd.none )

        SplitItem1Msg ->
            ( { model | dummy = "splititem1" }, Cmd.none )

        SplitItem2Msg ->
            ( { model | dummy = "splititem2" }, Cmd.none )

        SplitMsg state ->
            ( { model | splitDropState = state }
            , Cmd.none
            )

        NavDropMsg state ->
            ( { model | navDropState = state }
            , Cmd.none
            )

        ModalMsg state ->
            ( { model | modalState = state }
            , Cmd.none
            )

        TabMsg state ->
            ( { model | tabState = state }
            , Cmd.none
            )

        AccordionMsg cardId state ->
            ( { model | accordionState = Dict.insert cardId state accordionState }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    let
        accordionSubs =
            Dict.toList model.accordionState
                |> List.map (\( key, val ) -> Accordion.subscriptions (AccordionMsg key) val)
    in
        Sub.batch
            ([ Dropdown.subscriptions
                model.dropdownState
                DropdownMsg
             , Dropdown.subscriptions
                model.splitDropState
                SplitMsg
             , Dropdown.subscriptions
                model.navDropState
                NavDropMsg
             ]
                ++ accordionSubs
            )


view : Model -> Html Msg
view model =
    div []
        [ CDN.stylesheetFlex
        , CDN.fontAwesome
        , Grid.container
            [ navbar model
            , mainContent model
            , accordion model
            , tabs model
            ]
        ]


mainContent : Model -> Html Msg
mainContent model =
    Grid.container
        [ simpleForm
        , gridForm
        , Grid.flexRow
            { options = [ Grid.flexRowVAlign Grid.ExtraSmall Grid.Bottom ]
            , attributes = [ flexRowStyle ]
            , cols =
                [ Grid.flexCol
                    { options = [ Grid.flexColWidth Grid.colXsTwo ]
                    , attributes = [ flexColStyle ]
                    , children =
                        [ span [ class "fa fa-car" ] []
                        , text " Col 1 Row 1"
                        ]
                    }
                , Grid.flexCol
                    { options =
                        [ Grid.flexColWidth Grid.colXsNone
                        , Grid.flexColVAlign Grid.ExtraSmall Grid.Top
                        ]
                    , attributes = [ flexColStyle ]
                    , children = [ text "Col 2 Row 1" ]
                    }
                , Grid.flexCol
                    { options =
                        [ Grid.flexColWidth Grid.colXsFive
                        , Grid.flexColVAlign Grid.ExtraSmall Grid.Middle
                        ]
                    , attributes = [ flexColStyle ]
                    , children = [ text "Col 3 Row 1" ]
                    }
                , Grid.flexCol
                    { options = [ Grid.flexColWidth Grid.colXsNone ]
                    , attributes = [ flexColStyle ]
                    , children = [ text "Col 4 Row 1" ]
                    }
                ]
            }
        , Grid.flexRow
            { options = [ Grid.flexRowVAlign Grid.ExtraSmall Grid.Middle ]
            , attributes = [ flexRowStyle ]
            , cols =
                [ Grid.flexCol
                    { options = [ Grid.flexColWidth Grid.colXsFive ]
                    , attributes = [ flexColStyle ]
                    , children =
                        [ Button.linkButton
                            { options =
                                [ Button.size Grid.Small
                                , Button.outline Button.Success
                                , Button.block
                                ]
                            , attributes = [ onClick <| ModalMsg Modal.visibleState ]
                            , children = [ text "Show modal" ]
                            }
                        ]
                    }
                ]
            }
        , Grid.flexRow
            { options = [ Grid.flexRowVAlign Grid.ExtraSmall Grid.Top ]
            , attributes = [ flexRowStyle ]
            , cols =
                [ Grid.flexCol
                    { options = [ Grid.flexColWidth Grid.colXsFive ]
                    , attributes = [ flexColStyle ]
                    , children =
                        [ Dropdown.dropdown
                            { options = [Dropdown.AlignMenuRight]
                            , toggleMsg = DropdownMsg
                            , toggleButton =
                                Dropdown.toggle
                                    { options = [ Button.role Button.Warning ]
                                    , attributes = []
                                    , children =
                                        [ text "MyDropdown "
                                        , span [ class "tag tag-pill tag-info" ] [ text "(2)" ]
                                        ]
                                    }
                            , items =
                                [ Dropdown.anchorItem
                                    [ href "#", onClick Item1Msg ]
                                    [ text "Item 1" ]
                                , Dropdown.anchorItem
                                    [ href "#", onClick Item2Msg ]
                                    [ text "Item 2" ]
                                , Dropdown.divider
                                , Dropdown.header [text "Silly items"]
                                , Dropdown.anchorItem [href "#"] [ text "DoNothing1"]
                                , Dropdown.anchorItem [href "#"] [ text "DoNothing2"]
                                ]
                            }
                            model.dropdownState
                        ]
                    }
                , Grid.flexCol
                    { options = [ Grid.flexColWidth Grid.colXsFive ]
                    , attributes = [ flexColStyle ]
                    , children =
                        [ Dropdown.splitDropdown
                            { options = [Dropdown.Dropup]
                            , toggleMsg = SplitMsg
                            , toggleButton =
                                Dropdown.splitToggle
                                    { options = [ Button.role Button.Warning ]
                                    , attributes = [ onClick SplitMainMsg ]
                                    , children = [ text "My split drop" ]
                                    }
                            , items =
                                [ Dropdown.buttonItem
                                    [ onClick SplitItem1Msg ]
                                    [ text "SplitItem 1" ]
                                , Dropdown.buttonItem
                                    [ onClick SplitItem2Msg ]
                                    [ text "SplitItem 2" ]
                                ]
                            }
                            model.splitDropState
                        ]
                    }
                , Grid.flexCol
                    { options = [ Grid.flexColWidth Grid.colXsNone ]
                    , attributes = [ flexColStyle ]
                    , children = [ text model.dummy ]
                    }
                ]
            }
        , modal model.modalState
        ]


navbar : Model -> Html Msg
navbar model =
    Navbar.navbar
        { options = [ Navbar.scheme Navbar.Dark Navbar.Primary ]
        , attributes = []
        , items =
            [ Navbar.brand [ href "#" ] [ text "Logo" ]
            , Navbar.itemLink [ href "#" ] [ text "Page" ]
            , Navbar.itemLink [ href "#" ] [ text "Another" ]
            , Navbar.customItem <|
                Dropdown.navDropdown
                    { toggleMsg = NavDropMsg
                    , toggleButton = Dropdown.navToggle [] [ text "NavDrop" ]
                    , items =
                        [ Dropdown.anchorItem [ href "#" ] [ text "Menuitem 1" ]
                        , Dropdown.anchorItem [ href "#" ] [ text "Menuitem 2" ]
                        ]
                    }
                    model.navDropState
            , Navbar.customItem <|
                span
                    [ class "navbar-text float-xs-right text-success" ]
                    [ text "Some text" ]
            ]
        }


simpleForm : Html Msg
simpleForm =
    Html.form
        []
        [ Form.group
            { validationResult = Just <| Form.validationResult Form.Success "This went well"
            , label = Form.textLabelControl "SimpleInput"
            , control =
                Form.textControl
                    { id = Just "simpleInput"
                    , options = []
                    , attributes = [ class "form-control-success" ]
                    }
            }
        , Form.groupSimple
            { label = Form.textLabelControl "Sample select"
            , control =
                Form.selectControl
                    { id = Just "simpleSelect"
                    , options = []
                    , attributes = []
                    , items =
                        [ Form.selectItem [] [ text "Option 1" ]
                        , Form.selectItem [] [ text "Option 2" ]
                        ]
                    }
            }
        , Form.checkbox
            { label = Form.textLabelControl "Check me!"
            , options = []
            , attributes = []
            }
        , Form.checkbox
            { label = Form.textLabelControl "Can't check me!"
            , options = [Form.checkDisabled]
            , attributes = []
            }
        , Form.radioGroup
            { label = Form.textLabelControl "My radios"
            , name = "MyRadios"
            , radios =
                [ Form.radioControl
                    { label = Form.textLabelControl "Radio 1"
                    , options = []
                    , attributes = []
                    }
                , Form.radioControl
                    { label = Form.textLabelControl "Radio 2"
                    , options = []
                    , attributes = []
                    }
                , Form.radioControl
                    { label = Form.textLabelControl "Radio 3"
                    , options = [Form.checkDisabled]
                    , attributes = []
                    }
                ]
            }
        , Form.group
            { validationResult = Nothing
            , label =
                Form.labelControl
                    { text = "Small input"
                    , options =
                        []
                        --[ Form.labelSize Form.Small ]
                    , attributes = []
                    }
            , control =
                Form.textControl
                    { id = Just "smallinput"
                    , options = [ Form.inputSize Grid.Small ]
                    , attributes = [ disabled True ]
                    }
            }
        ]


gridForm : Html Msg
gridForm =
    Html.form
        [ class "container" ]
        [ h2 [] [ text "Form grid" ]
        , Form.groupRowSimple
            { label = Form.textLabelControl "TextInput"
            , labelWidth = Grid.colXsFour
            , control =
                Form.textControl
                    { id = Just "rowtextinput"
                    , options = []
                    , attributes = []
                    }
            , controlWidth = Grid.colXsEight
            }
        , Form.groupRowSimple
            { label = Form.textLabelControl "Select"
            , labelWidth = Grid.colXsFour
            , control =
                Form.selectControl
                    { id = Just "rowSimpleSelect"
                    , options = []
                    , attributes = []
                    , items =
                        [ Form.selectItem [] [ text "Option 1" ]
                        , Form.selectItem [] [ text "Option 2" ]
                        ]
                    }
            , controlWidth = Grid.colXsEight
            }
        , Form.groupRow
            { validationResult = Just <| Form.validationResult Form.Danger "Forgot to fill in?"
            , label = Form.textLabelControl "TextWithValidation"
            , labelWidth = Grid.colXsFour
            , control =
                Form.textControl
                    { id = Just "rowtextinputvalidation"
                    , options = []
                    , attributes = []
                    }
            , controlWidth = Grid.colXsEight
            }
        , Form.groupRow
            { validationResult = Nothing
            , label =
                Form.labelControl
                    { text = "Small input"
                    , options = [ Form.labelSize Grid.Small ]
                    , attributes = []
                    }
            , labelWidth = Grid.colXsFour
            , control =
                Form.textControl
                    { id = Just "rowtextinputxs"
                    , options = [ Form.inputSize Grid.Small ]
                    , attributes = [ disabled True ]
                    }
            , controlWidth = Grid.colXsEight
            }
        , Form.radioGroupRow
            { label = Form.textLabelControl "My radios"
            , name = "MyRowRadios"
            , labelWidth = Grid.colXsFour
            , controlWidth = Grid.colXsEight
            , radios =
                [ Form.radioControl
                    { label = Form.textLabelControl "Radio 1"
                    , options = []
                    , attributes = []
                    }
                , Form.radioControl
                    { label = Form.textLabelControl "Radio 2"
                    , options = []
                    , attributes = []
                    }
                , Form.radioControl
                    { label = Form.textLabelControl "Radio 3"
                    , options = [Form.checkDisabled]
                    , attributes = []
                    }
                ]
            }
        , Form.checkboxRow
            { label = Form.textLabelControl "Check me!"
            , options = []
            , attributes = []
            , offset = Grid.colXsFour
            , controlWidth = Grid.colXsEight
            }
        , Form.checkboxRow
            { label = Form.textLabelControl "Can't check me!"
            , options = [Form.checkDisabled]
            , attributes = []
            , offset = Grid.colXsFour
            , controlWidth = Grid.colXsEight
            }
        ]


modal : Modal.State -> Html Msg
modal modalState =
    Modal.modal
        { closeMsg = ModalMsg
        , header = Just <| h4 [ class "modal-title" ] [ text "Modal header" ]
        , body = Just <| modalBody
        , footer =
            Just <|
                Button.button
                    { options = [ Button.outline Button.Primary ]
                    , attributes = [ onClick <| ModalMsg Modal.hiddenState ]
                    , children = [ text "Close" ]
                    }
        , size = Just <| Modal.Small
        }
        modalState


modalBody : Html Msg
modalBody =
    Grid.containerFluid
        [ Grid.row
            [ Grid.flexCol
                { options = [ Grid.flexColWidth Grid.colXsSix ]
                , attributes = []
                , children = [ text "Col 1" ]
                }
            , Grid.flexCol
                { options = [ Grid.flexColWidth Grid.colXsSix ]
                , attributes = []
                , children = [ text "Col 2" ]
                }
            ]
        ]


tabs : Model -> Html Msg
tabs model =
    Tab.tab
        { toMsg = TabMsg
        , items =
            [ Tab.tabItem
                { link = Tab.tabLink [] [ text "Tab1" ]
                , pane = Tab.tabPane [] [ listGroup ]
                }
            , Tab.tabItem
                { link = Tab.tabLink [] [ text "Tab2" ]
                , pane = Tab.tabPane [] [ listGroup2 ]
                }
            ]
        }
        model.tabState


listGroup : Html Msg
listGroup =
    ListGroup.customList
        [ ListGroup.anchorItem
            { attributes = [ href "#" ]
            , options = [ ListGroup.role ListGroup.Success ]
            , children =
                [ text "Hello"
                , Tag.pillCustom [ Tag.floatDefault, Tag.roleDefault ] [ text "1" ]
                ]
            }
        , ListGroup.anchorItem
            { attributes = [ href "#" ]
            , options = [ ListGroup.role ListGroup.Info ]
            , children =
                [ text "Aloha"
                , Tag.pillCustom
                    [ Tag.floatDefault, Tag.role Tag.Info ]
                    [ text "2" ]
                ]
            }
        ]


listGroup2 : Html Msg
listGroup2 =
    ListGroup.customList
        [ ListGroup.anchorItem
            { attributes = [ href "#" ]
            , options = []
            , children =
                [ ListGroup.h5 [] [ text "Item 1" ]
                , ListGroup.text
                    { elemFn = p, attributes = [], children = [ text "Some text paragraph" ] }
                ]
            }
        , ListGroup.anchorItem
            { attributes = [ href "#" ]
            , options = []
            , children =
                [ ListGroup.h5 [] [ text "Item 2" ]
                , ListGroup.text
                    { elemFn = p, attributes = [], children = [ text "Some other text paragraph" ] }
                ]
            }
        ]


accordion : Model -> Html Msg
accordion { accordionState } =
    Accordion.accordion
        ([ Dict.get "card1" accordionState
            |> Maybe.map renderCardOne
         , Dict.get "card2" accordionState
            |> Maybe.map renderCardTwo
         ]
            |> List.filterMap identity
        )


renderCardOne : Accordion.CardState -> Accordion.Card Msg
renderCardOne state =
    Accordion.card
        { id = "card1"
        , toMsg = AccordionMsg "card1"
        , state = state
        , withAnimation = True
        , toggle = Accordion.cardToggle [] [ text " Card With container" ]
        , toggleContainer =
            Just <|
                Accordion.toggleContainer
                    { elemFn = h3
                    , attributes = []
                    , childrenPreToggle = [ span [ class "fa fa-car" ] [] ]
                    , childrenPostToggle = []
                    }
        , block =
            Accordion.cardBlock
                [ text "Contents of Card 1"
                , div [] [ text "Some more content" ]
                ]
        }


renderCardTwo : Accordion.CardState -> Accordion.Card Msg
renderCardTwo state =
    Accordion.card
        { id = "card2"
        , toMsg = AccordionMsg "card2"
        , state = state
        , withAnimation = False
        , toggle = Accordion.cardToggle [] [ text "Card 2" ]
        , toggleContainer = Nothing
        , block =
            Accordion.cardBlock
                [ text "Contants of Card 2"
                , div [] [ text "Some more for 2" ]
                , div [] [ text "Yet even more" ]
                ]
        }


flexRowStyle : Attribute Msg
flexRowStyle =
    style
        [ ( "min-height", "8rem" )
        , ( "background-color", "rgba(255, 0, 0, 0.1)" )
        , ( "border", "1 px solid black" )
        ]


flexColStyle : Attribute Msg
flexColStyle =
    style
        [ ( "padding-top", ".75rem" )
        , ( "padding-bottom", ".75rem" )
        , ( "background-color", "rgba(86, 61, 124, 0.15)" )
        , ( "border", "1px solid rgba(86, 61, 124, 0.2)" )
        ]
