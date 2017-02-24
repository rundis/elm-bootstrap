module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Navigation exposing (Location)
import Route
import Bootstrap.Navbar as Navbar
import Page.Home as PHome
import Page.Table as Table
import Page.Progress as Progress
import Page.Grid as Grid
import Page.Alert as Alert
import Page.Badge as Badge
import Page.ListGroup as ListGroup
import Page.Tab as Tab
import Page.Card as Card
import Page.Button as Button
import Page.Dropdown as Dropdown
import Page.Accordion as Accordion
import Page.Modal as Modal
import Page.Navbar as PageNav
import Page.Form as Form


type alias Model =
    { route : Route.Route
    , navbarState : Navbar.State
    , tableState : Table.State
    , progressState : Progress.State
    , gridState : Grid.State
    , tabState : Tab.State
    , dropdownState : Dropdown.State
    , accordionState : Accordion.State
    , modalState : Modal.State
    , pageNavState : PageNav.State
    }


type Msg
    = UrlChange Location
    | NavbarMsg Navbar.State
    | TableMsg Table.State
    | ProgressMsg Progress.State
    | GridMsg Grid.State
    | TabMsg Tab.State
    | DropdownMsg Dropdown.State
    | AccordionMsg Accordion.State
    | ModalMsg Modal.State
    | PageNavMsg PageNav.State


init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg

        ( pageNavState, pageNavCmd) =
            PageNav.initialState PageNavMsg

        ( model, urlCmd ) =
            urlUpdate location
                { route = Route.Home
                , navbarState = navbarState
                , tableState = Table.initialState
                , progressState = Progress.initialState
                , gridState = Grid.initialState
                , tabState = Tab.initialState
                , dropdownState = Dropdown.initialState
                , accordionState = Accordion.initialState
                , modalState = Modal.initialState
                , pageNavState = pageNavState
                }
    in
        ( model, Cmd.batch [ navbarCmd, urlCmd, pageNavCmd ] )


main : Program Never Model Msg
main =
    Navigation.program UrlChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Navbar.subscriptions model.navbarState NavbarMsg
        , Tab.subscriptions model.tabState TabMsg
        , Dropdown.subscriptions model.dropdownState DropdownMsg
        , Accordion.subscriptions model.accordionState AccordionMsg
        , PageNav.subscriptions model.pageNavState PageNavMsg
        ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        UrlChange location ->
            urlUpdate location model

        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )

        TableMsg state ->
            ( { model | tableState = state }, Cmd.none )

        ProgressMsg state ->
            ( { model | progressState = state }, Cmd.none )

        GridMsg state ->
            ( { model | gridState = state }, Cmd.none )

        TabMsg state ->
            ( { model | tabState = state }, Cmd.none )

        DropdownMsg state ->
            ( { model | dropdownState = state }, Cmd.none )

        AccordionMsg state ->
            ( { model | accordionState = state }, Cmd.none )

        ModalMsg state ->
            ( { model | modalState = state }, Cmd.none )

        PageNavMsg state ->
            ( { model | pageNavState = state}, Cmd.none )


urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case Route.decode location of
        Nothing ->
            ( { model | route = Route.NotFound }, Cmd.none )

        Just route ->
            ( { model | route = route }, Cmd.none )


view : Model -> Html Msg
view model =
    div
        []
        (viewMenu model :: viewPage model)


viewMenu : Model -> Html Msg
viewMenu model =
    Navbar.config NavbarMsg
        |> Navbar.container
        |> Navbar.collapseLarge
        |> Navbar.withAnimation
        |> Navbar.lightCustomClass "bd-navbar"
        |> Navbar.brand [ href "#" ] [ text "Elm Bootstrap" ]
        |> Navbar.items
            [ Navbar.itemLink [ href "#grid" ] [ text "Grid" ]
            , Navbar.itemLink [ href "#form"] [ text "Form" ]
            , Navbar.itemLink [ href "#card" ] [ text "Card" ]
            , Navbar.itemLink [ href "#table" ] [ text "Table" ]
            , Navbar.itemLink [ href "#button" ] [ text "Button" ]
            , Navbar.itemLink [ href "#dropdown" ] [ text "Dropdown" ]
            , Navbar.itemLink [ href "#progress" ] [ text "Progress" ]
            , Navbar.itemLink [ href "#alert" ] [ text "Alert" ]
            , Navbar.itemLink [ href "#badge" ] [ text "Badge" ]
            , Navbar.itemLink [ href "#listgroup" ] [ text "ListGroup" ]
            , Navbar.itemLink [ href "#tab" ] [ text "Tab" ]
            , Navbar.itemLink [ href "#accordion" ] [ text "Accordion" ]
            , Navbar.itemLink [ href "#modal" ] [ text "Modal" ]
            , Navbar.itemLink [ href "#navbar"] [ text "Navbar" ]
            ]
        |> Navbar.view model.navbarState


viewPage : Model -> List (Html Msg)
viewPage model =
    case model.route of
        Route.Home ->
            PHome.view

        Route.Grid ->
            Grid.view model.gridState GridMsg

        Route.Card ->
            Card.view

        Route.Table ->
            Table.view model.tableState TableMsg

        Route.Progress ->
            Progress.view model.progressState ProgressMsg

        Route.Alert ->
            Alert.view

        Route.Badge ->
            Badge.view

        Route.ListGroup ->
            ListGroup.view

        Route.Tab ->
            Tab.view model.tabState TabMsg

        Route.Button ->
            Button.view

        Route.Dropdown ->
            Dropdown.view model.dropdownState DropdownMsg

        Route.Accordion ->
            Accordion.view model.accordionState AccordionMsg

        Route.Modal ->
            Modal.view model.modalState ModalMsg

        Route.Navbar ->
            PageNav.view model.pageNavState PageNavMsg

        Route.Form ->
            Form.view

        Route.NotFound ->
            viewNotFound model


viewNotFound : Model -> List (Html Msg)
viewNotFound model =
    [ h1 [] [ text "NOT FOUND" ] ]
