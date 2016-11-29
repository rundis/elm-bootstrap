module Main exposing (..)

import Bootstrap.CDN as CDN
import Bootstrap.Grid as Grid
import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Modal as Modal
import Bootstrap.Navbar as Navbar
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


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
    }


init : ( Model, Cmd Msg )
init =
    ( { dummy = "init"
      , dropdownState = Dropdown.initialState "drop"
      , splitDropState = Dropdown.initialState "split"
      , modalState = Modal.hiddenState
      }
    , Cmd.none
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


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
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

        ModalMsg state ->
            ( { model | modalState = state }
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
        ]


view : Model -> Html Msg
view model =
    div []
        [ CDN.stylesheetFlex
        , Grid.container
            [ navbar
            , mainContent model
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
                [ text "Col 1 Row 1" ]
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
                    (Dropdown.config
                        { toMsg = DropdownMsg
                        , buttonStyles =
                            [ Button.role Button.Warning ]
                        , buttonChildren =
                            [ span
                                []
                                [ text "MyDropdown "
                                , span [ class "tag tag-pill tag-info" ] [ text "(2)" ]
                                ]
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
                    (Dropdown.splitConfig
                        { toMsg = SplitMsg
                        , buttonStyles =
                            [ Button.role Button.Warning ]
                        , buttonAttributes =
                            [ onClick SplitMainMsg ]
                        , buttonChildren =
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


navbar : Html Msg
navbar =
    Navbar.navbar
        [ Navbar.scheme Navbar.Dark Navbar.Primary
          --, Navbar.fix Navbar.FixTop
        ]
        []
        (Navbar.nav
            [ Navbar.navItemLink
                [href ""]
                [ text "Hello" ]
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
