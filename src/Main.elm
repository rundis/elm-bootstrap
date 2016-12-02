module Main exposing (..)

import Bootstrap.Button as Button
import Bootstrap.CDN as CDN
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Grid as Grid
import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar
import Bootstrap.Tab as Tab
import Bootstrap.Accordion as Accordion
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
      , dropdownState = Dropdown.initialState "drop"
      , splitDropState = Dropdown.initialState "split"
      , navDropState = Dropdown.initialState "navDrop"
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
    --    Sub.none
    Sub.batch
        [ Dropdown.subscriptions
            model.dropdownState
            DropdownMsg
        , Dropdown.subscriptions
            model.splitDropState
            SplitMsg
        , Dropdown.subscriptions
            model.navDropState
            NavDropMsg
        ]


view : Model -> Html Msg
view model =
    div []
        [ CDN.stylesheetFlex
        , CDN.fontAwesome
        , Grid.container
            [ navbar model
            , mainContent model
            , tabs model
            , accordion model
            ]
        ]


mainContent : Model -> Html Msg
mainContent model =
    Grid.container
        [ Grid.flexRow
            [ Grid.flexVAlign Grid.ExtraSmall Grid.Bottom ]
            [ flexRowStyle ]
            [ Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.Two ]
                [ flexColStyle ]
                [ span [ class "fa fa-car" ] []
                , text " Col 1 Row 1"
                ]
            , Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.None
                , Grid.flexVAlign Grid.ExtraSmall Grid.Top
                ]
                [ flexColStyle ]
                [ text "Col 2 Row 1" ]
            , Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.Five
                , Grid.flexVAlign Grid.ExtraSmall Grid.Middle
                ]
                [ flexColStyle ]
                [ text "Col 3 Row 1" ]
            , Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.None ]
                [ flexColStyle ]
                [ text "Col 4 Row 1" ]
            ]
        , Grid.flexRow
            [ Grid.flexVAlign Grid.ExtraSmall Grid.Middle ]
            [ flexRowStyle ]
            [ Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.Five ]
                [ flexColStyle ]
                [ Button.linkButton
                    [ Button.size Button.Small
                    , Button.outline Button.Success
                    , Button.block
                    ]
                    [ onClick <| ModalMsg Modal.visibleState ]
                    [ text "Show modal" ]
                ]
            ]
        , Grid.flexRow
            [ Grid.flexVAlign Grid.ExtraSmall Grid.Top ]
            [ flexRowStyle ]
            [ Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.Five ]
                [ flexColStyle ]
                [ Dropdown.dropdown
                    (Dropdown.dropdownConfig
                        { toggleMsg = DropdownMsg
                        , toggleButton =
                            Dropdown.dropdownToggle
                                [ Button.role Button.Warning ]
                                []
                                [ text "MyDropdown "
                                , span [ class "tag tag-pill tag-info" ] [ text "(2)" ]
                                ]
                        , items =
                            [ Dropdown.dropdownItem
                                [ href "#", onClick Item1Msg ]
                                [ text "Item 1" ]
                            , Dropdown.dropdownItem
                                [ href "#", onClick Item2Msg ]
                                [ text "Item 2" ]
                            ]
                        }
                    )
                    model.dropdownState
                ]
            , Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.Five ]
                [ flexColStyle ]
                [ Dropdown.splitDropdown
                    (Dropdown.splitDropdownConfig
                        { toggleMsg = SplitMsg
                        , toggleButton =
                            Dropdown.splitDropdownToggle
                                [ Button.role Button.Warning ]
                                [ onClick SplitMainMsg ]
                                [ text "My split drop" ]
                        , items =
                            [ Dropdown.dropdownItem
                                [ href "#", onClick SplitItem1Msg ]
                                [ text "SplitItem 1" ]
                            , Dropdown.dropdownItem
                                [ href "#", onClick SplitItem2Msg ]
                                [ text "SplitItem 2" ]
                            ]
                        }
                    )
                    model.splitDropState
                ]
            , Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.None ]
                [ flexColStyle ]
                [ text model.dummy ]
            ]
        , modal model.modalState
        ]


navbar : Model -> Html Msg
navbar model =
    Navbar.navbar
        [ Navbar.scheme Navbar.Dark Navbar.Primary
          --, Navbar.fix Navbar.FixTop
        ]
        []
        (Navbar.nav
            [ Navbar.navBrand
                [ href "#" ]
                [ text "Logo" ]
            , Navbar.navItemLink
                [ href "#" ]
                [ text "Page" ]
            , Navbar.navItemLink
                [ href "#" ]
                [ text "Another" ]
            , Navbar.navCustomItem <|
                Dropdown.navDropdown
                    (Dropdown.navDropdownConfig
                        { toggleMsg = NavDropMsg
                        , toggleButton =
                            Dropdown.navDropdownToggle
                                []
                                [ text "NavDrop" ]
                        , items =
                            [ Dropdown.dropdownItem
                                [ href "#" ]
                                [ text "Menuitem 1" ]
                            , Dropdown.dropdownItem
                                [ href "#" ]
                                [ text "Menuitem 2" ]
                            ]
                        }
                    )
                    model.navDropState
            , Navbar.navCustomItem <|
                span
                    [ class "navbar-text float-xs-right text-success" ]
                    [ text "Some text" ]
            ]
        )


modal : Modal.State -> Html Msg
modal modalState =
    div
        []
        [ Modal.modal
            (Modal.config
                { closeMsg = ModalMsg
                , header = Just <| h4 [ class "modal-title" ] [ text "Modal header" ]
                , body = Just <| modalBody
                , footer =
                    Just <|
                        div []
                            [ Button.button
                                [ Button.outline Button.Primary ]
                                [ onClick <| ModalMsg Modal.hiddenState ]
                                [ text "Close" ]
                            ]
                , size = Just <| Modal.Small
                }
            )
            modalState
        ]


modalBody : Html Msg
modalBody =
    Grid.containerFluid
        [ Grid.row
            [ Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.Six ]
                []
                [ text "Col 1" ]
            , Grid.flexCol
                [ Grid.flexColSize Grid.ExtraSmall Grid.Six ]
                []
                [ text "Col 2" ]
            ]
        ]


tabs : Model -> Html Msg
tabs model =
    Tab.tab
        (Tab.config
            { toMsg = TabMsg
            , items =
                [ Tab.tabItem
                    { link = Tab.tabLink [] [ text "Tab1" ]
                    , pane = Tab.tabPane [] [ text "Tab Pane 1 Content" ]
                    }
                , Tab.tabItem
                    { link = Tab.tabLink [] [ text "Tab2" ]
                    , pane = Tab.tabPane [] [ text "Tab Pane 2 Content" ]
                    }
                ]
            }
        )
        model.tabState


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
        { toMsg = AccordionMsg "card1"
        , state = state
        , toggle = Accordion.cardToggle [] [ text " Card 1" ]
        , toggleContainer =
            Just <|
                Accordion.toggleContainer h3
                    []
                    [ span [ class "fa fa-car" ] [] ]
                    []
        , block = Accordion.cardBlock [ text "Contants of Card 1" ]
        }


renderCardTwo : Accordion.CardState -> Accordion.Card Msg
renderCardTwo state =
    Accordion.card
        { toMsg = AccordionMsg "card2"
        , state = state
        , toggle = Accordion.cardToggle [] [ text "Card 2" ]
        , toggleContainer = Nothing
        , block = Accordion.cardBlock [ text "Contants of Card 2" ]
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
