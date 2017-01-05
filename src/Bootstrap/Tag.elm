module Bootstrap.Tag
    exposing
        ( simpleTag
        , simplePill
        , tag
        , pill
        , floatXsLeft
        , floatXsRight
        , floatSmLeft
        , floatSmRight
        , floatMdLeft
        , floatMdRight
        , floatLgLeft
        , floatLgRight
        , roleDefault
        , rolePrimary
        , roleSuccess
        , roleInfo
        , roleWarning
        , roleDanger
        , Float(..)
        , TagOption
        )

import Html
import Html.Attributes exposing (class)
import Bootstrap.Internal.Grid as GridInternal


type Role
    = Default
    | Primary
    | Success
    | Info
    | Warning
    | Danger


type Float
    = Left
    | Right


type TagOption
    = Roled Role
    | Floated Float GridInternal.ScreenSize
    | Pill


simpleTag : List (Html.Html msg) -> Html.Html msg
simpleTag children =
    tagRoled Default children


tagRoled : Role -> List (Html.Html msg) -> Html.Html msg
tagRoled role children =
    tag [ Roled role ] children


tag : List TagOption -> List (Html.Html msg) -> Html.Html msg
tag classes children =
    Html.span
        (tagAttributes classes)
        children


simplePill : List (Html.Html msg) -> Html.Html msg
simplePill children =
    pillRoled Default children


pillRoled : Role -> List (Html.Html msg) -> Html.Html msg
pillRoled role children =
    pill [ Roled role ] children


pill : List TagOption -> List (Html.Html msg) -> Html.Html msg
pill classes children =
    tag (Pill :: classes) children






roleDefault : TagOption
roleDefault =
    Roled Default


rolePrimary : TagOption
rolePrimary =
    Roled Primary

roleSuccess : TagOption
roleSuccess =
    Roled Success

roleInfo : TagOption
roleInfo =
    Roled Info

roleWarning : TagOption
roleWarning =
    Roled Warning

roleDanger : TagOption
roleDanger =
    Roled Danger




floatXsLeft : TagOption
floatXsLeft =
    Floated Left GridInternal.ExtraSmall


floatXsRight : TagOption
floatXsRight =
    Floated Right GridInternal.ExtraSmall


floatSmLeft : TagOption
floatSmLeft =
    Floated Left GridInternal.Small


floatSmRight : TagOption
floatSmRight =
    Floated Right GridInternal.Small


floatMdLeft : TagOption
floatMdLeft =
    Floated Left GridInternal.Medium


floatMdRight : TagOption
floatMdRight =
    Floated Right GridInternal.Medium


floatLgLeft : TagOption
floatLgLeft =
    Floated Left GridInternal.Large


floatLgRight : TagOption
floatLgRight =
    Floated Right GridInternal.Large


tagAttributes : List TagOption -> List (Html.Attribute msg)
tagAttributes options =
    class "tag" :: List.map tagClass options


tagClass : TagOption -> Html.Attribute msg
tagClass option =
    class <|
        case option of
            Pill ->
                "tag-pill"

            Roled role ->
                roleOption role

            Floated float size ->
                "float-" ++ GridInternal.screenSizeOption size ++ "-" ++ floatOption float


roleOption : Role -> String
roleOption role =
    case role of
        Default ->
            "tag-default"

        Primary ->
            "tag-primary"

        Success ->
            "tag-success"

        Info ->
            "tag-info"

        Warning ->
            "tag-warning"

        Danger ->
            "tag-danger"


floatOption : Float -> String
floatOption float =
    case float of
        Left ->
            "left"

        Right ->
            "right"
