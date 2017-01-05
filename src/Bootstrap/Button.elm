module Bootstrap.Button
    exposing
        ( button
        , linkButton
        , extraSmall
        , small
        , medium
        , large
        , rolePrimary
        , roleSecondary
        , roleSuccess
        , roleInfo
        , roleWarning
        , roleDanger
        , roleLink
        , block
        , outlinePrimary
        , outlineSecondary
        , outlineSuccess
        , outlineInfo
        , outlineWarning
        , outlineDanger
        , buttonAttributes
        , ButtonOption
        , ButtonConfig
        )

import Html
import Html.Attributes as Attributes exposing (class)
import Bootstrap.Internal.Grid as GridInternal


type alias ButtonConfig msg =
    { options : List ButtonOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type Role
    = Primary
    | Secondary
    | Success
    | Info
    | Warning
    | Danger
    | Link


type ButtonOption
    = SizeButton GridInternal.ScreenSize
    | RoleButton Role
    | OutlineButton Role
    | BlockButton


button : ButtonConfig msg -> Html.Html msg
button { options, attributes, children } =
    Html.button
        (buttonAttributes options ++ attributes)
        children


linkButton : ButtonConfig msg -> Html.Html msg
linkButton { options, attributes, children } =
    Html.a
        (Attributes.attribute "role" "button"
            :: buttonAttributes options
            |> (++) attributes
        )
        children


extraSmall : ButtonOption
extraSmall =
    SizeButton GridInternal.ExtraSmall


small : ButtonOption
small =
    SizeButton GridInternal.Small


medium : ButtonOption
medium =
    SizeButton GridInternal.Medium


large : ButtonOption
large =
    SizeButton GridInternal.Large


rolePrimary : ButtonOption
rolePrimary =
    RoleButton Primary


roleSecondary : ButtonOption
roleSecondary =
    RoleButton Secondary


roleSuccess : ButtonOption
roleSuccess =
    RoleButton Success


roleInfo : ButtonOption
roleInfo =
    RoleButton Info


roleWarning : ButtonOption
roleWarning =
    RoleButton Warning


roleDanger : ButtonOption
roleDanger =
    RoleButton Danger


roleLink : ButtonOption
roleLink =
    RoleButton Link


outlinePrimary : ButtonOption
outlinePrimary =
    OutlineButton Primary


outlineSecondary : ButtonOption
outlineSecondary =
    OutlineButton Secondary


outlineSuccess : ButtonOption
outlineSuccess =
    OutlineButton Success


outlineInfo : ButtonOption
outlineInfo =
    OutlineButton Info


outlineWarning : ButtonOption
outlineWarning =
    OutlineButton Warning


outlineDanger : ButtonOption
outlineDanger =
    OutlineButton Danger


block : ButtonOption
block =
    BlockButton


buttonAttributes : List ButtonOption -> List (Html.Attribute msg)
buttonAttributes options =
    class "btn" :: List.map buttonClass options



{- List.foldl
   (\option classString ->
       String.join " " [ classString, buttonOption option ]
   )
   "btn"
   options
-}


buttonClass : ButtonOption -> Html.Attribute msg
buttonClass style =
    class <|
        case style of
            RoleButton role ->
                "btn-" ++ roleClass role

            SizeButton size ->
                "btn-" ++ GridInternal.screenSizeOption size

            OutlineButton role ->
                "btn-outline-" ++ roleClass role

            BlockButton ->
                "btn-block"


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

        Link ->
            "link"
