module Bootstrap.Popover exposing
    ( config, initialState, view, Config, State
    , onClick, onHover
    , title, content, titleH1, titleH2, titleH3, titleH4, titleH5, titleH6
    , left, right, top, bottom
    )

{-| Add small overlay content, like those found in iOS, to any element for housing secondary information.

    -- You need to keep track of the view state for a popover
    type alias Model =
        { popoverState : Popover.State }

    -- Define a message to handle popover state changes
    type Msg
        = PopoverMsg Popover.State

    -- Initialize the popover state
    initialState : ( Model, Cmd Msg )
    initialState =
        ( { popoverState = Popover.initialState }, Cmd.none )

    -- Step the popover state forward in your update function
    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            PopoverMsg state ->
                ( { model | popoverState = state }, Cmd.none )

    -- Compose a popover in your view (or a view helper function)
    view : Model -> Html Msg
    view model =
        Popover.config
            (Button.button
                -- Here configure the popover to be shown when the mouse is above the button ( tooltip basically !)
                [ Button.attrs <| Popover.onHover model.popoverState PopoverMsg ]
                [ text "Toggle tooltip" ]
            )
            |> Popover.right
            |> Popover.titleH4 [] [ text "My title" ]
            |> Popover.content []
                [ text "Some content for my popover."
                , p [] [ text "Different elements ok..." ]
                ]
            |> Popover.view model.popoverState

_You should be aware that the triggering element is wrapped by an `inline-block` div with relative positioning and that
the popover is added as a sibling of the triggering element. This will limit it's usage and there are bound to be
cases where they don't work as you'd expect. So make sure you test your views when using them !_


# Setup

@docs config, initialState, view, Config, State


# Triggering

@docs onClick, onHover


# View composition

@docs title, content, titleH1, titleH2, titleH3, titleH4, titleH5, titleH6


# Positioning

@docs left, right, top, bottom

-}

import Bootstrap.Utilities.DomHelper as DomHelper
import Html
import Html.Attributes exposing (attribute, class, classList, style)
import Html.Events
import Json.Decode as Json


{-| Opaque representation of the view configuration for a Popover
-}
type Config msg
    = Config
        { triggerElement : Html.Html msg
        , direction : Position
        , title : Maybe (Title msg)
        , content : Maybe (Content msg)
        }


{-| Opaque representation of the view state for a Popover
-}
type State
    = State
        { isActive : Bool
        , domState : DOMState
        }


type alias DOMState =
    { rect : DomHelper.Area
    , offsetWidth : Float
    , offsetHeight : Float
    }


type Position
    = Top
    | Right
    | Bottom
    | Left


type Title msg
    = Title (Html.Html msg)


type Content msg
    = Content (Html.Html msg)


type alias Pos =
    { left : Float
    , top : Float
    , arrowTop : Maybe Float
    , arrowLeft : Maybe Float
    }


{-| Initial default view state.
-}
initialState : State
initialState =
    State
        { isActive = False
        , domState =
            { rect = { left = 0, top = 0, width = 0, height = 0 }
            , offsetWidth = 0
            , offsetHeight = 0
            }
        }


{-| This function creates the view representation for a Popover. Whether it's displayed or not
is determined by it's view state.

  - `state` - The current view state for the popover
  - `config` - The view configuration for the popover

-}
view : State -> Config msg -> Html.Html msg
view state ((Config { triggerElement }) as conf) =
    Html.div
        [ style "position" "relative"
        , style "display" "inline-block"
        ]
        [ triggerElement
        , popoverView state conf
        ]


popoverView : State -> Config msg -> Html.Html msg
popoverView (State { isActive, domState }) (Config conf) =
    let
        px f =
            String.fromFloat f ++ "px"

        pos =
            calculatePos conf.direction domState

        styles =
            if isActive then
                [ style "left" <| px pos.left
                , style "top" <| px pos.top
                , style "display" "inline-block"
                , style "width" <| px domState.offsetWidth
                ]

            else
                [ style "left" "-5000px"
                , style "top" "-5000px"
                ]

        arrowStyles =
            [ Maybe.map (\t -> style "top" <| px t) pos.arrowTop
            , Maybe.map (\l -> style "left" <| px l) pos.arrowLeft
            ]
                |> List.filterMap identity
    in
    Html.div
        ([ classList
            [ ( "popover", True )
            , ( "fade", True )
            , ( "show", isActive )
            , positionClass conf.direction
            ]
         , directionAttr conf.direction
         ]
            ++ styles
        )
        ([ Just <| Html.div (class "arrow" :: arrowStyles) []
         , Maybe.map (\(Title t) -> t) conf.title
         , Maybe.map (\(Content c) -> c) conf.content
         ]
            |> List.filterMap identity
        )


directionAttr : Position -> Html.Attribute msg
directionAttr position =
    attribute "x-placement" <|
        case position of
            Left ->
                "left"

            Right ->
                "right"

            Top ->
                "top"

            Bottom ->
                "bottom"


positionClass : Position -> ( String, Bool )
positionClass position =
    case position of
        Left ->
            ( "bs-popover-left", True )

        Right ->
            ( "bs-popover-right", True )

        Top ->
            ( "bs-popover-top", True )

        Bottom ->
            ( "bs-popover-bottom", True )


{-| Creates a click handler that will toggle the visibility of
a popover

  - `state` - The current state of the popover to toggle
  - `toMsg` - Message tagger function to handle state changes to a popover

-}
onClick : State -> (State -> msg) -> List (Html.Attribute msg)
onClick state toMsg =
    [ class "popover-trigger"
    , Html.Events.on "click" <| toggleState state toMsg
    ]


{-| Creates a `mouseenter` and `mouseleave` message handler that will toggle the visibility of
a popover

  - `state` - The current state of the popover to toggle
  - `toMsg` - Message tagger function to handle state changes to a popover

-}
onHover : State -> (State -> msg) -> List (Html.Attribute msg)
onHover state toMsg =
    [ class "popover-trigger"
    , Html.Events.on "mouseenter" <| toggleState state toMsg
    , Html.Events.on "mouseleave" <| forceClose state toMsg
    ]


forceClose : State -> (State -> a) -> Json.Decoder a
forceClose (State state) toMsg =
    Json.succeed <|
        toMsg <|
            State { state | isActive = False }


toggleState : State -> (State -> msg) -> Json.Decoder msg
toggleState (State ({ isActive } as state)) toMsg =
    stateDecoder
        |> Json.andThen
            (\v ->
                Json.succeed <|
                    toMsg <|
                        if not isActive then
                            State
                                { isActive = True
                                , domState = v
                                }

                        else
                            State { state | isActive = False }
            )


{-| Creates a default view config for a popover

  - `triggerElement` - The element that will trigger the popover

-}
config : Html.Html msg -> Config msg
config triggerElement =
    Config
        { triggerElement = triggerElement
        , direction = Top
        , title = Nothing
        , content = Nothing
        }


{-| Define the popover body content.
-}
content :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
content attributes children (Config conf) =
    Config
        { conf
            | content =
                Html.div (class "popover-body" :: attributes) children
                    |> Content
                    |> Just
        }


{-| Define a popover title.

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
title :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
title =
    titlePrivate Html.div


{-| Define a popover h1 title.

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
titleH1 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titleH1 =
    titlePrivate Html.h1


{-| Define a popover h2 title.

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
titleH2 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titleH2 =
    titlePrivate Html.h2


{-| Define a popover h3 title.

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
titleH3 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titleH3 =
    titlePrivate Html.h3


{-| Define a popover h4 title.

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
titleH4 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titleH4 =
    titlePrivate Html.h4


{-| Define a popover h5 title.

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
titleH5 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titleH5 =
    titlePrivate Html.h5


{-| Define a popover h6 title.

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
titleH6 :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titleH6 =
    titlePrivate Html.h6


titlePrivate :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
titlePrivate elemFn attributes children (Config conf) =
    Config
        { conf
            | title =
                elemFn (class "popover-header" :: attributes) children
                    |> Title
                    |> Just
        }


{-| Show popover to the right of the triggering element.
-}
right : Config msg -> Config msg
right (Config conf) =
    Config { conf | direction = Right }


{-| Show popover to the left of the triggering element.
-}
left : Config msg -> Config msg
left (Config conf) =
    Config { conf | direction = Left }


{-| Show popover above the triggering element.
-}
top : Config msg -> Config msg
top (Config conf) =
    Config { conf | direction = Top }


{-| Show popover below the triggering element.
-}
bottom : Config msg -> Config msg
bottom (Config conf) =
    Config { conf | direction = Bottom }


stateDecoder : Json.Decoder DOMState
stateDecoder =
    Json.map3 DOMState
        (trigger [ "target" ])
        (popper [ "target" ] DomHelper.offsetWidth)
        (popper [ "target" ] DomHelper.offsetHeight)


trigger : List String -> Json.Decoder DomHelper.Area
trigger path =
    Json.oneOf
        [ Json.at path isTrigger
            |> Json.andThen
                (\res ->
                    if res then
                        Json.at path DomHelper.boundingArea

                    else
                        Json.fail ""
                )
        , Json.at (path ++ [ "parentElement" ]) DomHelper.className
            |> Json.andThen
                (\_ -> trigger (path ++ [ "parentElement" ]))
        , Json.fail "No trigger found"
        ]


isTrigger : Json.Decoder Bool
isTrigger =
    DomHelper.className
        |> Json.andThen
            (\class ->
                if String.contains "popover-trigger" class then
                    Json.succeed True

                else
                    Json.succeed False
            )


popper : List String -> Json.Decoder a -> Json.Decoder a
popper path decoder =
    Json.oneOf
        [ Json.at (path ++ [ "nextSibling" ]) isPopover
            |> Json.andThen
                (\res ->
                    if res then
                        Json.at (path ++ [ "nextSibling" ]) decoder

                    else
                        Json.fail ""
                )
        , Json.at (path ++ [ "parentElement" ]) DomHelper.className
            |> Json.andThen
                (\_ -> popper (path ++ [ "parentElement" ]) decoder)
        , Json.fail "No popover found"
        ]


isPopover : Json.Decoder Bool
isPopover =
    DomHelper.className
        |> Json.andThen
            (\class ->
                if String.contains "popover" class then
                    Json.succeed True

                else
                    Json.succeed False
            )


calculatePos : Position -> DOMState -> Pos
calculatePos pos { rect, offsetWidth, offsetHeight } =
    case pos of
        Left ->
            { left = -offsetWidth - 10
            , top = (rect.height / 2) - (offsetHeight / 2)
            , arrowTop = Just <| (offsetHeight / 2) - 12
            , arrowLeft = Nothing
            }

        Right ->
            { left = rect.width
            , top = (rect.height / 2) - (offsetHeight / 2)
            , arrowTop = Just <| (offsetHeight / 2) - 12
            , arrowLeft = Nothing
            }

        Top ->
            { left = (rect.width / 2) - (offsetWidth / 2)
            , top = -offsetHeight - 10
            , arrowTop = Nothing
            , arrowLeft = Just <| (offsetWidth / 2) - 12
            }

        Bottom ->
            { left = (rect.width / 2) - (offsetWidth / 2)
            , top = rect.height
            , arrowTop = Nothing
            , arrowLeft = Just <| (offsetWidth / 2) - 12
            }
