module Bootstrap.Form.Radio
    exposing
        ( radio
        , custom
        , radioList
        , create
        , createCustom
        , checked
        , name
        , inline
        , disabled
        , onClick
        , attrs
        , success
        , danger
        , id
        , Option
        , Radio
        )

{-| This module allows you to create Bootstrap styled radios.


# Creating
@docs radio, custom, Radio

# Options
@docs id, checked, name, inline, onClick, disabled, attrs, Option


# Validation
@docs success, danger

# Composing
@docs radioList, create, createCustom, Radio

-}

import Html
import Html.Attributes as Attributes
import Html.Events as Events
import Bootstrap.Form.FormInternal as FormInternal


{-| Opaque composable type representing a Radio.
-}
type Radio msg
    = Radio
        { options : List (Option msg)
        , label : String
        }


{-| Opaque type representing valid customization options for a radio
-}
type Option msg
    = Id String
    | Checked Bool
    | Inline
    | Name String
    | OnClick msg
    | Custom
    | Disabled Bool
    | Validation FormInternal.Validation
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { id : Maybe String
    , checked : Bool
    , name : Maybe String
    , custom : Bool
    , disabled : Bool
    , inline : Bool
    , onClick : Maybe msg
    , validation : Maybe FormInternal.Validation
    , attributes : List (Html.Attribute msg)
    }


{-| Create a single radio input.

    Radio.radio
        [ Radio.id "myRadio"
        , Radio.checked True
        , Radio.onClick MyRadioMsg
        ]

-}
radio : List (Option msg) -> String -> Html.Html msg
radio options label =
    create options label |> view


{-| Create a single radio input with customized Bootstrap styling.

    Radio.custom
        [ Radio.id "myCustomRadio"
        , Radio.checked True
        , Radio.onClick MyRadioMsg
        ]

-}
custom : List (Option msg) -> String -> Html.Html msg
custom options label =
    createCustom options label |> view


{-| In most cases you would probably create multiple radios as a group.
This function is a convenient helper to create a list of radios

    -- You might have defined a single message for all your radios like this
    type Msg
        = MyRadioMsg MyRadio Bool

    type MyRadio
        = Radio1
        | Radio2
        | Radio3


    -- In some view function your could create a radio list as follows

    Radio.radioList "myradios"
        [ Radio.create
            [ Radio.id "myRadio1", Radio.onCheck (MyRadioMsg MyRadio1) ]
            "Radio 1"
        , Radio.create
            [ Radio.id "myRadio2", Radio.onCheck (MyRadioMsg MyRadio2) ]
            "Radio 2"
        , Radio.create
            [ Radio.id "myRadio3", Radio.onCheck (MyRadioMsg MyRadio3) ]
            "Radio 3"
        ]


* `groupName` - Name of the radios, all radios will get the same name
* `radios` - List of radios.
-}
radioList :
    String
    -> List (Radio msg)
    -> List (Html.Html msg)
radioList groupName radios =
    List.map
        (view << (addOption <| name groupName))
        radios


{-| Create a composable radio for use in a [`radioList`](#radioList)
-}
create : List (Option msg) -> String -> Radio msg
create options label =
    Radio
        { options = options
        , label = label
        }


{-| Create a composable custom radio for use in a [`radioList`](#radioList)
-}
createCustom : List (Option msg) -> String -> Radio msg
createCustom options =
    create (Custom :: options)


addOption : Option msg -> Radio msg -> Radio msg
addOption opt (Radio ({ options } as radio)) =
    Radio { radio | options = opt :: options }


view : Radio msg -> Html.Html msg
view (Radio radio) =
    let
        opts =
            List.foldl applyModifier defaultOptions radio.options

    in
        Html.div
            [ Attributes.classList
                [ ( "form-check", not opts.custom )
                , ( "form-check-inline", not opts.custom && opts.inline )
                , ( "custom-control", opts.custom )
                , ( "custom-radio", opts.custom )
                , ( "custom-control-inline", opts.inline && opts.custom )
                ]
            ]
            [ Html.input (toAttributes opts) []
            , Html.label
                ([ Attributes.classList
                    [ ( "form-check-label", not opts.custom )
                    , ( "custom-control-label", opts.custom )
                    ]
                 ]
                    ++ case opts.id of
                        Just v ->
                            [ Attributes.for v ]

                        Nothing ->
                            []
                )
                [ Html.text radio.label ]
            ]



{-| Shorthand for assigning an onClick handler for a radio.
-}
onClick : msg -> Option msg
onClick toMsg =
    OnClick toMsg


{-| Option to toggle the radio checked property on off.
-}
checked : Bool -> Option msg
checked isCheck =
    Checked isCheck


{-| Option to disable the radio
-}
disabled : Bool -> Option msg
disabled disabled =
    Disabled disabled


{-| Use this option to display radios inline.
-}
inline : Option msg
inline =
    Inline


{-| Option to set the name of a radio.

A single radio doesn't make much sense, typically you would have several. To automatically
unselect one radio, when selecting another you need to have the same name for each radio in a group.
-}
name : String -> Option msg
name name =
    Name name


{-| Use this function to handle any Html.Attribute option you wish for your radio
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs =
    Attrs attrs


{-| Set the id for the radio. Will automatically set the for attribute for the label

NOTE: You have to use this for custom checkboxes.

-}
id : String -> Option msg
id theId =
    Id theId



{-| Option to color a radio with success.
-}
success : Option msg
success =
    Validation FormInternal.Success


{-| Option to color a radio with danger.
-}
danger : Option msg
danger =
    Validation FormInternal.Danger


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
        Id val ->
            { options | id = Just val }

        Checked val ->
            { options | checked = val }

        Name val ->
            { options | name = Just val }

        Inline ->
            { options | inline = True }

        OnClick toMsg ->
            { options | onClick = Just toMsg }

        Custom ->
            { options | custom = True }

        Disabled val ->
            { options | disabled = val }

        Validation validation ->
            { options | validation = Just validation }

        Attrs attrs ->
            { options | attributes = options.attributes ++ attrs }


toAttributes : Options msg -> List (Html.Attribute msg)
toAttributes options =
    [ Attributes.classList
        [ ( "form-check-input", not options.custom )
        , ( "custom-control-input", options.custom )
        ]
    , Attributes.type_ "radio"
    , Attributes.disabled options.disabled
    , Attributes.checked options.checked
    ]
        ++ ([ Maybe.map Events.onClick options.onClick
            , Maybe.map Attributes.name options.name
            , Maybe.map Attributes.id options.id
            ]
                |> List.filterMap identity
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { id = Nothing
    , checked = False
    , name = Nothing
    , custom = False
    , inline = False
    , disabled = False
    , onClick = Nothing
    , validation = Nothing
    , attributes = []
    }
