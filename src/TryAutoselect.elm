module TryAutoselect2 exposing (main)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.CDN
import Bootstrap.Grid as Grid
import Bootstrap.Form.Autoselect as Autoselect


type alias Model =
    { query : String
    , autoState : Autoselect.State
    , selectedArtists : List Artist
    }


type alias Artist =
    { id : Int
    , name : String
    }


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


type Msg
    = SetQuery String
    | Select String
    | RemoveSelected String
    | RemoveAllSelected
    | AutoMsg Autoselect.Msg


init : ( Model, Cmd Msg )
init =
    ( Model "" Autoselect.initialState <|
        List.filter (\{ id } -> id == 1 || id == 5) artists
    , Cmd.none
    )


subscriptions model =
    Autoselect.subscriptions model.autoState AutoMsg


autoUpdateConfig =
    Autoselect.updateConfig
        { toMsg = AutoMsg
        , onInput = \q -> SetQuery q
        , onSelect = \id -> Select id
        , onRemoveSelected = \id -> RemoveSelected id
        , onRemoveAllSelected = RemoveAllSelected
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case (Debug.log "Msg: " msg) of
        AutoMsg subMsg ->
            let
                ( autoState, selfMsg, autoCmd ) =
                    Autoselect.update subMsg model.autoState autoUpdateConfig

                newModel =
                    { model | autoState = autoState }
            in
                case selfMsg of
                    Just updateMsg ->
                        let
                            ( updModel, updCmd ) =
                                update updateMsg newModel
                        in
                            ( updModel, Cmd.batch [ updCmd, autoCmd ] )

                    Nothing ->
                        ( newModel, autoCmd )

        SetQuery query ->
            ( { model | query = query }, Cmd.none )

        RemoveSelected id ->
            ( { model | selectedArtists = List.filter (\a -> toString a.id /= id) model.selectedArtists }
            , Cmd.none
            )

        RemoveAllSelected ->
            ( { model | selectedArtists = [] }, Cmd.none )

        Select id ->
            ( { model
                | query = ""
                , selectedArtists =
                    model.selectedArtists ++ (List.filter (\a -> toString a.id == id) artists)
              }
            , Cmd.none
            )




view : Model -> Html Msg
view model =
    Grid.container []
        [ Bootstrap.CDN.stylesheet
        , h1 [] [ text "Artist autocomplete" ]
        , div [ style [("width", "300px")]]
            [ Autoselect.viewConfig
                { toMsg = AutoMsg
                , inputId = "artist-query"
                , idFn = (\artist -> toString artist.id)
                , itemFn = (\artist -> { attributes = [], children = [ Html.text artist.name ] })
                , selectedFn = (\artist -> { attributes = [], children = [ Html.text artist.name ] })
                }
                |> Autoselect.view
                    model.autoState
                    { query = model.query
                    , selectedItems = model.selectedArtists
                    , availableItems = filterArtists model
                    }
            ]
        , p [] [ text "Some other content"]
        ]


artists =
    [ Artist 1 "Machinehead"
    , Artist 2 "Metallica"
    , Artist 3 "Megadeth"
    , Artist 4 "Sepultura"
    , Artist 5 "ZZ Top"
    , Artist 6 "Lamb of God"
    , Artist 7 "Pantera"
    , Artist 8 "Crowbar"
    , Artist 9 "Katatonia"
    , Artist 10 "Opeth"
    , Artist 11 "Slayer"
    , Artist 12 "Soundgarden"
    , Artist 13 "Nirvana"
    , Artist 14 "Anathema"
    , Artist 15 "Rush"
    ]


filterArtists : Model -> List Artist
filterArtists { query, selectedArtists } =
    List.filter (\a -> not <| List.member a.id (List.map .id selectedArtists)) artists
        |> List.filter (\a -> String.contains (String.toLower query) (String.toLower a.name))
        |> List.sortBy .name
