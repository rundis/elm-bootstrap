module Bootstrap.Utilities.DomHelper exposing (Area, boundingArea, childNode, className, currentTarget, nextSibling, offsetHeight, offsetWidth, parentElement, target)

{-| **NOTE: INTERNAL**
This module is only exposed as a temp fix for <https://github.com/elm/compiler/issues/1864>
Use at your own risk !

@docs Area, boundingArea, childNode, className, currentTarget, nextSibling, offsetHeight, offsetWidth, parentElement, target

-}

import Json.Decode as Decode


{-| Not intended for external use.
-}
type alias Area =
    { top : Float
    , left : Float
    , width : Float
    , height : Float
    }


{-| Not intended for external use.
-}
boundingArea : Decode.Decoder Area
boundingArea =
    Decode.map3
        (\( x, y ) width height ->
            { top = y
            , left = x
            , width = width
            , height = height
            }
        )
        (position 0 0)
        offsetWidth
        offsetHeight


{-| Not intended for external use.
-}
position : Float -> Float -> Decode.Decoder ( Float, Float )
position x y =
    Decode.map4
        (\scrollLeft_ scrollTop_ offsetLeft_ offsetTop_ ->
            ( x + offsetLeft_ - scrollLeft_, y + offsetTop_ - scrollTop_ )
        )
        scrollLeft
        scrollTop
        offsetLeft
        offsetTop
        |> Decode.andThen
            (\( x_, y_ ) ->
                offsetParent ( x_, y_ ) (position x_ y_)
            )


{-| Not intended for external use.
-}
parentElement : Decode.Decoder a -> Decode.Decoder a
parentElement decoder =
    Decode.field "parentElement" decoder


{-| Not intended for external use.
-}
target : Decode.Decoder a -> Decode.Decoder a
target decoder =
    Decode.field "target" decoder


{-| Not intended for external use.
-}
currentTarget : Decode.Decoder a -> Decode.Decoder a
currentTarget decoder =
    Decode.field "currentTarget" decoder


{-| Not intended for external use.
-}
offsetParent : a -> Decode.Decoder a -> Decode.Decoder a
offsetParent x decoder =
    Decode.oneOf
        [ Decode.field "offsetParent" <| Decode.null x
        , Decode.field "offsetParent" decoder
        ]


{-| Not intended for external use.
-}
offsetTop : Decode.Decoder Float
offsetTop =
    Decode.field "offsetTop" Decode.float


{-| Not intended for external use.
-}
offsetLeft : Decode.Decoder Float
offsetLeft =
    Decode.field "offsetLeft" Decode.float


{-| Not intended for external use.
-}
scrollLeft : Decode.Decoder Float
scrollLeft =
    Decode.field "scrollLeft" Decode.float


{-| Not intended for external use.
-}
scrollTop : Decode.Decoder Float
scrollTop =
    Decode.field "scrollTop" Decode.float


{-| Not intended for external use.
-}
offsetWidth : Decode.Decoder Float
offsetWidth =
    Decode.field "offsetWidth" Decode.float


{-| Not intended for external use.
-}
offsetHeight : Decode.Decoder Float
offsetHeight =
    Decode.field "offsetHeight" Decode.float


{-| Not intended for external use.
-}
childNode : Int -> Decode.Decoder a -> Decode.Decoder a
childNode idx =
    Decode.at [ "childNodes", String.fromInt idx ]


{-| Not intended for external use.
-}
nextSibling : Decode.Decoder a -> Decode.Decoder a
nextSibling decoder =
    Decode.field "nextSibling" decoder


{-| Not intended for external use.
-}
className : Decode.Decoder String
className =
    Decode.at [ "className" ] Decode.string
