module Bootstrap.Alert
    exposing
        ( view
        , shown
        , closed
        , config
        , Config
        , Visibility
        , primary
        , secondary
        , success
        , info
        , warning
        , danger
        , light
        , dark
        , children
        , link
        , p
        , text
        , customElement
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        , dismissable
        , dismissableWithAnimation
        , subscriptions
        , Child
        )

{-| Provide contextual feedback messages for typical user actions with the handful of available and flexible alert messages.


    Alert.config
        |> Alert.info
        |> Alert.children
            [ Alert.h4 [] [ text "Alert heading" ]
            , Alert.text "This info message has a "
            , Alert.link [ href "javascript:void()" ] [ text "link" ]
            , Alert.p [] [ text "Followed by a paragraph behaving as you'd expect." ]
            ]
        |> Alert.view Alert.shown

# Configuring
@docs config, view, shown, closed, Visibility, Config



# Child elements
@docs children, link, p, text, customElement, h1, h2, h3, h4, h5, h6, Child


# Config options

## Contextual alerts
@docs primary, secondary, success, info, warning, danger, light, dark


## Dismiss with/without Animation
@docs dismissable, dismissableWithAnimation, subscriptions

-}

import AnimationFrame
import Html
import Html.Attributes exposing (class, classList, type_, attribute, style)
import Html.Events exposing (onClick, on)
import Json.Decode as Decode
import Bootstrap.Internal.Role as Role exposing (Role(..))


{-| Opaque type used for describing the configuration of an alert.
-}
type Config msg
    = Config (ConfigRec msg)


type alias ConfigRec msg =
    { visibility : Visibility
    , dismissable : Maybe (Visibility -> msg)
    , attributes : List (Html.Attribute msg)
    , children : List (Child msg)
    , role : Role
    , withAnimation : Bool
    }


{-| Opaque type representing a child element for an alert.
-}
type Child msg
    = Child (Html.Html msg)


{-| Opaque type used to represent whether to display the alert or not.
-}
type Visibility
    = Shown
    | StartClose
    | FadeClose
    | Closed


{-| Use this function to represent the shown state for an alert.
-}
shown : Visibility
shown =
    Shown


{-| Use this function to represent the closed/dismissed state for an alert.
-}
closed : Visibility
closed =
    Closed


{-| Create a default config for an alert.
-}
config : Config msg
config =
    Config <|
        { visibility = Shown
        , dismissable = Nothing
        , attributes = []
        , children = []
        , role = Secondary
        , withAnimation = False
        }


{-| Alert using primary colors.
-}
primary : Config msg -> Config msg
primary config =
    role Primary config


{-| Alert using secondary colors.
-}
secondary : Config msg -> Config msg
secondary config =
    role Secondary config


{-| Alert using success colors.
-}
success : Config msg -> Config msg
success config =
    role Success config


{-| Alert using info colors.
-}
info : Config msg -> Config msg
info config =
    role Info config


{-| Alert using warning colors.
-}
warning : Config msg -> Config msg
warning config =
    role Warning config


{-| Alert using danger colors.
-}
danger : Config msg -> Config msg
danger config =
    role Danger config


{-| Alert using dark colors.
-}
dark : Config msg -> Config msg
dark config =
    role Dark config


{-| Alert using light colors.
-}
light : Config msg -> Config msg
light config =
    role Light config


role : Role -> Config msg -> Config msg
role role (Config configRec) =
    Config <|
        { configRec | role = role }


{-| Customize the alert with std Elm Html Attributes.
-}
attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs attributes (Config configRec) =
    Config <|
        { configRec | attributes = attributes }


{-| Make the alert dismissable. Adds a close icon top right.
You'll need to handle the msg in your update function.

    type Msg
        = AlertMsg Alert.Visibilty

    -- somewhere in your view function where you display the alert
    Alert.config
        |> Alert.dismissable AlertMsg
        |> ... etc

-}
dismissable : (Visibility -> msg) -> Config msg -> Config msg
dismissable dismissMsg (Config configRec) =
    Config <|
        { configRec | dismissable = Just dismissMsg }


{-| Enable a fade out animation when closing/dismissing an Alert.
-}
dismissableWithAnimation : (Visibility -> msg) -> Config msg -> Config msg
dismissableWithAnimation dismissMsg (Config configRec) =
    Config <|
        { configRec | dismissable = Just dismissMsg, withAnimation = True }


{-| Add child elements to the alert.
-}
children : List (Child msg) -> Config msg -> Config msg
children children (Config configRec) =
    Config <|
        { configRec | children = children }


{-| Call the view function to turn an alert config into an Elm Html element.

* `visibility` The current visibility for the alert.
* `config` Configuration settings and child elements for your alert.
-}
view : Visibility -> Config msg -> Html.Html msg
view visibility (Config configRec) =
    Html.div
        (viewAttributes visibility configRec)
        (List.map (\(Child e) -> e) configRec.children
            |> maybeAddDismissButton visibility configRec
        )


viewAttributes : Visibility -> ConfigRec msg -> List (Html.Attribute msg)
viewAttributes visibility configRec =
    [ Html.Attributes.attribute "role" "alert"
    , classList
        [ ( "alert", True )
        , ( "alert-dismissible", isDismissable configRec )
        , ( "fade", configRec.withAnimation )
        , ( "show", visibility == Shown )
        ]
    , Role.toClass "alert" configRec.role
    ]
        ++ if visibility == Closed then
            [ style [ ( "display", "none" ) ] ]
           else
            []
                ++ if configRec.withAnimation then
                    case configRec.dismissable of
                        Just dismissMsg ->
                            [ on "transitionend" (Decode.succeed (dismissMsg Closed)) ]

                        Nothing ->
                            []
                   else
                    []


maybeAddDismissButton : Visibility -> ConfigRec msg -> List (Html.Html msg) -> List (Html.Html msg)
maybeAddDismissButton visibilty configRec children =
    if isDismissable configRec then
        injectButton
            (Html.button
                ([ type_ "button", class "close", attribute "aria-label" "close" ]
                    ++ clickHandler visibilty configRec
                )
                [ Html.span [ attribute "aria-hidden" "true" ] [ Html.text "×" ] ]
            )
            children
    else
        children


injectButton : Html.Html msg -> List (Html.Html msg) -> List (Html.Html msg)
injectButton btn children =
    case children of
        head :: tail ->
            head :: btn :: tail

        [] ->
            [ btn ]


clickHandler : Visibility -> ConfigRec msg -> List (Html.Attribute msg)
clickHandler visibility configRec =
    let
        handleClick viz toMsg =
            onClick <| toMsg viz
    in
        case configRec.dismissable of
            Just dismissMsg ->
                [ if configRec.withAnimation then
                    handleClick StartClose dismissMsg
                  else
                    handleClick Closed dismissMsg
                ]

            Nothing ->
                []


isDismissable : ConfigRec msg -> Bool
isDismissable configRec =
    case configRec.dismissable of
        Just _ ->
            True

        Nothing ->
            False


{-| To get proper link colors for `a` elements use this function

* `attributes` List of attributes for the link element
* `children` List of child elements

-}
link : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
link attributes children =
    Child <|
        Html.a
            (class "alert-link" :: attributes)
            children


{-| Shorthand to create an Html.text element

* `txt` Content string
-}
text : String -> Child msg
text text =
    Child <|
        Html.text text


{-| Shorthand to create an alert paragraph child element

* `attributes` List of attributes for the link element
* `children` List of child elements

-}
p : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
p attributes children =
    Child <|
        Html.p
            attributes
            children


{-| Add any html element as a child element to an alert

* `element` Element that should be a child in an alert
-}
customElement : Html.Html msg -> Child msg
customElement elem =
    Child elem


{-| Alert h1 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h1 : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
h1 attributes children =
    headingPrivate Html.h1 attributes children


{-| Alert h2 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
h2 attributes children =
    headingPrivate Html.h2 attributes children


{-| Alert h3 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h3 : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
h3 attributes children =
    headingPrivate Html.h3 attributes children


{-| Alert h3 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h4 : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
h4 attributes children =
    headingPrivate Html.h4 attributes children


{-| Alert h5 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h5 : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
h5 attributes children =
    headingPrivate Html.h5 attributes children


{-| Alert h6 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h6 : List (Html.Attribute msg) -> List (Html.Html msg) -> Child msg
h6 attributes children =
    headingPrivate Html.h6 attributes children


headingPrivate :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Child msg
headingPrivate elemFn attributes children =
    Child <|
        elemFn
            (class "alert-header" :: attributes)
            children


{-| Subscription for handling animations. Don't forget this when configuring your alert to be dismissable with animation.

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Alert.subscriptions model.alertVisibility AlertMsg

-}
subscriptions : Visibility -> (Visibility -> msg) -> Sub msg
subscriptions visibility animateMsg =
    case visibility of
        StartClose ->
            AnimationFrame.times (\_ -> animateMsg FadeClose)

        _ ->
            Sub.none
