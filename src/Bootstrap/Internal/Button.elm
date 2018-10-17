module Bootstrap.Internal.Button exposing
    ( Option(..)
    , Role(..)
    , RoledButton(..)
    , buttonAttributes
    )

import Bootstrap.General.Internal exposing (ScreenSize(..), screenSizeOption)
import Html
import Html.Attributes as Attributes exposing (class, classList)


type Option msg
    = Size ScreenSize
    | Coloring RoledButton
    | Block
    | Disabled Bool
    | Attrs (List (Html.Attribute msg))


type RoledButton
    = Roled Role
    | Outlined Role


type Role
    = Primary
    | Secondary
    | Success
    | Info
    | Warning
    | Danger
    | Dark
    | Light
    | Link


type alias Options msg =
    { coloring : Maybe RoledButton
    , block : Bool
    , disabled : Bool
    , size : Maybe ScreenSize
    , attributes : List (Html.Attribute msg)
    }


buttonAttributes : List (Option msg) -> List (Html.Attribute msg)
buttonAttributes modifiers =
    let
        options =
            List.foldl applyModifier defaultOptions modifiers
    in
    [ classList
        [ ( "btn", True )
        , ( "btn-block", options.block )
        , ( "disabled", options.disabled )
        ]
    , Attributes.disabled options.disabled
    ]
        ++ (case options.size |> Maybe.andThen screenSizeOption of
                Just s ->
                    [ class <| "btn-" ++ s ]

                Nothing ->
                    []
           )
        ++ (case options.coloring of
                Just (Roled role) ->
                    [ class <| "btn-" ++ roleClass role ]

                Just (Outlined role) ->
                    [ class <| "btn-outline-" ++ roleClass role ]

                Nothing ->
                    []
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { coloring = Nothing
    , block = False
    , disabled = False
    , size = Nothing
    , attributes = []
    }


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Size size ->
            { options | size = Just size }

        Coloring coloring ->
            { options | coloring = Just coloring }

        Block ->
            { options | block = True }

        Disabled val ->
            { options | disabled = val }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }


roleClass : Role -> String
roleClass role =
    case role of
        Primary ->
            "primary"

        Secondary ->
            "secondary"

        Success ->
            "success"

        Info ->
            "info"

        Warning ->
            "warning"

        Danger ->
            "danger"

        Dark ->
            "dark"

        Light ->
            "light"

        Link ->
            "link"
