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
        , TagOption
        )

{-| Small and adaptive tag for adding context to just about any content.

# Tags
@docs simpleTag, tag


# Pills
@docs simplePill, pill

# Options

@docs TagOption

## Roles
@docs roleDefault, rolePrimary, roleSuccess, roleInfo, roleWarning, roleDanger

## Floats
@docs floatXsLeft, floatXsRight, floatSmLeft, floatSmRight, floatMdLeft, floatMdRight, floatLgLeft, floatLgRight
-}

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

{-| Opaque type representing a tag styling option -}
type TagOption
    = Roled Role
    | Floated Float GridInternal.ScreenSize
    | Pill

{-| Create a tag with default styling

* `children` List of child elements

-}
simpleTag : List (Html.Html msg) -> Html.Html msg
simpleTag children =
    tagRoled Default children


tagRoled : Role -> List (Html.Html msg) -> Html.Html msg
tagRoled role children =
    tag [ Roled role ] children



{-| Create a tag with potential several styling options

    div
        []
        [ Tag.tag [Tag.rolePrimary, Tag.floatXsRight] [Html.text "1"] ]


* `options` List of options to style the tag
* `children` List of child elements

-}
tag : List TagOption -> List (Html.Html msg) -> Html.Html msg
tag options children =
    Html.span
        (tagAttributes options)
        children


{-| Create a pill (tag with rounded corners) using default coloring

* `children` List of child elements

-}
simplePill : List (Html.Html msg) -> Html.Html msg
simplePill children =
    pillRoled Default children


pillRoled : Role -> List (Html.Html msg) -> Html.Html msg
pillRoled role children =
    pill [ Roled role ] children


{-| Create a pill with potential several styling options

    div
        []
        [ Tag.pill [Tag.rolePrimary, Tag.floatXsRight] [Html.text "1"] ]


* `options` List of options to style the tag
* `children` List of child elements

-}
pill : List TagOption -> List (Html.Html msg) -> Html.Html msg
pill classes children =
    tag (Pill :: classes) children



{-| Option for Default colored tag/pill -}
roleDefault : TagOption
roleDefault =
    Roled Default


{-| Option for Primary colored tag/pill -}
rolePrimary : TagOption
rolePrimary =
    Roled Primary


{-| Option for Success colored tag/pill -}
roleSuccess : TagOption
roleSuccess =
    Roled Success

{-| Option for Info colored tag/pill -}
roleInfo : TagOption
roleInfo =
    Roled Info

{-| Option for Warning colored tag/pill -}
roleWarning : TagOption
roleWarning =
    Roled Warning


{-| Option for Danger colored tag/pill -}
roleDanger : TagOption
roleDanger =
    Roled Danger



{-| Float tag left for Extra small screen size -}
floatXsLeft : TagOption
floatXsLeft =
    Floated Left GridInternal.ExtraSmall


{-| Float tag right for Extra small screen size -}
floatXsRight : TagOption
floatXsRight =
    Floated Right GridInternal.ExtraSmall


{-| Float tag left for Small screen size -}
floatSmLeft : TagOption
floatSmLeft =
    Floated Left GridInternal.Small


{-| Float tag right for Small screen size -}
floatSmRight : TagOption
floatSmRight =
    Floated Right GridInternal.Small


{-| Float tag left for Medium screen size -}
floatMdLeft : TagOption
floatMdLeft =
    Floated Left GridInternal.Medium

{-| Float tag right for Medium screen size -}
floatMdRight : TagOption
floatMdRight =
    Floated Right GridInternal.Medium


{-| Float tag left for Large screen size -}
floatLgLeft : TagOption
floatLgLeft =
    Floated Left GridInternal.Large


{-| Float tag right for Large screen size -}
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
