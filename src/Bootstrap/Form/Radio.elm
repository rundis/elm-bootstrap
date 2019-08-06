module Bootstrap.Form.Radio exposing
    ( radio, custom, advancedRadio, advancedCustom, label, Label
    , id, checked, name, inline, onClick, disabled, attrs, Option
    , success, danger
    , radioList, create, createCustom, createAdvanced, createCustomAdvanced, Radio
    )

{-| This module allows you to create Bootstrap styled radios.


# Creating

@docs radio, custom, advancedRadio, advancedCustom, label, Label


# Options

@docs id, checked, name, inline, onClick, disabled, attrs, Option


# Validation

@docs success, danger


# Composing

@docs radioList, create, createCustom, createAdvanced, createCustomAdvanced, Radio

-}

import Bootstrap.Form.FormInternal as FormInternal
import Html
import Html.Attributes as Attributes
import Html.Events as Events


{-| Opaque composable type representing a Radio.
-}
type Radio msg
    = Radio
        { options : List (Option msg)
        , label : Label msg
        }


{-| Opaque type representing a Radio label.
-}
type Label msg
    = Label
        { attributes : List (Html.Attribute msg)
        , children : List (Html.Html msg)
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
        "My radio"

-}
radio : List (Option msg) -> String -> Html.Html msg
radio options label_ =
    create options label_ |> view


{-| Create a single radio input with customized Bootstrap styling.

    Radio.custom
        [ Radio.id "myCustomRadio"
        , Radio.checked True
        , Radio.onClick MyRadioMsg
        ]
        "My custom radio"

-}
custom : List (Option msg) -> String -> Html.Html msg
custom options label_ =
    createCustom options label_ |> view


{-| Create a label for a radio when using advancedRadio or advancedCustom

    Radio.label [ style "font-size" "24px" ] [ div [ class "disclaimer" ] [ text "My disclaimer" ] ]

-}
label : List (Html.Attribute msg) -> List (Html.Html msg) -> Label msg
label attributes children =
    Label
        { attributes = attributes, children = children }


{-| Create a radio element with customized label

    Radio.advancedRadio
        [ Radio.id "myChk"
        , Radio.checked True
        , Radio.onCheck MyRadioMsg
        ]
        (Radio.label [ class "mylabelclass" ] [ text "Hello" ])

-}
advancedRadio : List (Option msg) -> Label msg -> Html.Html msg
advancedRadio options label_ =
    createAdvanced options label_ |> view


{-| Create a radio element with customized label

    Radio.advancedCustom
        [ Radio.id "myChk"
        , Radio.checked True
        , Radio.onCheck MyRadioMsg
        ]
        (Radio.label [ class "mylabelclass" ] [ text "Hello" ])

-}
advancedCustom : List (Option msg) -> Label msg -> Html.Html msg
advancedCustom options label_ =
    createCustomAdvanced options label_ |> view


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

  - `groupName` - Name of the radios, all radios will get the same name
  - `radios` - List of radios.

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
create options label_ =
    createAdvanced options (label [] [ Html.text label_ ])


{-| Create a composable radio with customized label for use in a [`radioList`](#radioList)
-}
createAdvanced : List (Option msg) -> Label msg -> Radio msg
createAdvanced options label_ =
    Radio
        { options = options
        , label = label_
        }


{-| Create a composable custom radio for use in a [`radioList`](#radioList)
-}
createCustom : List (Option msg) -> String -> Radio msg
createCustom options =
    create (Custom :: options)


{-| Create a composable custom radio with customized label for use in a [`radioList`](#radioList)
-}
createCustomAdvanced : List (Option msg) -> Label msg -> Radio msg
createCustomAdvanced options =
    createAdvanced (Custom :: options)


addOption : Option msg -> Radio msg -> Radio msg
addOption opt (Radio ({ options } as radio_)) =
    Radio { radio_ | options = opt :: options }


view : Radio msg -> Html.Html msg
view (Radio radio_) =
    let
        opts =
            List.foldl applyModifier defaultOptions radio_.options

        (Label label_) =
            radio_.label
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
            (label_.attributes
                ++ [ Attributes.classList
                        [ ( "form-check-label", not opts.custom )
                        , ( "custom-control-label", opts.custom )
                        ]
                   ]
                ++ (case opts.id of
                        Just v ->
                            [ Attributes.for v ]

                        Nothing ->
                            []
                   )
            )
            label_.children
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
disabled disabled_ =
    Disabled disabled_


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
name name_ =
    Name name_


{-| Use this function to handle any Html.Attribute option you wish for your radio
-}
attrs : List (Html.Attribute msg) -> Option msg
attrs attrs_ =
    Attrs attrs_


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

        Attrs attrs_ ->
            { options | attributes = options.attributes ++ attrs_ }


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
