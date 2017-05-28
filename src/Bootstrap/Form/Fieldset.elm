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

# General
@docs Config, view, config

# Customization
@docs asGroup, disabled, children, legend, attrs


-}

import Html
import Html.Attributes as Attributes exposing (classList)


{-| Opaque representation of the view configuration for a fieldset.
-}
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


{-| Make the fieldset a field group
-}
asGroup : Config msg -> Config msg
asGroup =
    mapOptions (\opts -> { opts | isGroup = True })


{-| Disable a fieldset
-}
disabled : Bool -> Config msg -> Config msg
disabled isDisabled =
    mapOptions (\opts -> { opts | disabled = isDisabled })


{-| When you need to customize a fieldset with standard Html.Attribute attributes use this function
-}
attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs attrs =
    mapOptions (\opts -> { opts | attributes = opts.attributes ++ attrs })


{-| Provide a legend for a set of fields
-}
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


{-| -}
children :
    List (Html.Html msg)
    -> Config msg
    -> Config msg
children children =
    mapConfig (\conf -> { conf | children = children })


{-| View a fieldset standalone. To create a fieldset you start off with a basic configuration which you can compose
of several optional elements.

    Fieldset.config
        |> Fieldset.asGroup
        |> Fieldset.legend [] [ text "Radio buttons" ]
        |> Fieldset.children
            ( Radio.radioList "myradios"
                [ Radio.create [] "Option one"
                , Radio.create [] "Option two"
                , Radio.create [ Radio.disabled True] "I'm disabled"
                ]
            )
        |> Fieldset.view
-}
view : Config msg -> Html.Html msg
view (Config { options, legend, children }) =
    Html.fieldset
        ([ classList [ ( "form-group", options.isGroup ) ]
         , Attributes.disabled options.disabled
         ]
            ++ options.attributes
        )
        (Maybe.map (\e -> [ e ]) legend
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
