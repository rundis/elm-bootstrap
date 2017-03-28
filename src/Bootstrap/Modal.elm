module Bootstrap.Modal
    exposing
        ( view
        , config
        , header
        , body
        , footer
        , hiddenState
        , visibleState
        , small
        , large
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        , State
        , Option
        , Header
        , Body
        , Footer
        , Config
        )

{-| Modals are streamlined, but flexible dialog prompts. They support a number of use cases from user notifications to completely custom content and feature a handful of helpful subcomponents, sizes, and more.



    type alias Model =
        { modalState : Modal.State }


    init : ( Model, Cmd Msg )
    init =
        ( { modalState : Modal.initalState }, Cmd.none )


    type Msg
        = ModalMsg Modal.State


    update : Msg -> Model -> ( Model, Cmd msg )
    update msg model =
        case msg of
            ModelMsg state ->
                ( { model | modalState = state }
                , Cmd.none
                )

    view : Model -> Html msg
    view model =
        Grid.container []
            [ Button.button
                [ Button.attrs [ onClick ModalMsg Modal.visibleState ] ]
                [ text "Show modal" ]

            , Modal.config ModalMsg
                |> Modal.small
                |> Modal.h5 [] [ text "Modal header" ]
                |> Modal.body []
                    [ Grid.containerFluid []
                        [ Grid.row
                            [ Grid.col
                                [ Col.xs6 ]
                                [ text "Col 1" ]
                            , Grid.col
                                [ Col.xs6 ]
                                [ text "Col 2" ]
                            ]
                        ]
                    ]
                |> Modal.footer []
                    [ Button.button
                        [ Button.outlinePrimary
                        , Button.attrs [ onClick <| ModalMsg Modal.hiddenState ]
                        ]
                        [ text "Close" ]
                    ]
                |> Modal.view
            ]


**NOTE:** Don't try to open several modals at the same time. It probably won't end well.



# Modal
@docs view, config, Config


## State
@docs hiddenState, visibleState, State


## Modal options
@docs small, large, Option


## Header
@docs header, h1, h2, h3, h4, h5, h6, Header


## Body
@docs body, Body

## Footer
@docs footer, Footer


-}

import Html
import Html.Attributes as Attr
import Html.Events as Events
import Bootstrap.Grid.Internal as GridInternal exposing (ScreenSize(..))


{-| Opaque type representing the view config for a model. Use the [`config`](#config) function to create an inital config.
-}
type Config msg
    = Config
        { toMsg : State -> msg
        , header : Maybe (Header msg)
        , body : Maybe (Body msg)
        , footer : Maybe (Footer msg)
        , options : List Option
        }


{-| Opaque representation of the view state of a modal
-}
type State
    = State Bool


{-| Opaque type representing configuration options
-}
type Option
    = ModalSize GridInternal.ScreenSize


{-| Opaque type represetning a modal header
-}
type Header msg
    = Header (Item msg)


{-| Opaque type represetning a modal body
-}
type Body msg
    = Body (Item msg)


{-| Opaque type represetning a modal body
-}
type Footer msg
    = Footer (Item msg)


type alias Item msg =
    { attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


{-| Option to make a modal smaller than the default
-}
small : Config msg -> Config msg
small (Config config) =
    Config { config | options = config.options ++ [ ModalSize SM ] }


{-| Option to make a modal larger than the default
-}
large : Config msg -> Config msg
large (Config config) =
    Config { config | options = config.options ++ [ ModalSize LG ] }


{-| Ensures the modal is not displayed (it's still in the DOM though !)
-}
hiddenState : State
hiddenState =
    State False


{-| In this state the modal will be displayed
-}
visibleState : State
visibleState =
    State True


{-| Create a modal for your application

* `state` The current view state of the modal. You need to keep track of this state in your model
* `config` View configuration

-}
view :
    State
    -> Config msg
    -> Html.Html msg
view state (Config { toMsg, header, body, footer, options }) =
    Html.div
        []
        ([ Html.div
            ([ Attr.tabindex -1 ] ++ display state)
            [ Html.div
                (Attr.attribute "role" "document" :: modalAttributes options)
                [ Html.div
                    [ Attr.class "modal-content" ]
                    (List.filterMap
                        identity
                        [ renderHeader toMsg header
                        , renderBody body
                        , renderFooter footer
                        ]
                    )
                ]
            ]
         ]
            ++ backdrop state
        )


{-| Create an initial modal config. You can enrich the config by using the header, body, footer and option related functions.
-}
config : (State -> msg) -> Config msg
config toMsg =
    Config
        { toMsg = toMsg
        , options = []
        , header = Nothing
        , body = Nothing
        , footer = Nothing
        }


{-| Create a header for a modal, typically for titles, but you can be imaginative

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
header :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
header attributes children (Config config) =
    Config
        { config
            | header =
                Just <|
                    Header
                        { attributes = attributes
                        , children = children
                        }
        }


{-| Creates a modal header with a h1 title child element

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
h1 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h1 =
    titledHeader Html.h1


{-| Creates a modal header with a h2 title child element

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
h2 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h2 =
    titledHeader Html.h2


{-| Creates a modal header with a h3 title child element

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
h3 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h3 =
    titledHeader Html.h3


{-| Creates a modal header with a h4 title child element

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
h4 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h4 =
    titledHeader Html.h4


{-| Creates a modal header with a h5 title child element

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
h5 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h5 =
    titledHeader Html.h5


{-| Creates a modal header with a h6 title child element

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
h6 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h6 =
    titledHeader Html.h6


titledHeader :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titledHeader itemFn attributes children =
    header []
        [ itemFn (Attr.class "modal-title" :: attributes) children ]


{-| Create a body for a modal, you would typically always create a body for a modal

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure body for
-}
body :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
body attributes children (Config config) =
    { config
        | body =
            Just <|
                Body
                    { attributes = attributes
                    , children = children
                    }
    }
        |> Config


{-| Create a footer for a modal. Normally used for action buttons, but you might be creative

* `attributes` List of attributes
* `children` List of child elements
* `config` configuration settings to configure header for
-}
footer :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
footer attributes children (Config config) =
    { config
        | footer =
            Just <|
                Footer
                    { attributes = attributes
                    , children = children
                    }
    }
        |> Config


display : State -> List (Html.Attribute msg)
display (State open) =
    [ Attr.style
        ([ ( "display", "block" ) ] ++ ifElse open [] [ ( "height", "0px" ) ])
    , Attr.classList
        [ ( "modal", True )
        , ( "fade", True )
        , ( "show", open )
        ]
    ]


modalAttributes : List Option -> List (Html.Attribute msg)
modalAttributes options =
    Attr.class "modal-dialog"
        :: (List.map modalClass options
                |> List.filterMap identity
           )


modalClass : Option -> Maybe (Html.Attribute msg)
modalClass option =
    case option of
        ModalSize size ->
            case GridInternal.screenSizeOption size of
                Just s ->
                    Just <| Attr.class <| "modal-" ++ s

                Nothing ->
                    Nothing


renderHeader : (State -> msg) -> Maybe (Header msg) -> Maybe (Html.Html msg)
renderHeader toMsg maybeHeader =
    case maybeHeader of
        Just (Header cfg) ->
            Html.div
                (Attr.class "modal-header" :: cfg.attributes)
                (cfg.children ++ [ closeButton toMsg ])
                |> Just

        Nothing ->
            Nothing


renderBody : Maybe (Body msg) -> Maybe (Html.Html msg)
renderBody maybeBody =
    case maybeBody of
        Just (Body cfg) ->
            Html.div
                (Attr.class "modal-body" :: cfg.attributes)
                cfg.children
                |> Just

        Nothing ->
            Nothing


renderFooter : Maybe (Footer msg) -> Maybe (Html.Html msg)
renderFooter maybeFooter =
    case maybeFooter of
        Just (Footer cfg) ->
            Html.div
                (Attr.class "modal-footer" :: cfg.attributes)
                cfg.children
                |> Just

        Nothing ->
            Nothing


closeButton : (State -> msg) -> Html.Html msg
closeButton toMsg =
    Html.button
        [ Attr.class "close", Events.onClick <| toMsg hiddenState ]
        [ Html.text "x" ]


backdrop : State -> List (Html.Html msg)
backdrop (State open) =
    if open then
        [ Html.div
            [ Attr.class "modal-backdrop fade show" ]
            []
        ]
    else
        []


ifElse : Bool -> a -> a -> a
ifElse pred true false =
    if pred then
        true
    else
        false
