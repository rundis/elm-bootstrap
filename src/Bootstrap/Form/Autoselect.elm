module Bootstrap.Form.Autoselect
    exposing
        ( view
        , initialState
        , State
        , Config
        , MenuItem
        , SelectedItem
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
import Task


type State
    = State
        { containerWidth : Maybe Float
        , showMenu : Bool
        , activeId : Int
        }


type alias MenuItem msg =
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type alias SelectedItem msg =
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type alias Config data msg =
    { toMsg : State -> msg
    , id : String
    , onInput : ( String, Cmd msg ) -> msg
    , onSelect : ( data, Cmd msg ) -> msg
    , onRemoveSelected : ( List data, Cmd msg ) -> msg
    , onFocused : msg
    , onScrollDown : Cmd msg -> msg
    , idFn : data -> String
    , itemFn : data -> MenuItem msg
    , selectedFn : data -> SelectedItem msg
    }


type alias ViewData data =
    { query : String
    , availableItems : List data
    , selectedItems : List data
    }


initialState : State
initialState =
    State
        { showMenu = False
        , activeId = 0
        , containerWidth = Nothing
        }


view : State -> ViewData data -> Config data msg -> Html.Html msg
view ((State { showMenu }) as state) viewData config =
    Html.div
        [ wrapperStyles ]
        ([ Html.div
            [ containerStyles
              -- TODO : This is not pretty !
            , Events.onClick
                (config.onScrollDown <| requestFocus state config)
            ]
            ([ searchView state viewData config ]
                ++ (if List.length viewData.selectedItems > 0 then
                    [ clearView state viewData config ]
                   else
                    [])
                ++ [toggleView]
            )
         ]
            ++ if showMenu then
                [ menuView state viewData config ]
               else
                []
        )


searchView : State -> ViewData data -> Config data msg -> Html.Html msg
searchView state viewData config =
    Html.div
        [ searchStyles ]
        (selectedValues viewData config
            ++ [ searchInput state viewData config ]
        )

clearView : State -> ViewData data -> Config data msg -> Html.Html msg
clearView state viewData config =
    Html.div
        [ style
            [ ("flex-grow", "0")
            , ("flex-shrink", "0")
            , ("display", "flex")
            , ("align-items", "center")
            , ("justify-content", "center")
            , ("height", "30px")
            ]
        , Events.onClick (config.onRemoveSelected (viewData.selectedItems, Cmd.none) )
        ]
        [ Html.button
            [ class "btn btn-sm btn-secondary"
            , style [("border", "none")]
            ]
            [ Html.text "×"]
        ]
        --[ Html.span [ style [("padding", "2px")]] [ Html.text "×"] ]

toggleView =
    Html.div
        [ style
            [ ("flex-grow", "0")
            , ("flex-shrink", "0")
            , ("display", "flex")
            , ("align-items", "center")
            , ("justify-content", "center")
            , ("height", "30px")
            ]
        ]
        [ Html.img
            [ Html.Attributes.src "data:image/svg+xml;charset=utf8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 4 5'%3E%3Cpath fill='%23333' d='M2 0L0 2h4zm0 5L0 3h4z'/%3E%3C/svg%3E"
            , style [("width", "8px")]
{-             style
                [("background", """#fff  no-repeat right 0.25rem top""")
            , ("background-size", "8px 10px")] -}
            ]
            []
        ]



selectedValues : ViewData data -> Config data msg -> List (Html.Html msg)
selectedValues { selectedItems } { selectedFn } =
    (List.map (selectedFn >> selectValue) selectedItems)


selectValue : SelectedItem msg -> Html.Html msg
selectValue { attributes, children } =
    Html.div [ valueStyles ]
        [ Html.div
            ([ style
                [ ( "margin", "2px" )
                , ( "background", "#d9edf7" )
                , ( "border", "1px solid #bcdff1" )
                , ( "border-radius", "2px" )
                , ( "color", "#31708f" )
                , ( "display", "inline-block" )
                ]
             ]
                ++ attributes
            )
            [ Html.button
                [ class "btn btn-sm btn-outline-info"
                , style [("border", "0px"), ("margin-top", "-4px")]
                ]
                [ Html.text "×" ]

            , Html.span
                [ style
                    [ ( "padding", "2px 4px 2px 2px" )
                    , ( "font-family", "sans-serif")
                    ]
                ]

                children
            ]
        ]


searchInput : State -> ViewData data -> Config data msg -> Html.Html msg
searchInput ((State { containerWidth }) as state) ({ query } as viewData) config =
    let
        shadowItem =
            Text.fromString query
                |> Text.height 16
                |> Text.typeface [ "system-ui" ]
                |> Element.leftAligned

        inputWidth =
            Element.widthOf shadowItem + 2

        maxWidth =
            Maybe.map (\w -> w - 6) containerWidth
                |> Maybe.withDefault (toFloat inputWidth)
    in
        Html.input
            [ style
                ([ ( "width", toPx inputWidth )
                 , ( "max-width", toPx maxWidth )
                 ]
                    ++ inputStyles
                )
            , Html.Attributes.id config.id
            , value query
            , onInput state config
            , onFocus state config.toMsg
            , onKeyDown state viewData config
              --, Events.onBlur <| toMsg (State { stateRec | showMenu = False, activeId = Nothing }, requestFocus state config)
            ]
            []


onInput : State -> Config data msg -> Html.Attribute msg
onInput (State stateRec) config =
    Events.onInput
        (\s ->
            config.onInput
                ( s
                , requestUpdate (State { stateRec | activeId = 0, showMenu = True }) config
                )
        )


onFocus : State -> (State -> msg) -> Html.Attribute msg
onFocus (State state) toMsg =
    Events.on "focus"
        (inputDecoder
            |> Json.andThen
                (\v ->
                    toMsg
                        (State
                            { state
                                | containerWidth = v
                                , showMenu = True
                                , activeId = 0
                            }
                        )
                        |> Json.succeed
                )
        )


onKeyDown : State -> ViewData data -> Config data msg -> Html.Attribute msg
onKeyDown ((State stateRec) as state) viewData config =
    let
        handleKey info =
            case info.keyCode of
                13 ->
                    case getActiveItem state viewData config of
                        Just item ->
                            let
                                newState =
                                    State { stateRec | activeId = 0 }
                            in
                                Json.succeed <|
                                    config.onSelect
                                        ( item
                                        , Cmd.batch
                                            [ requestScrollUp 0 newState config
                                            , requestFocus newState config
                                            ]
                                        )

                        Nothing ->
                            Json.fail "No selection"

                40 ->
                    case info.nextItem of
                        Just { offsetHeight, offsetTop } ->
                            if offsetHeight + offsetTop > info.menuHeight then
                                Json.succeed <|
                                    config.onScrollDown <|
                                        requestScrollDown
                                            (offsetHeight + offsetTop - info.menuHeight)
                                            (State { stateRec | activeId = getNextIndex state viewData })
                                            config
                            else
                                Json.succeed <|
                                    config.toMsg <|
                                        State { stateRec | activeId = getNextIndex state viewData }

                        Nothing ->
                            Json.succeed <|
                                config.onScrollDown <|
                                    requestScrollUp
                                        0
                                        (State { stateRec | activeId = getNextIndex state viewData })
                                        config

                38 ->
                    case info.previousItem of
                        Just { offsetHeight, offsetTop } ->
                            Json.succeed <|
                                    config.onScrollDown <|
                                        requestScrollUp
                                            offsetTop
                                            (State { stateRec | activeId = getPreviousIndex state viewData })
                                            config


                        _ ->
                            Json.succeed <|
                                config.onScrollDown <|
                                    requestScrollDown
                                        info.menuHeight
                                        (State { stateRec | activeId = getPreviousIndex state viewData })
                                        config

                {- Json.succeed <|
                   config.toMsg <|
                       State { stateRec | activeId = getPreviousIndex state viewData }
                -}
                27 ->
                    Json.succeed <|
                        config.toMsg <|
                            State { stateRec | showMenu = False }

                8 ->
                    if String.length viewData.query == 0 then
                        List.reverse viewData.selectedItems
                            |> List.head
                            |> Maybe.map
                                (\lastItem ->
                                    Json.succeed (config.onRemoveSelected ( [lastItem], requestFocus state config ))
                                )
                            |> Maybe.withDefault (Json.fail "Whatever")
                    else
                        Json.fail "Don't care then"

                _ ->
                    Json.fail "not ENTER"
    in
        --Events.on "keydown" (Json.andThen isEnter Events.keyCode)
        Events.on "keydown"
            (keyDownDecoder stateRec.activeId
                |> Json.andThen
                    (\v ->
                        let
                            _ =
                                Debug.log "Stuff: " v
                        in
                            handleKey v
                    )
            )



type alias ScrollInfo =
    { keyCode : Int
    , menuHeight : Float
    , currItem : Maybe ItemInfo
    , nextItem : Maybe ItemInfo
    , previousItem : Maybe ItemInfo
    }

type alias ItemInfo =
    { offsetHeight : Float
    , offsetTop : Float
    }


keyDownDecoder : Int -> Json.Decoder ScrollInfo
keyDownDecoder idx =
    let menuPath =
        [ "target", "parentElement", "parentElement", "parentElement", "childNodes", "1"]
    in
        Json.map5 ScrollInfo
            Events.keyCode
            (Json.at (menuPath ++ ["offsetHeight"]) Json.float)
            (Json.maybe <| Json.at (menuPath ++ ["childNodes", toString idx]) itemDecoder)
            (Json.maybe <| Json.at (menuPath ++ ["childNodes", toString <| idx + 1]) itemDecoder)
            (Json.maybe <| Json.at (menuPath ++ ["childNodes", toString <| idx - 1]) itemDecoder)
            --(Json.at (menuPath ++ ["childNodes", toString <| idx + 1, "offsetHeight"]) Json.float)
            --(Json.at (menuPath ++ ["childNodes", toString <| idx + 1, "offsetTop"]) Json.float)


itemDecoder : Json.Decoder ItemInfo
itemDecoder =
    Json.map2 ItemInfo
        (Json.field "offsetHeight" Json.float)
        (Json.field "offsetTop" Json.float)





inputDecoder : Json.Decoder (Maybe Float)
inputDecoder =
    Json.maybe <|
        Json.at [ "target", "parentElement", "parentElement", "parentElement", "offsetWidth" ] Json.float


menuView : State -> ViewData data -> Config data msg -> Html.Html msg
menuView ((State { activeId }) as state) { availableItems } config =
    Keyed.node "div"
        [ style
            [ ( "position", "absolute" )
            , ( "width", "100%" )
            , ( "box-shadow", "3px 3px 3px #ccc")
            , ( "z-index", "2" )
            , ( "max-height", "400px" )
            , ( "display", "block" )
            , ( "overflow-y", "scroll" )
            ]
        , class "list-group"
        , Html.Attributes.id <| config.id ++ "-menu"
        ]
        (List.indexedMap
            (\idx item -> menuItem state config (idx == activeId) idx item)
            availableItems
        )


menuItem : State -> Config data msg -> Bool -> Int -> data -> ( String, Html.Html msg )
menuItem ((State stateRec) as state) ({ toMsg, onSelect, itemFn, idFn } as config) isActive idx item =
    let
        itemDetails =
            itemFn item

        itemId =
            idFn item
    in
        ( itemId
        , Html.a
            (itemDetails.attributes
                ++ [ classList
                        [ ( "list-group-item", True )
                        , ( "list-group-item-action", True )
                        , ( "active", isActive )
                        ]
                   , href "#"
                   , Events.on "mouseenter" <|
                             Json.succeed <|
                                 toMsg <|
                                     State { stateRec | activeId = idx }
                   , Events.onWithOptions "click"
                        { preventDefault = True
                        , stopPropagation = False
                        }
                        (Json.succeed (onSelect ( item, requestFocus state config )))
                   ]
            )
            itemDetails.children
        )


getActiveItem : State -> ViewData data -> Config data msg -> Maybe data
getActiveItem (State { activeId }) { availableItems } { idFn } =
    List.indexedMap (,) availableItems
        |> List.filter (\x -> Tuple.first x == activeId)
        |> List.map Tuple.second
        |> List.head


getNextIndex : State -> ViewData data -> Int
getNextIndex (State { activeId }) { availableItems } =
    if activeId < (List.length availableItems) - 1 then
        activeId + 1
    else
        0


getPreviousIndex : State -> ViewData data -> Int
getPreviousIndex (State { activeId }) { availableItems } =
    if activeId > 0 then
        activeId - 1
    else
        (List.length availableItems) - 1


indexOf : (data -> String) -> data -> List data -> Maybe Int
indexOf idFn item items =
    List.indexedMap (,) items
        |> List.filter (\( _, item_ ) -> idFn item_ == idFn item)
        |> List.map Tuple.first
        |> List.head


requestFocus : State -> Config data msg -> Cmd msg
requestFocus state config =
    Task.attempt (\_ -> config.onFocused) (Dom.focus config.id)


requestScrollDown : Float -> State -> Config data msg -> Cmd msg
requestScrollDown scrollBy  state config =
    let id = (config.id ++ "-menu")
    in
        Scroll.y id
            |> Task.andThen
                (\res ->
                    if scrollBy > res then
                        Scroll.toY (config.id ++ "-menu") scrollBy
                    else
                        Task.succeed ()
                    )
            |> Task.attempt (\_ -> config.toMsg state)


requestScrollUp : Float -> State -> Config data msg -> Cmd msg
requestScrollUp scrollBy  state config =
    let id = (config.id ++ "-menu")
    in
        Scroll.y id
            |> Task.andThen
                (\res ->
                    if res > 0 && res > scrollBy then
                        Scroll.toY (config.id ++ "-menu") scrollBy
                    else
                        Task.succeed ()
                    )
            |> Task.attempt (\_ -> config.toMsg state)


requestUpdate : State -> Config data msg -> Cmd msg
requestUpdate state config =
    Task.attempt (\_ -> config.toMsg state) (Task.succeed state)


wrapperStyles : Html.Attribute msg
wrapperStyles =
    style
        [ ( "position", "relative" ) ]


containerStyles : Html.Attribute msg
containerStyles =
    style
        [ ( "display", "flex" )
        , ( "cursor", "pointer" )
        , ( "border", "1px solid rgba(0,0,0,.15)" )
        , ( "align-items", "flex-start" )
        , ( "position", "relative" )
        , ( "padding", "2px" )
        ]


searchStyles : Html.Attribute msg
searchStyles =
    style
        [ ( "display", "flex" )
        , ( "flex-grow", "1" )
        , ( "flex-wrap", "wrap" )
        , ( "min-height", "30px" )
        ]


valueStyles : Html.Attribute msg
valueStyles =
    style
        [ ( "display", "flex" )
        , ( "align-items", "center" )
        ]


inputStyles : List ( String, String )
inputStyles =
    [ ( "background", "none" )
    , ( "border", "none" )
    , ( "outline", "none" )
    , ( "margin-left", "2px" )
      --, ("padding", "4px 0")
    , ( "vertical-align", "middle" )
    , ( "box-sizing", "border-box" )
    , ( "min-width", "16px" )
    ]


toPx : number -> String
toPx val =
    toString val ++ "px"
