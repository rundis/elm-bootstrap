module Bootstrap.Form.Fieldset
    exposing
        ( view
        , config
        , asGroup
        , disabled
        , children
        , attrs
        , legend
        , Config
        )

{-| Fieldset is a handy block level element you can use to group form elements.
Fieldset comes with the added benefit of disabling all child controls when we set it's disabled attribute.


-}

import Html
import Html.Attributes as Attributes exposing (classList)


type Config msg
    = Config (ConfigRec msg)


type alias ConfigRec msg =
    { options : Options msg
    , legend : Maybe (Html.Html msg)
    , children : List (Html.Html msg)
    }


type alias Options msg =
    { isGroup : Bool
    , disabled : Bool
    , attributes : List (Html.Attribute msg)
    }


{-| Create default config for a fieldset
-}
config : Config msg
config =
    Config
        { options =
            { isGroup = False
            , disabled = False
            , attributes = []
            }
        , legend = Nothing
        , children = []
        }


asGroup : Config msg -> Config msg
asGroup =
    mapOptions (\opts -> { opts | isGroup = True })


disabled : Bool -> Config msg -> Config msg
disabled isDisabled =
    mapOptions (\opts -> { opts | disabled = isDisabled })


attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs attrs =
    mapOptions (\opts -> { opts | attributes = opts.attributes ++ attrs })


legend :
    List (Html.Attribute msg)
    -> List (Html.Html msg)
    -> Config msg
    -> Config msg
legend attributes children =
    mapConfig
        (\conf ->
            { conf | legend = Just <| Html.legend attributes children }
        )


children :
    List (Html.Html msg)
    -> Config msg
    -> Config msg
children children =
    mapConfig (\conf -> { conf | children = children })


view : Config msg -> Html.Html msg
view (Config { options, legend, children }) =
    Html.fieldset
        ([ classList [ ( "form-group", options.isGroup ) ]
         , Attributes.disabled options.disabled
         ]
            ++ options.attributes
        )
        ( Maybe.map (\e -> [ e ]) legend
            |> Maybe.withDefault []
            |> (flip List.append) children
        )


mapConfig :
    (ConfigRec msg -> ConfigRec msg)
    -> Config msg
    -> Config msg
mapConfig mapper (Config configRec) =
    mapper configRec |> Config


mapOptions :
    (Options msg -> Options msg)
    -> Config msg
    -> Config msg
mapOptions mapper (Config ({ options } as config)) =
    { config | options = mapper options } |> Config
