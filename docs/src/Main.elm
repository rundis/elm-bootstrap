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


type alias Model =
    { route : Route.Route
    , navbarState : Navbar.State
    , tableState : Table.State
    , progressState : Progress.State
    , gridState : Grid.State
    }


type Msg
    = UrlChange Location
    | NavbarMsg Navbar.State
    | TableMsg Table.State
    | ProgressMsg Progress.State
    | GridMsg Grid.State


type Page
    = Grid




init : Navigation.Location -> ( Model, Cmd Msg )
init location =
    let
        ( navbarState, navbarCmd ) =
            Navbar.initialState NavbarMsg
        ( model, urlCmd) =
            urlUpdate location { route = Route.Home
                               , navbarState = navbarState
                               , tableState = Table.initialState
                               , progressState = Progress.initialState
                               , gridState = Grid.initialState
                               }
    in
        ( model, Cmd.batch [navbarCmd, urlCmd] )


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
        [ Navbar.subscriptions model.navbarState NavbarMsg ]


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
        ( viewMenu model :: viewPage model)


viewMenu : Model -> Html Msg
viewMenu model =
    Navbar.navbar
        model.navbarState
        { toMsg = NavbarMsg
        , withAnimation = True
        , options =
            [ Navbar.container
            , Navbar.attr <| class "bd-navbar navbar-light"
            ]
        , brand = Just <| Navbar.brand [ href "#" ] [ text "Elm Bootstrap" ]
        , items =
            [ Navbar.itemLink [ href "#grid" ] [ text "Grid" ]
            , Navbar.itemLink [ href "#table" ] [ text "Table" ]
            , Navbar.itemLink [ href "#progress" ] [ text "Progress" ]
            , Navbar.itemLink [ href "#alert" ] [ text "Alert" ]
            ]
        , customItems = []
        }


viewPage : Model -> List (Html Msg)
viewPage model =
{-     let
        pageView pageFn =
            div [ class "row" ]
                [ div [ class "col bd-content" ] pageFn ]
    in -}
        case model.route of
            Route.Home ->
                PHome.view

            Route.Grid ->
                Grid.view model.gridState GridMsg

            Route.Table ->
                Table.view model.tableState TableMsg

            Route.Progress ->
                Progress.view model.progressState ProgressMsg

            Route.Alert ->
                Alert.view

            Route.NotFound ->
                viewNotFound model



viewNotFound : Model -> List (Html Msg)
viewNotFound model =
    [ h1 [] [ text "NOT FOUND" ] ]
