module Bootstrap.Internal.Form
    exposing
        ( input
        , renderInput
        , select
        , selectItem
        , renderSelect
        , radio
        , renderRadio
        , addRadioAttribute
        , checkbox
        , Input
        , InputOption(..)
        , InputType(..)
        , Select
        , SelectItem
        , FormCheckOption(..)
        , Radio
        )

import Bootstrap.Internal.Grid as GridInternal
import Html
import Html.Attributes as Attr


type InputOption msg
    = InputSize GridInternal.ScreenSize
    | InputId String
    | InputAttr (Html.Attribute msg)


type alias Input msg =
    { options : List (InputOption msg) }


type InputType
    = Text
    | Password
    | DatetimeLocal
    | Date
    | Month
    | Time
    | Week
    | Number
    | Email
    | Url
    | Search
    | Tel
    | Color


type alias Select msg =
    { options : List (InputOption msg)
    , items : List (SelectItem msg)
    }


type SelectItem msg
    = SelectItem (Html.Html msg)


type FormCheckOption msg
    = CheckDisabled
    | CheckAttr (Html.Attribute msg)
    | CheckInline


type alias Radio msg =
    { textLabel : String
    , options : List (FormCheckOption msg)
    }



-- TEXT INPUTS


input : InputType -> List (InputOption msg) -> Input msg
input tipe options =
    { options = (inputTypeAttribute tipe) :: options }


renderInput : Input msg -> Html.Html msg
renderInput { options } =
    Html.input
        (inputAttributes options)
        []


inputAttributes : List (InputOption msg) -> List (Html.Attribute msg)
inputAttributes options =
    Attr.class "form-control"
        :: (List.map inputAttribute options
                |> List.filterMap identity
           )


inputAttribute : InputOption msg -> Maybe (Html.Attribute msg)
inputAttribute option =
    case option of
        InputSize size ->
            inputSizeOption size

        InputId id ->
            Just <| Attr.id id

        InputAttr attr ->
            Just attr


inputSizeOption : GridInternal.ScreenSize -> Maybe (Html.Attribute msg)
inputSizeOption size =
    case GridInternal.screenSizeOption size of
        Just s ->
            Just <| Attr.class <| "form-control-" ++ s

        Nothing ->
            Nothing


inputTypeAttribute : InputType -> InputOption msg
inputTypeAttribute inputType =
    (case inputType of
        Text ->
            "text"

        Password ->
            "password"

        DatetimeLocal ->
            "datetime-local"

        Date ->
            "date"

        Month ->
            "month"

        Time ->
            "time"

        Week ->
            "week"

        Number ->
            "number"

        Email ->
            "email"

        Url ->
            "url"

        Search ->
            "search"

        Tel ->
            "tel"

        Color ->
            "color"
    )
        |> Attr.type_
        |> InputAttr



-- SELECT


select : List (InputOption msg) -> List (SelectItem msg) -> Select msg
select options items =
    Select options items


selectItem : List (Html.Attribute msg) -> List (Html.Html msg) -> SelectItem msg
selectItem attributes children =
    SelectItem <| Html.option attributes children


renderSelect : Select msg -> Html.Html msg
renderSelect { items, options } =
    Html.select
        (inputAttributes options)
        (List.map (\(SelectItem item) -> item) items)



-- CHECKBOX AND RADIOS


radio :
    List (FormCheckOption msg)
    -> String
    -> Radio msg
radio options textLabel =
    { textLabel = textLabel
    , options = options
    }


checkbox :
    List (FormCheckOption msg)
    -> String
    -> Html.Html msg
checkbox options textLabel =
    Html.div
        [ Attr.classList
            [ ( "form-check", True )
            , ("form-check-inline", isCheckInline options )
            , ( "disabled", isCheckDisabled options )
            ]
        ]
        [ Html.label
            [ Attr.class "form-check-label" ]
            [ Html.input
                ([ Attr.type_ "checkbox"
                 , Attr.style [ ( "margin-top", ".35rem" ) ]
                 ]
                    ++ (checkAttributes options)
                )
                []
            , Html.span [] [ Html.text textLabel ]
            ]
        ]


renderRadio : Radio msg -> Html.Html msg
renderRadio { textLabel, options } =
    Html.div
        [ Attr.classList
            [ ( "form-check", True )
            , ( "form-check-inline", isCheckInline options )
            , ( "disabled", isCheckDisabled options )
            ]
        ]
        [ Html.label
            [ Attr.class "form-check-label" ]
            [ Html.input
                ([ Attr.type_ "radio"
                 , Attr.style [ ( "margin-top", ".35rem" ) ]
                 ]
                    ++ (checkAttributes options)
                )
                []
            , Html.span [] [ Html.text textLabel ]
            ]
        ]


addRadioAttribute : Html.Attribute msg -> Radio msg -> Radio msg
addRadioAttribute attribute radio =
    { radio | options = radio.options ++ [ CheckAttr attribute ] }


isCheckDisabled : List (FormCheckOption msg) -> Bool
isCheckDisabled options =
    List.any (\opt -> opt == CheckDisabled) options


isCheckInline : List (FormCheckOption msg) -> Bool
isCheckInline options =
    List.any (\opt -> opt == CheckInline) options


checkAttributes : List (FormCheckOption msg) -> List (Html.Attribute msg)
checkAttributes options =
    Attr.class "form-check-input"
        :: (List.map checkAttribute options
                |> List.filterMap identity
           )


checkAttribute : FormCheckOption msg -> Maybe (Html.Attribute msg)
checkAttribute option =
    case option of
        CheckAttr attr ->
            Just attr

        CheckDisabled ->
            Just <| Attr.disabled True

        CheckInline ->
            Nothing
