module Bootstrap.Modal exposing
    ( view, config, Config
    , hidden, shown, Visibility
    , small, large, centered, hideOnBackdropClick, scrollableBody, attrs
    , header, h1, h2, h3, h4, h5, h6, Header
    , body, Body
    , footer, Footer
    , withAnimation, subscriptions, hiddenAnimated
    )

{-| Modals are streamlined, but flexible dialog prompts. They support a number of use cases from user notifications to completely custom content and feature a handful of helpful subcomponents, sizes, and more.

    type alias Model =
        { modalVisibility : Modal.Visibility }

    init : ( Model, Cmd Msg )
    init =
        ( { modalVisibility = Modal.hidden }, Cmd.none )

    type Msg
        = CloseModal
        | ShowModal

    update : Msg -> Model -> ( Model, Cmd msg )
    update msg model =
        case msg of
            CloseModal ->
                ( { model | modalVisibility = Modal.hidden }
                , Cmd.none
                )

            ShowModal ->
                ( { model | modalVisibility = Modal.shown }
                , Cmd.none
                )

    view : Model -> Html msg
    view model =
        Grid.container []
            [ Button.button
                [ Button.attrs [ onClick ShowModal ] ]
                [ text "Show modal" ]
            , Modal.config CloseModal
                |> Modal.small
                |> Modal.h5 [] [ text "Modal header" ]
                |> Modal.body []
                    [ Grid.containerFluid []
                        [ Grid.row []
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
                        , Button.attrs [ onClick CloseModal ]
                        ]
                        [ text "Close" ]
                    ]
                |> Modal.view model.modalVisibility
            ]

**NOTE:** Don't try to open several modals at the same time. It probably won't end well.


# Modal

@docs view, config, Config


# State

@docs hidden, shown, Visibility


# Modal options

@docs small, large, centered, hideOnBackdropClick, scrollableBody, attrs


# Header

@docs header, h1, h2, h3, h4, h5, h6, Header


# Body

@docs body, Body


# Footer

@docs footer, Footer


# Animated Modals

When you want your modal to support an animation when displayed and closed. There
is a few more things you must wire-up and keep in mind.

@docs withAnimation, subscriptions, hiddenAnimated


## Example

    type Msg
        = ShowModal
          -- Note the extra msg constructor needed
        | AnimateModal Modal.Visibility
        | CloseModal

    update : Msg -> State -> State
    update msg state =
        case msg of
            CloseModal ->
                { state | modalVisibility = Modal.hidden }

            ShowModal ->
                { state | modalVisibility = Modal.shown }

            -- You need to handle the extra animation message
            AnimateModal visibility ->
                { state | modalVisibility = visibility }

    -- Animations for modal doesn't work without a subscription.
    -- DON´T forget this !
    subscriptions : Model -> Sub msg
    subscriptions model =
        Sub.batch
            [ Modal.subscriptions model.modalVisibility AnimateModal ]

    view : Model -> Html msg
    view model =
        Grid.container []
            [ Button.button
                [ Button.attrs [ onClick ShowModal ] ]
                [ text "Show modal" ]
            , Modal.config CloseModal
                |> Modal.h5 [] [ text "Modal header" ]
                |> Modal.body [] [ text "Modal body" ]
                |> Modal.footer []
                    [ Button.button
                        [ Button.outlinePrimary
                        , Button.attrs [ onClick <| AnimateModal Modal.hiddenAnimated ]
                        ]
                        [ text "Close" ]
                    ]
                |> Modal.view model.modalVisibility
            ]

-}

import Bootstrap.General.Internal exposing (ScreenSize(..), screenSizeOption)
import Bootstrap.Utilities.DomHelper as DomHelper
import Browser.Events
import Html
import Html.Attributes as Attr
import Html.Events as Events
import Json.Decode as Json


{-| Visibility state for the modal
-}
type Visibility
    = Show
    | StartClose
    | FadeClose
    | Hide


{-| The modal should be made visible.
-}
shown : Visibility
shown =
    Show


{-| The modal should be hidden
-}
hidden : Visibility
hidden =
    Hide


{-| When using animations use this state for handling custom close buttons etc.

    Button.button
        [ Button.outlinePrimary
        , Button.attrs [ onClick <| CloseModalAnimated Modal.hiddenAnimated ]
        ]
        [ text "Close" ]

-}
hiddenAnimated : Visibility
hiddenAnimated =
    StartClose


{-| Subscription for handling animations
-}
subscriptions : Visibility -> (Visibility -> msg) -> Sub msg
subscriptions visibility animateMsg =
    case visibility of
        StartClose ->
            Browser.Events.onAnimationFrame (\_ -> animateMsg FadeClose)

        _ ->
            Sub.none


{-| Opaque type representing the view config for a model. Use the [`config`](#config) function to create an initial config.
-}
type Config msg
    = Config (ConfigRec msg)


type alias ConfigRec msg =
    { closeMsg : msg
    , withAnimation : Maybe (Visibility -> msg)
    , header : Maybe (Header msg)
    , body : Maybe (Body msg)
    , footer : Maybe (Footer msg)
    , options : Options msg
    }


type alias Options msg =
    { modalSize : Maybe ScreenSize
    , hideOnBackdropClick : Bool
    , centered : Bool
    , scrollableBody : Bool
    , attrs : List (Html.Attribute msg)
    }


{-| Opaque type representing a modal header
-}
type Header msg
    = Header (Item msg)


{-| Opaque type representing a modal body
-}
type Body msg
    = Body (Item msg)


{-| Opaque type representing a modal body
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
small (Config ({ options } as conf)) =
    Config { conf | options = { options | modalSize = Just SM } }


{-| Option to make a modal larger than the default
-}
large : Config msg -> Config msg
large (Config ({ options } as conf)) =
    Config { conf | options = { options | modalSize = Just LG } }


{-| Option to trigger close message when the user clicks on the modal backdrop. Default True.
-}
hideOnBackdropClick : Bool -> Config msg -> Config msg
hideOnBackdropClick hide (Config ({ options } as conf)) =
    Config { conf | options = { options | hideOnBackdropClick = hide } }


{-| Use this function to add any Html.Attribute options you wish to the Modal
-}
attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs values (Config ({ options } as conf)) =
    Config { conf | options = { options | attrs = values } }


{-| Use this function to make the Modal body scrollable.
-}
scrollableBody : Bool -> Config msg -> Config msg
scrollableBody scrollable (Config ({ options } as conf)) =
    Config { conf | options = { options | scrollableBody = scrollable } }


{-| If you don't like the modal vertically centered, override with False here!
-}
centered : Bool -> Config msg -> Config msg
centered val (Config ({ options } as conf)) =
    Config { conf | options = { options | centered = val } }


{-| Configure the modal to support fade-in/out animations. You'll need to provide
a message to handle animation.
-}
withAnimation : (Visibility -> msg) -> Config msg -> Config msg
withAnimation animateMsg (Config conf) =
    Config { conf | withAnimation = Just animateMsg }


{-| Create a modal for your application

  - `show` Whether to display the modal or not (if `False` the content is still in the dom, but hidden). You need to keep track of this state in your model
  - `config` View configuration

-}
view :
    Visibility
    -> Config msg
    -> Html.Html msg
view visibility (Config conf) =
    Html.div
        []
        ([ Html.div
            ([ Attr.tabindex -1 ] ++ display visibility conf)
            [ Html.div
                ([ Attr.attribute "role" "document"
                 , Attr.class "elm-bootstrap-modal"
                 ]
                    ++ modalAttributes conf.options
                    ++ (if conf.options.hideOnBackdropClick then
                            [ Events.on "click" (containerClickDecoder conf.closeMsg) ]

                        else
                            []
                       )
                )
                [ Html.div
                    [ Attr.class "modal-content" ]
                    (List.filterMap
                        identity
                        [ renderHeader conf
                        , renderBody conf.body
                        , renderFooter conf.footer
                        ]
                    )
                ]
            ]
         ]
            ++ backdrop visibility conf
        )


containerClickDecoder : msg -> Json.Decoder msg
containerClickDecoder closeMsg =
    DomHelper.target DomHelper.className
        |> Json.andThen
            (\c ->
                if String.contains "elm-bootstrap-modal" c then
                    Json.succeed closeMsg

                else
                    Json.fail "ignoring"
            )


display : Visibility -> ConfigRec msg -> List (Html.Attribute msg)
display visibility conf =
    case visibility of
        Show ->
            [ Attr.style "pointer-events" "none"
            , Attr.style "display" "block"
            , Attr.classList
                [ ( "modal", True )
                , ( "fade", isFade conf )
                , ( "show", True )
                ]
            ]

        StartClose ->
            [ Attr.style "pointer-events" "none"
            , Attr.style "display" "block"
            , Attr.classList
                [ ( "modal", True )
                , ( "fade", True )
                , ( "show", True )
                ]
            ]

        FadeClose ->
            [ Attr.style "pointer-events" "none"
            , Attr.style "display" "block"
            , Attr.classList
                [ ( "modal", True )
                , ( "fade", True )
                , ( "show", False )
                ]
            , Events.on "transitionend" (Json.succeed conf.closeMsg)
            ]

        Hide ->
            [ Attr.style "height" "0px"
            , Attr.style "display" "block"
            , Attr.classList
                [ ( "modal", True )
                , ( "fade", isFade conf )
                , ( "show", False )
                ]
            ]


isFade : ConfigRec msg -> Bool
isFade conf =
    Maybe.map (\_ -> True) conf.withAnimation |> Maybe.withDefault False


{-| Create an initial modal config. You can enrich the config by using the header, body, footer and option related functions.
-}
config : msg -> Config msg
config closeMsg =
    Config
        { closeMsg = closeMsg
        , withAnimation = Nothing
        , options =
            { modalSize = Nothing
            , hideOnBackdropClick = True
            , centered = True
            , scrollableBody = False
            , attrs = []
            }
        , header = Nothing
        , body = Nothing
        , footer = Nothing
        }


{-| Create a header for a modal, typically for titles, but you can be imaginative

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

-}
header :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
header attributes children (Config conf) =
    Config
        { conf
            | header =
                Just <|
                    Header
                        { attributes = attributes
                        , children = children
                        }
        }


{-| Creates a modal header with a h1 title child element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

-}
h1 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h1 =
    titledHeader Html.h1


{-| Creates a modal header with a h2 title child element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

-}
h2 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h2 =
    titledHeader Html.h2


{-| Creates a modal header with a h3 title child element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

-}
h3 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h3 =
    titledHeader Html.h3


{-| Creates a modal header with a h4 title child element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

-}
h4 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h4 =
    titledHeader Html.h4


{-| Creates a modal header with a h5 title child element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

-}
h5 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
h5 =
    titledHeader Html.h5


{-| Creates a modal header with a h6 title child element

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

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

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure body for

-}
body :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
body attributes children (Config conf) =
    { conf
        | body =
            Just <|
                Body
                    { attributes = attributes
                    , children = children
                    }
    }
        |> Config


{-| Create a footer for a modal. Normally used for action buttons, but you might be creative

  - `attributes` List of attributes
  - `children` List of child elements
  - `config` configuration settings to configure header for

-}
footer :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
footer attributes children (Config conf) =
    { conf
        | footer =
            Just <|
                Footer
                    { attributes = attributes
                    , children = children
                    }
    }
        |> Config


modalAttributes : Options msg -> List (Html.Attribute msg)
modalAttributes options =
    options.attrs
        ++ [ Attr.classList
                [ ( "modal-dialog", True )
                , ( "modal-dialog-centered", options.centered )
                , ( "modal-dialog-scrollable", options.scrollableBody )
                ]
           , Attr.style "pointer-events" "auto"
           ]
        ++ (Maybe.map modalClass options.modalSize
                |> Maybe.withDefault []
           )


modalClass : ScreenSize -> List (Html.Attribute msg)
modalClass size =
    case screenSizeOption size of
        Just s ->
            [ Attr.class <| "modal-" ++ s ]

        Nothing ->
            []


renderHeader : ConfigRec msg -> Maybe (Html.Html msg)
renderHeader conf_ =
    case conf_.header of
        Just (Header cfg) ->
            Html.div
                (Attr.class "modal-header" :: cfg.attributes)
                (cfg.children ++ [ closeButton <| getCloseMsg conf_ ])
                |> Just

        Nothing ->
            Nothing


getCloseMsg : ConfigRec msg -> msg
getCloseMsg config_ =
    case config_.withAnimation of
        Just animationMsg ->
            animationMsg StartClose

        Nothing ->
            config_.closeMsg


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


closeButton : msg -> Html.Html msg
closeButton closeMsg =
    Html.button
        [ Attr.class "close", Events.onClick <| closeMsg ]
        [ Html.text "×" ]


backdrop : Visibility -> ConfigRec msg -> List (Html.Html msg)
backdrop visibility conf =
    let
        attributes =
            case visibility of
                Show ->
                    [ Attr.classList
                        [ ( "modal-backdrop", True )
                        , ( "fade", isFade conf )
                        , ( "show", True )
                        ]
                    ]
                        ++ (if conf.options.hideOnBackdropClick then
                                [ Events.onClick <| getCloseMsg conf ]

                            else
                                []
                           )

                StartClose ->
                    [ Attr.classList
                        [ ( "modal-backdrop", True )
                        , ( "fade", True )
                        , ( "show", True )
                        ]
                    ]

                FadeClose ->
                    [ Attr.classList
                        [ ( "modal-backdrop", True )
                        , ( "fade", True )
                        , ( "show", False )
                        ]
                    ]

                Hide ->
                    [ Attr.classList
                        [ ( "modal-backdrop", False )
                        , ( "fade", isFade conf )
                        , ( "show", False )
                        ]
                    ]
    in
    [ Html.div attributes [] ]
