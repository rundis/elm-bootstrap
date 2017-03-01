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
        , Option
        , Radio
        )

{-| This module allows you to create Bootstrap styled radios.


# Creating
@docs radio, custom, Radio

# Options
@docs checked, name, inline, onClick, disabled, attrs, Option


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
    = Checked Bool
    | Inline
    | Name String
    | OnClick msg
    | Custom
    | Disabled Bool
    | Validation FormInternal.Validation
    | Attrs (List (Html.Attribute msg))


type alias Options msg =
    { checked : Bool
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
        [ Radio.checked True
        , Radio.onClick MyRadioMsg
        ]

-}
radio : List (Option msg) -> String -> Html.Html msg
radio options label =
    create options label |> view


{-| Create a single radio input with customized Bootstrap styling.

    Radio.custom
        [ Radio.checked True
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
        [ Radio.create [ Radio.onCheck (MyRadioMsg MyRadio1) ] "Radio 1"
        , Radio.create [ Radio.onCheck (MyRadioMsg MyRadio2) ] "Radio 2"
        , Radio.create [ Radio.onCheck (MyRadioMsg MyRadio3) ] "Radio 3"
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
        ( view << (addOption <| name groupName ))
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
addOption opt (Radio ({options} as radio) ) =
    Radio { radio | options = opt :: options }



view : Radio msg -> Html.Html msg
view (Radio radio) =
    let
        opts =
            List.foldl applyModifier defaultOptions radio.options

        validationAttrs =
            case opts.validation of
                Just validation ->
                    [ FormInternal.validationWrapperAttribute validation ]

                Nothing ->
                    []
    in
        if opts.custom then
            Html.div
                ([ Attributes.classList
                    [ ( "custom-controls-stacked", not opts.inline )
                    , ( "d-inline-block", opts.inline )
                    ]
                 ]
                    ++ validationAttrs
                )
                [ Html.label
                    ([ Attributes.class "custom-control custom-radio" ]
                        ++ validationAttrs
                    )
                    [ Html.input (toAttributes opts) []
                    , Html.span [ Attributes.class "custom-control-indicator" ] []
                    , Html.span
                        [ Attributes.class "custom-control-description" ]
                        [ Html.text radio.label ]
                    ]
                ]
        else
            Html.div
                [ Attributes.classList
                    [ ( "form-check", True )
                    , ( "form-check-inline", opts.inline )
                    , ( "disabled", opts.disabled )
                    ]
                ]
                [ Html.label
                    [ Attributes.class "form-check-label" ]
                    [ Html.input (toAttributes opts) []
                    , Html.text <| " " ++ radio.label
                      -- ugly hack to provide left spacing
                    ]
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


{-| Option to color a radio with success.
-}
success : Option msg
success =
    Validation FormInternal.Success


{-| Option to color a radio with warning.
-}
warning : Option msg
warning =
    Validation FormInternal.Warning


{-| Option to color a radio with danger.
-}
danger : Option msg
danger =
    Validation FormInternal.Danger


applyModifier : Option msg -> Options msg -> Options msg
applyModifier modifier options =
    case modifier of
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
    [ Attributes.class <|
        if options.custom then
            "custom-control-input"
        else
            "form-check-input"
    , Attributes.type_ "radio"
    , Attributes.disabled options.disabled
    , Attributes.checked options.checked
    ]
        ++ ([ Maybe.map Events.onClick options.onClick
            , Maybe.map Attributes.name options.name
            ]
                |> List.filterMap identity
           )
        ++ options.attributes


defaultOptions : Options msg
defaultOptions =
    { checked = False
    , name = Nothing
    , custom = False
    , inline = False
    , disabled = False
    , onClick = Nothing
    , validation = Nothing
    , attributes = []
    }
