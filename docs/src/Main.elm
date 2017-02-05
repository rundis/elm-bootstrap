module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Color
import Navigation exposing (Location)
import Route
import Bootstrap.Grid as Grid
import Bootstrap.Navbar as Navbar
import Page.Table as PTable


type alias Model =
    { route : Route.Route
    , navbarState : Navbar.State
    , pTableState : PTable.State
    }


type Msg
    = UrlChange Location
    | NavbarMsg Navbar.State
    | PTableMsg PTable.State


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
                               , pTableState = PTable.initialState
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

        PTableMsg state ->
            ( { model | pTableState = state }, Cmd.none )


urlUpdate : Navigation.Location -> Model -> ( Model, Cmd Msg )
urlUpdate location model =
    case Route.decode location of
        Nothing ->
            ( { model | route = Route.NotFound }, Cmd.none )

        Just route ->
            ( { model | route = route }, Cmd.none )


view : Model -> Html Msg
view model =
    Grid.container
        [ style [ ( "margin-top", "70px" ) ] ]
        [ viewMenu model
        , viewPage model
        ]


viewMenu : Model -> Html Msg
viewMenu model =
    Navbar.navbar
        model.navbarState
        { toMsg = NavbarMsg
        , withAnimation = True
        , options = [ Navbar.container, Navbar.fixTop, Navbar.container, Navbar.darkCustom Color.brown ]
        , brand = Just <| Navbar.brand [ href "#" ] [ text "Elm Bootstrap" ]
        , items =
            [ Navbar.itemLink [ href "#grid" ] [ text "Grid" ]
            , Navbar.itemLink [ href "#table" ] [ text "Table" ]
            ]
        , customItems = []
        }


viewPage : Model -> Html Msg
viewPage model =
    let
        pageView pageFn =
            div [ class "row" ]
                [ div [ class "col" ] pageFn ]
    in
        case model.route of
            Route.Home ->
                pageView <| viewHome model

            Route.Grid ->
                pageView <| viewGrid model

            Route.Table ->
                pageView <| PTable.view model.pTableState PTableMsg

            Route.NotFound ->
                pageView <| viewNotFound model


viewHome : Model -> List (Html Msg)
viewHome model =
    [ h1 [] [ text "Home" ] ]


viewGrid : Model -> List (Html Msg)
viewGrid model =
    [ h1 [] [ text "Grid" ] ]



viewNotFound : Model -> List (Html Msg)
viewNotFound model =
    [ h1 [] [ text "NOT FOUND" ] ]
