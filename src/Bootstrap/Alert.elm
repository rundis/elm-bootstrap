module Bootstrap.Alert
    exposing
        ( view
        , shown
        , closed
        , config
        , Config
        , Visibility
        , simplePrimary
        , simpleSecondary
        , simpleSuccess
        , simpleInfo
        , simpleWarning
        , simpleDanger
        , simpleLight
        , simpleDark
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
        , h1
        , h2
        , h3
        , h4
        , h5
        , h6
        , dismissable
        , dismissableWithAnimation
        , subscriptions
        )

{-| Provide contextual feedback messages for typical user actions with the handful of available and flexible alert messages.


# Simple alerts
When you just need a simple alert, these shorthand functions lets you quickly display an alert.

```elm
    simplePrimary [] [ text "I'm a simple alert!" ]

    simpleWarning
        [ class "myCustomAlertClass" ]
        [ Alert.h1 [] [ text "Alert heading" ]
        , p [] [ text "Some alert content." ]
        , Alert.link [ href "#somewhere" ] [ text "Styled link" ]
        ]
```

@docs simplePrimary, simpleSecondary, simpleSuccess, simpleInfo, simpleWarning, simpleDanger, simpleLight, simpleDark

## Helpers
These functions allow you to create alert children with alert specific styling
@docs link, h1, h2, h3, h4, h5, h6


# Dismissable alerts
Dismissable alerts are also supported. You can even configure them to have a fade out animation when dismissed.
Unlike it's Twitter Bootstrap JavaScript counterpart we can't remove the alert element from the DOM. It's simply set to **display:none**.
To support dismissable alerts you must keep track of the alerts visibility in your model.



    type alias Model =
        { alertVisibility : Alert.Visibility }

    type Msg
        = AlertMsg Alert.Visibility

    init : (Model, Cmd Msg)
    init =
        ( { alertVisibility : Alert.shownn} )

    update : Msg -> Model -> ( Model, Cmd Msg )
    update msg model =
        case msg of
            AlertMsg visibility ->
                ( { model | alertVisibility = visibility }, Cmd.none )

    view : Model -> Html Msg
    view model =
        Alert.config
            |> Alert.dismissableWithAnimation AlertMsg
            |> Alert.info
            |> Alert.children
                [ Alert.h4 [] [ text "Alert heading" ]
                , Alert.text "This info message has a "
                , Alert.link [ href "javascript:void()" ] [ text "link" ]
                , Alert.p [] [ text "Followed by a paragraph behaving as you'd expect." ]
                ]
            |> Alert.view model.alertVisibility


    -- Subscriptions are only needed when you choose to use dismissableWithAnimation

    subscriptions : Model -> Sub Msg
    subscriptions model =
        Alert.subscriptions model.alertVisibility AlertMsg


## Configure
@docs config, view, children, Config

## Visibility
@docs shown, closed, Visibility

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
    , children : List (Html.Html msg)
    , role : Role
    , withAnimation : Bool
    }


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


{-| Show an elert using primary color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simplePrimary : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simplePrimary =
    simple Primary


{-| Show an elert using secondary color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simpleSecondary : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simpleSecondary =
    simple Secondary


{-| Show an elert using success color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simpleSuccess : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simpleSuccess =
    simple Success


{-| Show an elert using info color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simpleInfo : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simpleInfo =
    simple Info


{-| Show an elert using warning color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simpleWarning : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simpleWarning =
    simple Warning


{-| Show an elert using danger color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simpleDanger : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simpleDanger =
    simple Danger


{-| Show an elert using dark color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simpleDark : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simpleDark =
    simple Dark


{-| Show an elert using light color.

* `attributes` - List of attributes to customize the alert container
* `children` - List of child html elements
-}
simpleLight : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simpleLight =
    simple Light


simple : Role -> List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
simple role_ attributes children_ =
    (role role_ config)
        |> attrs attributes
        |> children children_
        |> view Shown


{-| Configure alert to use primary colors.
-}
primary : Config msg -> Config msg
primary config =
    role Primary config


{-| Configure alert to use secondary colors.
-}
secondary : Config msg -> Config msg
secondary config =
    role Secondary config


{-| Configure alert to use success colors.
-}
success : Config msg -> Config msg
success config =
    role Success config


{-| Configure alert to use info colors.
-}
info : Config msg -> Config msg
info config =
    role Info config


{-| Configure alert to use warning colors.
-}
warning : Config msg -> Config msg
warning config =
    role Warning config


{-| Configure alert to use danger colors.
-}
danger : Config msg -> Config msg
danger config =
    role Danger config


{-| Configure alert to use dark colors.
-}
dark : Config msg -> Config msg
dark config =
    role Dark config


{-| Configure alert to use light colors.
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


{-| Configure child elements for the alert.
-}
children : List (Html.Html msg) -> Config msg -> Config msg
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
        (configRec.children
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
link : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
link attributes children =
    Html.a
        (class "alert-link" :: attributes)
        children


{-| Alert h1 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h1 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h1 attributes children =
    headingPrivate Html.h1 attributes children


{-| Alert h2 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h2 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h2 attributes children =
    headingPrivate Html.h2 attributes children


{-| Alert h3 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h3 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h3 attributes children =
    headingPrivate Html.h3 attributes children


{-| Alert h3 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h4 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h4 attributes children =
    headingPrivate Html.h4 attributes children


{-| Alert h5 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h5 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h5 attributes children =
    headingPrivate Html.h5 attributes children


{-| Alert h6 header with appropriate color styling

* `attributes` List of attributes
* `children` List of child elements

-}
h6 : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
h6 attributes children =
    headingPrivate Html.h6 attributes children


headingPrivate :
    (List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg)
    -> List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Html.Html msg
headingPrivate elemFn attributes children =
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
