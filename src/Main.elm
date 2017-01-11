module Main exposing (..)

import Bootstrap.Text as Text
import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Grid as Grid
import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion
import Bootstrap.ListGroup as ListGroup
import Bootstrap.Badge as Badge
import Bootstrap.Form as Form
import Bootstrap.Card as Card
import Bootstrap.Table as Table
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
            ([ Dropdown.subscriptions model.dropdownState DropdownMsg
             , Dropdown.subscriptions model.splitDropState SplitMsg
             , Dropdown.subscriptions model.navDropState NavDropMsg
             ]
                ++ accordionSubs
            )


view : Model -> Html Msg
view model =
    div []
        [ CDN.stylesheet
        , CDN.fontAwesome
        , navbar model
        , mainContent model
        ]


mainContent : Model -> Html Msg
mainContent model =
    Grid.container [style [ ( "margin-top", "60px" ) ] ]
        [ simpleForm
        , gridForm
        , Grid.row
            { options = [ Grid.rowBottom ]
            , attributes = [ rowStyle ]
            , cols =
                [ Grid.col
                    { options = [ Grid.colWidth Grid.colXsTwo ]
                    , attributes = [ colStyle ]
                    , children =
                        [ span [ class "fa fa-car" ] []
                        , text " Col 1 Row 1"
                        ]
                    }
                , Grid.col
                    { options =
                        [ Grid.colWidth Grid.colXsNone
                        , Grid.colTop
                        ]
                    , attributes = [ colStyle ]
                    , children = [ text "Col 2 Row 1" ]
                    }
                , Grid.col
                    { options =
                        [ Grid.colWidth Grid.colXsFive
                        , Grid.colMiddle
                        ]
                    , attributes = [ colStyle ]
                    , children = [ text "Col 3 Row 1" ]
                    }
                , Grid.col
                    { options = [ Grid.colWidth Grid.colXsNone ]
                    , attributes = [ colStyle ]
                    , children = [ text "Col 4 Row 1" ]
                    }
                ]
            }
        , Grid.row
            { options = [ Grid.rowMiddle ]
            , attributes = [ rowStyle ]
            , cols =
                [ Grid.col
                    { options = [ Grid.colWidth Grid.colXsFive ]
                    , attributes = [ colStyle ]
                    , children =
                        [ Button.linkButton
                            [ Button.small
                            , Button.outlineSuccess
                            , Button.block
                            , Button.attr <| onClick <| ModalMsg Modal.visibleState
                            ]
                            [ text "Show modal" ]
                        ]
                    }
                ]
            }
        , Grid.row
            { options = [ Grid.rowTop ]
            , attributes = [ rowStyle ]
            , cols =
                [ Grid.col
                    { options = [ Grid.colWidth Grid.colXsFive ]
                    , attributes = [ colStyle ]
                    , children =
                        [ Dropdown.dropdown
                            model.dropdownState
                            { options = [ Dropdown.AlignMenuRight ]
                            , toggleMsg = DropdownMsg
                            , toggleButton =
                                Dropdown.toggle
                                    [ Button.roleWarning ]
                                    [ text "MyDropdown "
                                    , span [ class "tag tag-pill tag-info" ] [ text "(2)" ]
                                    ]
                            , items =
                                [ Dropdown.anchorItem
                                    [ href "#", onClick Item1Msg ]
                                    [ text "Item 1" ]
                                , Dropdown.anchorItem
                                    [ href "#", onClick Item2Msg ]
                                    [ text "Item 2" ]
                                , Dropdown.divider
                                , Dropdown.header [ text "Silly items" ]
                                , Dropdown.anchorItem [ href "#meh", class "disabled" ] [ text "DoNothing1" ]
                                , Dropdown.anchorItem [ href "#" ] [ text "DoNothing2" ]
                                ]
                            }
                        ]
                    }
                , Grid.col
                    { options = [ Grid.colWidth Grid.colXsFive ]
                    , attributes = [ colStyle ]
                    , children =
                        [ Dropdown.splitDropdown
                            model.splitDropState
                            { options = [ Dropdown.Dropup ]
                            , toggleMsg = SplitMsg
                            , toggleButton =
                                Dropdown.splitToggle
                                    { options =
                                        [ Button.roleWarning
                                        , Button.attr <| onClick SplitMainMsg
                                        ]
                                    , togglerOptions = [ Button.roleWarning ]
                                    , children = [ text "My split drop" ]
                                    }
                            , items =
                                [ Dropdown.buttonItem
                                    [ onClick SplitItem1Msg ]
                                    [ text "SplitItem 1" ]
                                , Dropdown.buttonItem
                                    [ onClick SplitItem2Msg ]
                                    [ text "SplitItem 2" ]
                                , Dropdown.buttonItem
                                    [ onClick SplitItem2Msg, class "disabled", disabled True ]
                                    [ text "SplitItem 2" ]
                                ]
                            }
                        ]
                    }
                , Grid.col
                    { options = [ Grid.colWidth Grid.colXsNone ]
                    , attributes = [ colStyle ]
                    , children = [ text model.dummy ]
                    }
                ]
            }
        , accordion model
        , tabs model
        , cards
        , tables
        , modal model.modalState
        ]


navbar : Model -> Html Msg
navbar model =
    Navbar.navbar
        { options = [Navbar.fixTop, Navbar.primary ]
        , attributes = [ class "container" ]
        , brand = Just <| Navbar.brand [ href "#" ] [ text "Logo" ]
        , items =
            [ Navbar.itemLink [ href "#" ] [ text "Page" ]
            , Navbar.itemLink [ href "#" ] [ text "Another" ]
            , Navbar.customItem <|
                Dropdown.navDropdown
                    model.navDropState
                    { toggleMsg = NavDropMsg
                    , toggleButton = Dropdown.navToggle [] [ text "NavDrop" ]
                    , items =
                        [ Dropdown.anchorItem [ href "#" ] [ text "Menuitem 1" ]
                        , Dropdown.anchorItem [ href "#" ] [ text "Menuitem 2" ]
                        ]
                    }
            , Navbar.customItem <|
                span
                    [ class "navbar-text text-success" ]
                    [ text "Some text" ]
            ]
        }


simpleForm : Html Msg
simpleForm =
    Html.form
        []
        [ h1 [] [ text "Form" ]
        , Form.group
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
            , options = [ Form.checkDisabled ]
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
                    , options = [ Form.checkDisabled ]
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
                    , options = [ Form.inputSmall ]
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
                    , options = [ Form.labelSmall ]
                    , attributes = []
                    }
            , labelWidth = Grid.colXsFour
            , control =
                Form.textControl
                    { id = Just "rowtextinputxs"
                    , options = [ Form.inputSmall ]
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
                    , options = [ Form.checkDisabled ]
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
            , options = [ Form.checkDisabled ]
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
                    [ Button.outlinePrimary
                    , Button.attr <| onClick <| ModalMsg Modal.hiddenState
                    ]
                    [ text "Close" ]
        , options = [ Modal.small ]
        }
        modalState


modalBody : Html Msg
modalBody =
    Grid.containerFluid []
        [ Grid.simpleRow
            [ Grid.col
                { options = [ Grid.colWidth Grid.colXsSix ]
                , attributes = []
                , children = [ text "Col 1" ]
                }
            , Grid.col
                { options = [ Grid.colWidth Grid.colXsSix ]
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
            , options = [ ListGroup.roleSuccess ]
            , children =
                [ text "Hello"
                , Badge.pill [ Badge.roleDefault ] [ text "1" ]
                ]
            }
        , ListGroup.anchorItem
            { attributes = [ href "#" ]
            , options = [ ListGroup.roleInfo ]
            , children =
                [ text "Aloha"
                , Badge.pill
                    [ Badge.roleInfo ]
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
                , ListGroup.text [] [ text "Some text paragraph" ]
                ]
            }
        , ListGroup.anchorItem
            { attributes = [ href "#" ]
            , options = []
            , children =
                [ ListGroup.h5 [] [ text "Item 2" ]
                , ListGroup.text [] [ text "Some other text paragraph" ]
                ]
            }
        ]


accordion : Model -> Html Msg
accordion { accordionState } =
    div []
        [ h1 [] [ text "Accordion" ]
        , Accordion.accordion
            ([ Dict.get "card1" accordionState
                |> Maybe.map renderCardOne
             , Dict.get "card2" accordionState
                |> Maybe.map renderCardTwo
             ]
                |> List.filterMap identity
            )
        ]


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


cards : Html Msg
cards =
    div []
        [ h1 [] [ text "Cards" ]
        , Card.deck
            [ Card.cardItem
                { options = [ Card.outlinePrimary ]
                , header = Just <| Card.headerH1 [] [ text "Primary" ]
                , footer = Just <| Card.footer [] [ text "Primary footer" ]
                , imgTop = Nothing
                , imgBottom = Nothing
                , blocks =
                    [ Card.block []
                        [ Card.titleH4 [] [ text "Primary outlined" ]
                        , Card.text [] [ text "Outlined primary card. Cool." ]
                        ]
                    ]
                }
            , Card.cardItem
                { options = [ Card.outlineSuccess ]
                , header = Just <| Card.headerH1 [] [ text "Success" ]
                , footer = Just <| Card.footer [] [ text "Success footer" ]
                , imgTop = Nothing
                , imgBottom = Nothing
                , blocks =
                    [ Card.block
                        [ Card.blockAlign Text.alignXsLeft ]
                        [ Card.titleH4 [] [ text "Success outlined" ]
                        , Card.text [] [ text "The success of outlining cards is staggering" ]
                        , Card.link [ href "#" ] [ text "Link 1" ]
                        , Card.link [ href "#" ] [ text "Link 2" ]
                        ]
                    ]
                }
            ]
        , Card.group
            [ Card.simpleCardItem
                [ Card.roleDanger, Card.align Text.alignXsCenter ]
                [ Card.titleH4 [] [ text "Danger inverse " ]
                , Card.text [] [ text " A Simple card with a dangerous role" ]
                , Card.link [ href "#" ] [ text "A Link !" ]
                ]
            , Card.simpleCardItem
                [ Card.roleWarning, Card.align Text.alignXsLeft ]
                [ Card.titleH4 [] [ text "Warning inverse " ]
                , Card.text [] [ text " A Simple card with a warning role" ]
                ]
            , Card.simpleCardItem
                [ Card.roleInfo, Card.align Text.alignXsRight ]
                [ Card.titleH4 [] [ text "Info inverse " ]
                , Card.text [] [ text " A Simple card with a info role" ]
                ]
            ]
        , Card.simpleCard
            [ Card.outlineSuccess ]
            [ Card.text [] [ text "Just some text you know" ] ]
        ]


tables : Html Msg
tables =
    div []
        [ h1 [] [ text "Simple Table" ]
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
        , h1 [] [ text "Whacky Table" ]
        , Table.table
            { options =
                [ Table.hover
                , Table.bordered
                , Table.small
                , Table.attr <| onClick NoOp
                ]
            , thead =
                Table.thead
                    [ Table.inversedHead ]
                    [ Table.tr []
                        [ Table.th [ Table.cellWarning ] [ text "Col 1" ]
                        , Table.th [] [ text "Col 2" ]
                        , Table.th [] [ text "Col 3" ]
                        ]
                    ]
            , tbody =
                Table.tbody []
                    [ Table.tr
                        [ Table.rowSuccess ]
                        [ Table.th [] [ text "Hello" ]
                        , Table.td [] [ text "Hello" ]
                        , Table.td [] [ text "Hello" ]
                        ]
                    , Table.tr []
                        [ Table.th [ Table.cellInfo ] [ text "There" ]
                        , Table.td [] [ text "There" ]
                        , Table.td [] [ text "There" ]
                        ]
                    , Table.tr []
                        [ Table.th [] [ text "Dude" ]
                        , Table.td [] [ text "Dude" ]
                        , Table.td [] [ text "Dude" ]
                        ]
                    ]
            }
        ]


rowStyle : Attribute Msg
rowStyle =
    style
        [ ( "min-height", "8rem" )
        , ( "background-color", "rgba(255, 0, 0, 0.1)" )
        , ( "border", "1 px solid black" )
        ]


colStyle : Attribute Msg
colStyle =
    style
        [ ( "padding-top", ".75rem" )
        , ( "padding-bottom", ".75rem" )
        , ( "background-color", "rgba(86, 61, 124, 0.15)" )
        , ( "border", "1px solid rgba(86, 61, 124, 0.2)" )
        ]
