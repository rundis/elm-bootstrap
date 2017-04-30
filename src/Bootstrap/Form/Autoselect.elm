module Bootstrap.Form.Autoselect
    exposing
        ( view
        , viewConfig
        , initialState
        , update
        , updateConfig
        , subscriptions
        , State
        , ViewConfig
        , UpdateConfig
        , MenuItem
        , SelectedItem
        , Msg
        )

import Html
import Html.Attributes exposing (style, value, class, classList, href)
import Html.Events as Events
import Html.Keyed as Keyed
import Text exposing (defaultStyle)
import Element
import Json.Decode as Json
import Dom
import Dom.Scroll as Scroll
import DOM
import Task
import Mouse


type State
    = State StateRec


type alias StateRec =
    { containerRect : Maybe DOM.Rectangle
    , showMenu : Bool
    , activeIdx : Int
    , numItems : Maybe Int
    }


type alias MenuItem msg =
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type alias SelectedItem msg =
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type ViewConfig data msg
    = ViewConfig (ViewConfigRec data msg)


type alias ViewConfigRec data msg =
    { toMsg : Msg -> msg
    , inputId : InputId
    , idFn : data -> String
    , itemFn : data -> MenuItem Never
    , selectedFn : data -> SelectedItem Never
    }


type UpdateConfig msg
    = UpdateConfig (UpdateConfigRec msg)


type alias UpdateConfigRec msg =
    { toMsg : Msg -> msg
    , onInput : String -> msg
    , onSelect : String -> msg
    , onRemoveSelected : String -> msg
    , onRemoveAllSelected : msg
    }


type InputId
    = InputId String


type MenuId
    = MenuId String


type alias ViewData data =
    { query : String
    , availableItems : List data
    , selectedItems : List data
    }


type alias ScrollInfo =
    { keyCode : Int
    , menuHeight : Float
    , nextItem : Maybe ItemInfo
    , previousItem : Maybe ItemInfo
    }


type alias ItemInfo =
    { offsetHeight : Float
    , offsetTop : Float
    }


type Msg
    = OnInput String
    | RequestFocus Int InputId
    | RemoveAllSelected InputId
    | RemoveSelected String InputId
    | FocusReset DOM.Rectangle
    | MoveDown Float Int MenuId
    | MoveUp Float Int MenuId
    | SetActiveItem Int
    | SelectItem String InputId
    | CloseMenu
    | MouseClick Mouse.Position
    | NoOp



-- SUBSCRIPTIONS


subscriptions : State -> (Msg -> msg) -> Sub msg
subscriptions (State { showMenu }) toMsg =
    if showMenu then
        Mouse.clicks (\p -> toMsg <| MouseClick p)
    else
        Sub.none



-- UPDATE


updateConfig :
    { toMsg : Msg -> msg
    , onInput : String -> msg
    , onSelect : String -> msg
    , onRemoveSelected : String -> msg
    , onRemoveAllSelected : msg
    }
    -> UpdateConfig msg
updateConfig config =
    UpdateConfig
        { toMsg = config.toMsg
        , onInput = config.onInput
        , onSelect = config.onSelect
        , onRemoveSelected = config.onRemoveSelected
        , onRemoveAllSelected = config.onRemoveAllSelected
        }


update : Msg -> State -> UpdateConfig msg -> ( State, Maybe msg, Cmd msg )
update msg (State state) (UpdateConfig config) =
    (case msg of
        NoOp ->
            ( state, Nothing, Cmd.none )

        OnInput query ->
            ( { state | activeIdx = 0, showMenu = True }
            , Just <| config.onInput query
            , Cmd.none
            )

        RequestFocus numItems inputId ->
            ( { state | activeIdx = 0, numItems = Just numItems }
            , Nothing
            , requestFocus inputId
            )

        RemoveAllSelected inputId ->
            ( state
            , Just config.onRemoveAllSelected
            , Cmd.batch
                [ requestScrollUp 0 (toMenuId inputId)
                , requestFocus inputId
                ]
            )

        RemoveSelected itemId inputId ->
            ( state
            , Just <| config.onRemoveSelected itemId
            , Cmd.batch
                [ requestScrollUp 0 (toMenuId inputId)
                , requestFocus inputId
                ]
            )

        FocusReset rect ->
            ( { state
                | containerRect = Just rect
                , showMenu = True
                , activeIdx = 0
              }
            , Nothing
            , Cmd.none
            )

        MoveDown scrollBy activeIdx menuId ->
            ( { state | activeIdx = activeIdx }
            , Nothing
            , requestScrollDown scrollBy menuId
            )

        MoveUp scrollBy activeIdx menuId ->
            ( { state | activeIdx = activeIdx }
            , Nothing
            , requestScrollUp scrollBy menuId
            )

        SetActiveItem idx ->
            ( { state | activeIdx = idx }
            , Nothing
            , Cmd.none
            )

        SelectItem itemId inputId ->
            ( state
            , Just <| config.onSelect itemId
            , Cmd.batch
                [ requestScrollUp 0 (toMenuId inputId)
                , requestFocus inputId
                ]
            )

        CloseMenu ->
            ( { state | showMenu = False, activeIdx = 0 }
            , Nothing
            , Cmd.none
            )

        MouseClick { x, y } ->
            case state.containerRect of
                Just rect ->
                    if toFloat x < rect.left || toFloat x > (rect.left + rect.width) || toFloat y < rect.top || toFloat y > rect.top + rect.height then
                        ( { state | showMenu = False }, Nothing, Cmd.none )
                    else
                        ( state, Nothing, Cmd.none )

                Nothing ->
                    ( state, Nothing, Cmd.none )
    )
        |> (\( newState, returnMsg, cmd ) ->
                ( State newState, returnMsg, Cmd.map config.toMsg cmd )
           )


requestFocus : InputId -> Cmd Msg
requestFocus (InputId id) =
    Task.attempt (\_ -> NoOp) (Dom.focus id)


requestScrollDown : Float -> MenuId -> Cmd Msg
requestScrollDown scrollBy (MenuId id) =
    Scroll.y id
        |> Task.andThen
            (\res ->
                if scrollBy > res then
                    Scroll.toY id scrollBy
                else
                    Task.succeed ()
            )
        |> Task.attempt (\_ -> NoOp)


requestScrollUp : Float -> MenuId -> Cmd Msg
requestScrollUp scrollBy (MenuId id) =
    Scroll.y id
        |> Task.andThen
            (\res ->
                if res > 0 && res > scrollBy then
                    Scroll.toY id scrollBy
                else
                    Task.succeed ()
            )
        |> Task.attempt (\_ -> NoOp)


initialState : State
initialState =
    State
        { showMenu = False
        , activeIdx = 0
        , containerRect = Nothing
        , numItems = Nothing
        }


viewConfig :
    { toMsg : Msg -> msg
    , inputId : String
    , idFn : data -> String
    , itemFn : data -> MenuItem Never
    , selectedFn : data -> SelectedItem Never
    }
    -> ViewConfig data msg
viewConfig config =
    ViewConfig
        { toMsg = config.toMsg
        , inputId = InputId config.inputId
        , idFn = config.idFn
        , itemFn = config.itemFn
        , selectedFn = config.selectedFn
        }


view : State -> ViewData data -> ViewConfig data msg -> Html.Html msg
view ((State { showMenu }) as state) viewData (ViewConfig config) =
    Html.div
        [ wrapperStyles ]
        ([ Html.div
            [ style containerStyles
            , Events.onClick <| RequestFocus (List.length viewData.availableItems) config.inputId
            ]
            ([ searchView state viewData config ]
                ++ (if List.length viewData.selectedItems > 0 then
                        [ clearView state viewData config ]
                    else
                        []
                   )
                ++ [ toggleView ]
            )
         ]
            ++ if showMenu then
                [ menuView state viewData config ]
               else
                []
        )
        |> Html.map config.toMsg


searchView : State -> ViewData data -> ViewConfigRec data msg -> Html.Html Msg
searchView state viewData config =
    Html.div
        [ style searchStyles ]
        (selectedValues viewData config
            ++ [ searchInput state viewData config ]
        )


clearView : State -> ViewData data -> ViewConfigRec data msg -> Html.Html Msg
clearView state viewData config =
    Html.div
        [ style clearStyles
        , Events.onClick <| RemoveAllSelected config.inputId
        ]
        [ Html.button
            [ class "btn btn-sm btn-secondary"
            , style [ ( "border", "none" ) ]
            ]
            [ Html.text "×" ]
        ]


searchInput : State -> ViewData data -> ViewConfigRec data msg -> Html.Html Msg
searchInput ((State { containerRect }) as state) ({ query } as viewData) config =
    let
        shadowItem =
            Text.fromString query
                |> Text.height 16
                |> Text.typeface [ "system-ui" ]
                |> Element.leftAligned

        inputWidth =
            Element.widthOf shadowItem + 2

        maxWidth =
            Maybe.map (\rect -> rect.width - 6) containerRect
                |> Maybe.withDefault (toFloat inputWidth)

        (InputId inputId) =
            config.inputId
    in
        Html.input
            [ style
                ([ ( "width", toPx inputWidth )
                 , ( "max-width", toPx maxWidth )
                 ]
                    ++ inputStyles
                )
            , Html.Attributes.id inputId
            , value query
            , Events.onInput OnInput
            , onFocus
            , onKeyDown state viewData config
            ]
            []


onFocus : Html.Attribute Msg
onFocus =
    Events.on "focus"
        (containerDecoder
            |> Json.andThen (FocusReset >> Json.succeed)
        )


containerDecoder : Json.Decoder DOM.Rectangle
containerDecoder =
    Json.at
        [ "target"
        , "parentElement"
        , "parentElement"
        , "parentElement"
        ]
        DOM.boundingClientRect


selectedValues : ViewData data -> ViewConfigRec data msg -> List (Html.Html Msg)
selectedValues { selectedItems } ({ inputId, idFn, selectedFn } as config) =
    (List.map (selectValue inputId idFn selectedFn) selectedItems)


selectValue :
    InputId
    -> (data -> String)
    -> (data -> SelectedItem Never)
    -> data
    -> Html.Html Msg
selectValue inputId idFn selectedFn item =
    let
        { attributes, children } =
            selectedFn item

        id =
            idFn item
    in
        Html.div [ style valueWrapperStyles ]
            [ Html.div
                ([ style valueStyles ] ++ (List.map mapNeverToMsg attributes))
                [ Html.button
                    [ class "btn btn-sm btn-outline-info"
                    , style [ ( "border", "0px" ), ( "margin-top", "-4px" ) ]
                    , Events.onClick (RemoveSelected id inputId)
                    ]
                    [ Html.text "×" ]
                , Html.span
                    [ style
                        [ ( "padding", "2px 4px 2px 2px" )
                        , ( "font-family", "sans-serif" )
                        ]
                    ]
                    (List.map (Html.map (\html -> NoOp)) children)
                ]
            ]


onKeyDown : State -> ViewData data -> ViewConfigRec data msg -> Html.Attribute Msg
onKeyDown ((State stateRec) as state) viewData ({ idFn } as config) =
    let
        menuId =
            toMenuId config.inputId

        handleMenuOpen info =
            case info.keyCode of
                13 ->
                    onEnter state viewData config

                40 ->
                    onArrowDown state viewData menuId info

                38 ->
                    onArrowUp state viewData menuId info

                27 ->
                    Json.succeed CloseMenu

                8 ->
                    onBackspace viewData config

                _ ->
                    Json.fail "passthrough"

        handleMenuClosed keyCode =
            if keyCode == 8 then
                onBackspace viewData config
            else
                Json.fail "passthrough"
    in
        if stateRec.showMenu then
            Events.on "keydown"
                (keyDownDecoder stateRec.activeIdx
                    |> Json.andThen handleMenuOpen
                )
        else
            Events.on "keydown"
                (Json.field "keyCode" Json.int
                    |> Json.andThen handleMenuClosed
                )


onEnter : State -> ViewData data -> ViewConfigRec data msg -> Json.Decoder Msg
onEnter state viewData ({ idFn } as config) =
    case getActiveItem state viewData config of
        Just item ->
            Json.succeed <| SelectItem (idFn item) config.inputId

        Nothing ->
            Json.fail "No selection"


onArrowDown :
    State
    -> ViewData data
    -> MenuId
    -> ScrollInfo
    -> Json.Decoder Msg
onArrowDown state viewData menuId info =
    case info.nextItem of
        Just { offsetHeight, offsetTop } ->
            if offsetHeight + offsetTop > info.menuHeight then
                Json.succeed <|
                    (MoveDown
                        (offsetHeight + offsetTop - info.menuHeight)
                        (getNextIndex state viewData)
                        menuId
                    )
            else
                Json.succeed <|
                    (SetActiveItem (getNextIndex state viewData))

        Nothing ->
            Json.succeed <|
                (MoveUp 0 (getNextIndex state viewData) menuId)


onArrowUp :
    State
    -> ViewData data
    -> MenuId
    -> ScrollInfo
    -> Json.Decoder Msg
onArrowUp state viewData menuId info =
    case info.previousItem of
        Just { offsetHeight, offsetTop } ->
            Json.succeed <|
                (MoveUp offsetTop (getPreviousIndex state viewData) menuId)

        _ ->
            Json.succeed <|
                (MoveDown info.menuHeight (getPreviousIndex state viewData) menuId)


onBackspace : ViewData data -> ViewConfigRec data msg -> Json.Decoder Msg
onBackspace { query, selectedItems } { idFn, inputId } =
    let
        _ =
            Debug.log "Query length" (String.length query)
    in
        if String.length query == 0 then
            List.reverse selectedItems
                |> List.head
                |> Maybe.map
                    (\lastItem ->
                        Json.succeed <|
                            RemoveSelected (idFn lastItem) inputId
                    )
                |> Maybe.withDefault (Json.fail "Whatever")
        else
            Json.fail "Don't care then"


keyDownDecoder : Int -> Json.Decoder ScrollInfo
keyDownDecoder idx =
    Json.map4 ScrollInfo
        Events.keyCode
        (Json.at (menuPath ++ [ "offsetHeight" ]) Json.float)
        (Json.maybe <| Json.at (menuPath ++ [ "childNodes", toString <| idx + 1 ]) itemDecoder)
        (Json.maybe <| Json.at (menuPath ++ [ "childNodes", toString <| idx - 1 ]) itemDecoder)


menuPath : List String
menuPath =
    [ "target", "parentElement", "parentElement", "parentElement", "childNodes", "1" ]


itemDecoder : Json.Decoder ItemInfo
itemDecoder =
    Json.map2 ItemInfo
        (Json.field "offsetHeight" Json.float)
        (Json.field "offsetTop" Json.float)


toggleView : Html.Html Msg
toggleView =
    Html.div
        [ style toggleStyles ]
        [ Html.img
            [ Html.Attributes.src "data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 4 5'%3E%3Cpath fill='%23333' d='M2 0L0 2h4zm0 5L0 3h4z'/%3E%3C/svg%3E"
            , style [ ( "width", "8px" ) ]
            ]
            []
        ]


menuView : State -> ViewData data -> ViewConfigRec data msg -> Html.Html Msg
menuView ((State { activeIdx }) as state) { availableItems } config =
    Keyed.node "div"
        [ style menuStyles
        , class "list-group"
        , Html.Attributes.id <| menuIdStr config.inputId
        ]
        (List.indexedMap
            (\idx item -> menuItem state config (idx == activeIdx) idx item)
            availableItems
        )


menuIdStr : InputId -> String
menuIdStr (InputId id) =
    id ++ "-menu"


toMenuId : InputId -> MenuId
toMenuId inputId =
    MenuId <| menuIdStr inputId


menuItem : State -> ViewConfigRec data msg -> Bool -> Int -> data -> ( String, Html.Html Msg )
menuItem ((State stateRec) as state) ({ itemFn, idFn } as config) isActive idx item =
    let
        itemDetails =
            itemFn item

        itemId =
            idFn item
    in
        ( itemId
        , Html.a
            (List.map mapNeverToMsg itemDetails.attributes
                ++ [ classList
                        [ ( "list-group-item", True )
                        , ( "list-group-item-action", True )
                        , ( "active", isActive )
                        ]
                   , href "#"
                   , Events.on "mouseenter" <| Json.succeed <| SetActiveItem idx
                   , Events.onWithOptions "click"
                        { preventDefault = True
                        , stopPropagation = True
                        }
                        (Json.succeed <| SelectItem itemId config.inputId)
                   ]
            )
            (List.map (Html.map (\_ -> NoOp)) itemDetails.children)
        )


getNextIndex : State -> ViewData data -> Int
getNextIndex (State { activeIdx }) { availableItems } =
    if activeIdx < (List.length availableItems) - 1 then
        activeIdx + 1
    else
        0


getPreviousIndex : State -> ViewData data -> Int
getPreviousIndex (State { activeIdx }) { availableItems } =
    if activeIdx > 0 then
        activeIdx - 1
    else
        (List.length availableItems) - 1


getActiveItem : State -> ViewData data -> ViewConfigRec data msg -> Maybe data
getActiveItem (State { activeIdx }) { availableItems } { idFn } =
    List.indexedMap (,) availableItems
        |> List.filter (\x -> Tuple.first x == activeIdx)
        |> List.map Tuple.second
        |> List.head


indexOf : (data -> String) -> data -> List data -> Maybe Int
indexOf idFn item items =
    List.indexedMap (,) items
        |> List.filter (\( _, item_ ) -> idFn item_ == idFn item)
        |> List.map Tuple.first
        |> List.head


wrapperStyles : Html.Attribute msg
wrapperStyles =
    style
        [ ( "position", "relative" ) ]


containerStyles : List ( String, String )
containerStyles =
    [ ( "display", "flex" )
    , ( "cursor", "pointer" )
    , ( "border", "1px solid rgba(0,0,0,.15)" )
    , ( "align-items", "flex-start" )
    , ( "position", "relative" )
    , ( "padding", "2px" )
    ]


searchStyles : List ( String, String )
searchStyles =
    [ ( "display", "flex" )
    , ( "flex-grow", "1" )
    , ( "flex-wrap", "wrap" )
    , ( "min-height", "30px" )
    ]


valueWrapperStyles : List ( String, String )
valueWrapperStyles =
    [ ( "display", "flex" )
    , ( "align-items", "center" )
    ]


valueStyles : List ( String, String )
valueStyles =
    [ ( "margin", "2px" )
    , ( "background", "#d9edf7" )
    , ( "border", "1px solid #bcdff1" )
    , ( "border-radius", "2px" )
    , ( "color", "#31708f" )
    , ( "display", "inline-block" )
    ]


inputStyles : List ( String, String )
inputStyles =
    [ ( "background", "none" )
    , ( "border", "none" )
    , ( "outline", "none" )
    , ( "margin-left", "2px" )
    , ( "vertical-align", "middle" )
    , ( "box-sizing", "border-box" )
    , ( "min-width", "16px" )
    ]


toggleStyles : List ( String, String )
toggleStyles =
    [ ( "flex-grow", "0" )
    , ( "flex-shrink", "0" )
    , ( "display", "flex" )
    , ( "align-items", "center" )
    , ( "justify-content", "center" )
    , ( "height", "30px" )
    ]


clearStyles : List ( String, String )
clearStyles =
    toggleStyles


menuStyles : List ( String, String )
menuStyles =
    [ ( "position", "absolute" )
    , ( "width", "100%" )
    , ( "box-shadow", "3px 3px 3px #ccc" )
    , ( "z-index", "2" )
    , ( "max-height", "400px" )
    , ( "display", "block" )
    , ( "overflow-y", "scroll" )
    ]


toPx : number -> String
toPx val =
    toString val ++ "px"


mapNeverToMsg : Html.Attribute Never -> Html.Attribute Msg
mapNeverToMsg msg =
    Html.Attributes.map (\_ -> NoOp) msg
