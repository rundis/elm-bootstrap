module Bootstrap.Tab exposing
    ( tab
    , pills
    , tabItem
    , tabLink
    , tabPane
    , state
    , Config
    , State
    , TabItem
    , TabLink
    , TabPane
    )


import Html
import Html.Attributes exposing (class, classList, href)
import Html.Events exposing (onClick)

type alias State =
    { activeTab : Int }


type alias Config msg =
    { toMsg : State -> msg
    , items : List (TabItem msg)
    }


type TabItem msg =
    TabItem
        { link : TabLink msg
        , pane : TabPane msg
        }

type TabLink msg =
    TabLink
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }

type TabPane msg =
    TabPane
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
        }


state : Int -> State
state activeTab =
    State activeTab



tab : Config msg -> State -> Html.Html msg
tab config state =
    renderTab "nav-tabs" config state

pills : Config msg -> State -> Html.Html msg
pills config state =
    renderTab "nav-pills" config state


renderTab : String -> Config msg -> State -> Html.Html msg
renderTab tabClass {toMsg, items} state =
    Html.div []
        [ Html.ul
            [class <| "nav " ++ tabClass ]
            ( List.indexedMap
                (\idx (TabItem {link}) ->
                    renderTabLink idx (idx == state.activeTab) toMsg link
                )
                items
            )
        , Html.div
            [ class "tab-content" ]
            ( List.indexedMap
                (\idx (TabItem {pane}) ->
                    renderTabPane (idx == state.activeTab) pane
                )
                items
            )
        ]

renderTabLink
    : Int
    -> Bool
    -> (State -> msg)
    -> TabLink msg
    -> Html.Html msg
renderTabLink idx active toMsg (TabLink {attributes, children}) =
    Html.li
        [class "nav-item"]
        [ Html.a
            ([ classList
                 [ ("nav-link", True)
                 , ("active", active)
                 ]
            , href "#"
            , onClick <| toMsg {activeTab = idx}
            ] ++ attributes)
            children
        ]

renderTabPane
    : Bool
    -> TabPane msg
    -> Html.Html msg
renderTabPane active (TabPane {attributes, children}) =
    Html.div
        ([ classList
            [ ("tab-pane", True)
            , ("active", active)
            ]
        ] ++ attributes)
        children


tabItem :
    { link : TabLink msg
    , pane : TabPane msg
    }
    -> TabItem msg
tabItem {link, pane} =
    TabItem
        { link = link
        , pane = pane
        }

tabLink : List (Html.Attribute msg) -> List (Html.Html msg) -> TabLink msg
tabLink attributes children =
    TabLink
        { attributes = attributes
        , children = children
        }

tabPane : List (Html.Attribute msg) -> List (Html.Html msg) -> TabPane msg
tabPane attributes children =
    TabPane
        { attributes = attributes
        , children = children
        }

