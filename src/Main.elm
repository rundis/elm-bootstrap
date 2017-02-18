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
import Bootstrap.TextInput as Input
import Bootstrap.Progress as Progress
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Color


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
    , modalState : Modal.State
    , tabState : Tab.State
    , accordionState : Accordion.State
    , navbarState : Navbar.State
    , navMsgCounter : Int
    }


init : ( Model, Cmd Msg )
init =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg
    in
        ( { dummy = "init"
          , dropdownState = Dropdown.initialState
          , splitDropState = Dropdown.initialState
          , modalState = Modal.hiddenState
          , tabState = Tab.initialState
          , accordionState = Accordion.initialState
          , navbarState = navbarState
          , navMsgCounter = 0
          }
        , navbarCmd
        )


type Msg
    = NoOp
    | DropdownMsg Dropdown.State
    | SplitMsg Dropdown.State
    | Item1Msg
    | Item2Msg
    | SplitMainMsg
    | SplitItem1Msg
    | SplitItem2Msg
    | ModalMsg Modal.State
    | TabMsg Tab.State
    | AccordionMsg Accordion.State
    | NavbarMsg Navbar.State


update : Msg -> Model -> ( Model, Cmd msg )
update msg ({ accordionState } as model) =
    case msg of
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

        ModalMsg state ->
            ( { model | modalState = state }
            , Cmd.none
            )

        TabMsg state ->
            ( { model | tabState = state }
            , Cmd.none
            )

        AccordionMsg state ->
            ( { model | accordionState = state }
            , Cmd.none
            )

        NavbarMsg state ->
            ( { model | navbarState = state, navMsgCounter = model.navMsgCounter + 1 }
            , Cmd.none
            )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Accordion.subscriptions model.accordionState AccordionMsg
        , Dropdown.subscriptions model.dropdownState DropdownMsg
        , Dropdown.subscriptions model.splitDropState SplitMsg
        , Tab.subscriptions model.tabState TabMsg
        , Navbar.subscriptions model.navbarState NavbarMsg
        ]


view : Model -> Html Msg
view model =
    Grid.container []
        [ CDN.stylesheet
        , CDN.fontAwesome
        , mainContent model
        ]


mainContent : Model -> Html Msg
mainContent model =
    div [ style [ ( "margin-top", "60px" ) ] ]
        [ navbar model
        , simpleForm
        , gridForm
        , Grid.row
            [ Grid.rowBottom, Grid.rowAttr rowStyle ]
            [ Grid.col
                [ Grid.colWidth Grid.colXsTwo, Grid.colAttr colStyle ]
                [ span [ class "fa fa-car" ] []
                , text " Col 1 Row 1"
                ]
            , Grid.col
                [ Grid.colWidth Grid.colXsNone
                , Grid.colTop
                , Grid.colAttr colStyle
                ]
                [ text "Col 2 Row 1" ]
            , Grid.col
                [ Grid.colWidth Grid.colXsFive
                , Grid.colMiddle
                , Grid.colAttr colStyle
                ]
                [ text "Col 3 Row 1" ]
            , Grid.col
                [ Grid.colWidth Grid.colXsNone, Grid.colAttr colStyle ]
                [ text "Col 4 Row 1" ]
            ]
        , Grid.row
            [ Grid.rowMiddle, Grid.rowAttr rowStyle ]
            [ Grid.col
                [ Grid.colWidth Grid.colXsFive ]
                [ Button.linkButton
                    [ Button.small
                    , Button.outlineSuccess
                    , Button.block
                    , Button.attrs [ onClick <| ModalMsg Modal.visibleState ]
                    ]
                    [ text "Show modal" ]
                ]
            ]
        , Grid.row
            [ Grid.rowTop, Grid.rowAttr rowStyle ]
            [ Grid.col
                [ Grid.colWidth Grid.colXsFive, Grid.colAttr colStyle ]
                [ Dropdown.dropdown
                    model.dropdownState
                    { options = [ Dropdown.alignMenuRight ]
                    , toggleMsg = DropdownMsg
                    , toggleButton =
                        Dropdown.toggle
                            [ Button.warning ]
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
            , Grid.col
                [ Grid.colWidth Grid.colXsFive, Grid.colAttr colStyle ]
                [ Dropdown.splitDropdown
                    model.splitDropState
                    { options = [ Dropdown.dropUp, Dropdown.alignMenuRight ]
                    , toggleMsg = SplitMsg
                    , toggleButton =
                        Dropdown.splitToggle
                            { options =
                                [ Button.warning
                                , Button.attrs [ onClick SplitMainMsg ]
                                ]
                            , togglerOptions = [ Button.warning ]
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
            , Grid.col
                [ Grid.colWidth Grid.colXsNone, Grid.colAttr colStyle ]
                [ text model.dummy ]
            ]
        , accordion model
        , tabs model
        , cards
        , tables
        , listGroup2
        , progressBars
        , modal model.modalState
        ]


navbar : Model -> Html Msg
navbar model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.container
        |> Navbar.fixTop
        |> Navbar.darkCustom Color.brown
        |> Navbar.collapseMedium
        |> Navbar.brand [ href "#" ] [ text "Logo" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#" ] [ text "Page" ]
            , Navbar.itemLinkActive [ href "#" ] [ text "Another" ]
            , Navbar.itemLink [ href "#" ] [ text "More" ]
            , Navbar.dropdown
                { id = "navdropdown1"
                , toggle = Navbar.dropdownToggle [] [ text "Navdrop" ]
                , items =
                    [ Navbar.dropdownItem [ href "#meh" ] [ text "Menuitem1" ]
                    , Navbar.dropdownItem [ href "#meh" ] [ text "Menuitem2" ]
                    ]
                }
            ]
        |> Navbar.customItems
             [ Navbar.textItem [] [ text "Some text" ]
            , Navbar.formItem [ class "ml-lg-2" ]
                [ Input.text
                    [ Input.small ]
                , Button.button
                    [ Button.success, Button.small ]
                    [ text "Submit" ]
                ]
            ]
        |> Navbar.view model.navbarState



simpleForm : Html Msg
simpleForm =
    Form.form
        []
        [ Form.customItem <| h1 [] [ text "Form" ]
        , Form.group
            { validation = Just <| Form.success "This went well"
            , help = Just <| Form.help [] [ text "Enter something clever here" ]
            , label = Form.textLabel "SimpleInput"
            , control = Form.text [ Form.inputId "simpleInput" ]
            }
        , Form.groupSimple
            { label = Form.textLabel "Sample select"
            , control =
                Form.select
                    [ Form.inputId "simpleSelect" ]
                    [ Form.selectItem [] [ text "Option 1" ]
                    , Form.selectItem [] [ text "Option 2" ]
                    ]
            }
        , Form.checkbox [] "Check me!"
        , Form.checkbox
            [ Form.checkDisabled ]
            "Can't check me!"
        , Form.radioGroup
            { label = Form.textLabel "My radios"
            , name = "MyRadios"
            , radios =
                [ Form.radio [ Form.radioInline ] "Radio 1"
                , Form.radio [ Form.radioInline ] "Radio 2"
                , Form.radio [] "Radio 3"
                ]
            }
        , Form.group
            { validation = Nothing
            , help = Nothing
            , label = Form.label [] [ text "Small input" ]
            , control =
                Form.text
                    [ Form.inputId "smallinput"
                    , Form.inputSmall
                    , Form.inputAttr <| disabled True
                    ]
            }
        , Form.group
            { validation = Just <| Form.warning "A bit short ?"
            , help = Just <| Form.help [] [ text "Enter a password with at least 8 characters" ]
            , label = Form.label [] [ text "Password" ]
            , control =
                Form.password
                    [ Form.inputId "pwd" ]
            }
        ]


gridForm : Html Msg
gridForm =
    Form.form
        [ class "container" ]
        [ Form.customItem <| h2 [] [ text "Form grid" ]
        , Form.groupRowSimple
            { label = Form.textLabel "TextInput"
            , labelWidth = Grid.colXsFour
            , control = Form.text [ Form.inputId "rowtextinput" ]
            , controlWidth = Grid.colXsEight
            }
        , Form.groupRowSimple
            { label = Form.textLabel "Select"
            , labelWidth = Grid.colXsFour
            , control =
                Form.select
                    [ Form.inputId "rowSimpleSelect" ]
                    [ Form.selectItem [] [ text "Option 1" ]
                    , Form.selectItem [] [ text "Option 2" ]
                    ]
            , controlWidth = Grid.colXsEight
            }
        , Form.groupRow
            { validation = Just <| Form.error "Forgot to fill in?"
            , help = Nothing
            , label = Form.textLabel "TextWithValidation"
            , labelWidth = Grid.colXsFour
            , control = Form.text [ Form.inputId "rowtextinputvalidation" ]
            , controlWidth = Grid.colXsEight
            }
        , Form.groupRow
            { validation = Nothing
            , help = Nothing
            , label =
                Form.label [ Form.labelSmall ] [ text "Small input" ]
            , labelWidth = Grid.colXsFour
            , control =
                Form.text
                    [ Form.inputId "rowtextinputxs"
                    , Form.inputAttr <| disabled True
                    , Form.inputSmall
                    ]
            , controlWidth = Grid.colXsEight
            }
        , Form.radioGroupRow
            { label = Form.textLabel "My radios"
            , name = "MyRowRadios"
            , labelWidth = Grid.colXsFour
            , controlWidth = Grid.colXsEight
            , radios =
                [ Form.radio [] "Radio 1"
                , Form.radio [] "Radio 2"
                , Form.radio
                    [ Form.radioDisabled ]
                    "Radio 3"
                ]
            }
        , Form.checkboxRow
            { labelText = "Check me!"
            , options = []
            , offset = Grid.colXsFour
            , controlWidth = Grid.colXsEight
            }
        , Form.checkboxRow
            { labelText = "Can't check me!"
            , options = [ Form.checkDisabled ]
            , offset = Grid.colXsFour
            , controlWidth = Grid.colXsEight
            }
        ]


modal : Modal.State -> Html Msg
modal modalState =
    Modal.config ModalMsg
        |> Modal.h5 [] [ text "Modal header" ]
        |> modalBody
        |> Modal.footer
            []
            [ Button.button
                [ Button.outlinePrimary
                , Button.attrs [ onClick <| ModalMsg Modal.hiddenState ]
                ]
                [ text "Close" ]
            ]
        |> Modal.small
        |> Modal.view modalState


modalBody : Modal.Config msg -> Modal.Config msg
modalBody =
    Modal.body []
        [ Grid.containerFluid []
            [ Grid.simpleRow
                [ Grid.col
                    [ Grid.colWidth Grid.colXsSix ]
                    [ text "Col 1" ]
                , Grid.col
                    [ Grid.colWidth Grid.colXsSix ]
                    [ text "Col 2" ]
                ]
            ]
        ]


tabs : Model -> Html Msg
tabs model =
    div []
        [ h1 [] [ text "Tabs" ]
        , Tab.pills
            model.tabState
            { toMsg = TabMsg
            , options = [ Tab.center ]
            , withAnimation = True
            , items =
                [ Tab.item
                    { link = Tab.link [] [ text "Tab1" ]
                    , pane = Tab.pane [] [ listGroup ]
                    }
                , Tab.item
                    { link = Tab.link [] [ text "Tab2" ]
                    , pane = Tab.pane [] [ listGroup2 ]
                    }
                ]
            }
        ]


listGroup : Html Msg
listGroup =
    ListGroup.custom
        [ ListGroup.anchor
            [ ListGroup.success
            , ListGroup.attrs [ href "#" ]
            , ListGroup.attrs [ class "justify-content-between" ]
            ]
            [ text "Hello"
            , Badge.pill [] [ text "1" ]
            ]
        , ListGroup.anchor
            [ ListGroup.info
            , ListGroup.attrs [ href "#" ]
            , ListGroup.attrs [ class "justify-content-between" ]
            ]
            [ text "Aloha"
            , Badge.pillInfo [] [ text "2" ]
            ]
        ]


listGroup2 : Html Msg
listGroup2 =
    ListGroup.custom
        [ ListGroup.anchor
            [ ListGroup.active
            , ListGroup.attrs [ href "#" ]
            , ListGroup.attrs [ class "flex-column align-items-start" ]
            ]
            [ div [ class "d-flex w-100 justify-content-between" ]
                [ h5 [ class "mb-1" ] [ text "List group heading" ]
                , small [] [ text "3 days ago" ]
                ]
            , p [ class "mb-1" ] [ text "Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit." ]
            , small [] [ text "Oh yea that's neat" ]
            ]
        , ListGroup.anchor
            [ ListGroup.attrs [ href "#" ]
            , ListGroup.attrs [ class "flex-column align-items-start" ]
            ]
            [ div [ class "d-flex w-100 justify-content-between" ]
                [ h5 [ class "mb-1" ] [ text "List group heading" ]
                , small [] [ text "3 days ago" ]
                ]
            , p [ class "mb-1" ] [ text "Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit." ]
            , small [] [ text "Oh yea that's neat" ]
            ]
        , ListGroup.anchor
            [ ListGroup.attrs [ href "#" ]
            , ListGroup.attrs [ class "flex-column align-items-start" ]
            ]
            [ div [ class "d-flex w-100 justify-content-between" ]
                [ h5 [ class "mb-1" ] [ text "List group heading" ]
                , small [] [ text "3 days ago" ]
                ]
            , p [ class "mb-1" ] [ text "Donec id elit non mi porta gravida at eget metus. Maecenas sed diam eget risus varius blandit." ]
            , small [] [ text "Oh yea that's neat" ]
            ]
        ]


accordion : Model -> Html Msg
accordion { accordionState } =
    div []
        [ h1 [] [ text "Accordion" ]
        , Accordion.accordion
            accordionState
            { toMsg = AccordionMsg
            , withAnimation = True
            , cards = [ cardOne, cardTwo ]
            }
        ]


cardOne : Accordion.Card Msg
cardOne =
    Accordion.card
        { id = "card1"
        , options = []
        , header =
            Accordion.headerH3 []
                (Accordion.toggle [] [ text " Card With container" ])
                |> Accordion.prependHeader [ span [ class "fa fa-car" ] [] ]
        , blocks =
            [ Accordion.block []
                [ Card.titleH4 [] [ text "Some title" ]
                , Card.text [] [ text "Some content, lorem ipsum etc" ]
                ]
            , Accordion.listGroup
                [ ListGroup.li [] [ text "List item 1" ]
                , ListGroup.li [] [ text "List item 2" ]
                ]
            ]
        }


cardTwo : Accordion.Card Msg
cardTwo =
    Accordion.card
        { id = "card2"
        , options = []
        , header =
            Accordion.header [] <|
                Accordion.toggle [] [ text "Card 2" ]
        , blocks =
            [ Accordion.block []
                [ Card.titleH4 [] [ text "Some other title" ]
                , Card.text [] [ text "Different content, lorem ipsum etc" ]
                ]
            , Accordion.block [ Card.blockAlign Text.alignXsCenter ]
                [ Card.titleH5 [] [ text "Another block title" ]
                , Card.text [] [ text "Even more content, lorem ipsum etc" ]
                ]
            ]
        }


cards : Html Msg
cards =
    div []
        [ h1 [] [ text "Cards" ]
        , Card.deck
            [ Card.config [ Card.outlinePrimary ]
                |> Card.headerH1 [] [ text "Primary" ]
                |> Card.footer [] [ text "Primary footer" ]
                |> Card.block []
                    [ Card.titleH4 [] [ text "Primary outlined" ]
                    , Card.text [] [ text "Outlined primary card. Cool." ]
                    ]
            , Card.config [ Card.outlineSuccess ]
                |> Card.headerH1 [] [ text "Success" ]
                |> Card.footer [] [ text "Success footer" ]
                |> Card.block
                    [ Card.blockAlign Text.alignXsLeft ]
                    [ Card.titleH4 [] [ text "Success outlined" ]
                    , Card.text [] [ text "The success of outlining cards is staggering" ]
                    , Card.link [ href "#" ] [ text "Link 1" ]
                    , Card.link [ href "#" ] [ text "Link 2" ]
                    ]
            ]
        , Card.group
            [ Card.config [ Card.danger, Card.align Text.alignXsCenter ]
                |> Card.block []
                    [ Card.titleH4 [] [ text "Danger inverse " ]
                    , Card.text [] [ text " A Simple card with a dangerous role" ]
                    , Card.link [ href "#" ] [ text "A Link !" ]
                    ]
            , Card.config [ Card.warning, Card.align Text.alignXsLeft ]
                |> Card.block []
                    [ Card.titleH4 [] [ text "Warning inverse " ]
                    , Card.text [] [ text " A Simple card with a warning role" ]
                    ]
            , Card.config [ Card.info, Card.align Text.alignXsRight ]
                |> Card.block []
                    [ Card.titleH4 [] [ text "Info inverse " ]
                    , Card.text [] [ text " A Simple card with a info role" ]
                    ]
            ]
        , Card.config [ Card.outlineDanger ]
            |> Card.block []
                [ Card.text [] [ text "Just some text you know" ] ]
            |> Card.view
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


progressBars : Html msg
progressBars =
    div []
        [ h1 [] [ text "Progress bars" ]
        , Progress.progress [ Progress.label "Won't show..." ]
        , Progress.progress [ Progress.value 50 ]
        , Progress.progress [ Progress.value 30, Progress.striped ]
        , Progress.progress [ Progress.value 20, Progress.success, Progress.height 10 ]
        , Progress.progressMulti
            [ [ Progress.height 25, Progress.value 30 ]
            , [ Progress.value 100, Progress.info, Progress.striped ]
            , [ Progress.value 100, Progress.label "Silly" ]
            , [ Progress.value 100, Progress.danger, Progress.animated ]
            ]
        , Progress.progress
            [ Progress.value 50
            , Progress.customLabel
                [ span [ class "fa fa-car" ] [] ]
            ]
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
