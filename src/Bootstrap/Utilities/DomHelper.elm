module Bootstrap.Utilities.DomHelper exposing
    ( Area
    , boundingArea
    , childNode
    , className
    , currentTarget
    , nextSibling
    , offsetHeight
    , offsetWidth
    , parentElement
    , target
    )

import Json.Decode as Decode


type alias Area =
    { top : Float
    , left : Float
    , width : Float
    , height : Float
    }


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


parentElement : Decode.Decoder a -> Decode.Decoder a
parentElement decoder =
    Decode.field "parentElement" decoder


target : Decode.Decoder a -> Decode.Decoder a
target decoder =
    Decode.field "target" decoder


currentTarget : Decode.Decoder a -> Decode.Decoder a
currentTarget decoder =
    Decode.field "currentTarget" decoder


offsetParent : a -> Decode.Decoder a -> Decode.Decoder a
offsetParent x decoder =
    Decode.oneOf
        [ Decode.field "offsetParent" <| Decode.null x
        , Decode.field "offsetParent" decoder
        ]


offsetTop : Decode.Decoder Float
offsetTop =
    Decode.field "offsetTop" Decode.float


offsetLeft : Decode.Decoder Float
offsetLeft =
    Decode.field "offsetLeft" Decode.float


scrollLeft : Decode.Decoder Float
scrollLeft =
    Decode.field "scrollLeft" Decode.float


scrollTop : Decode.Decoder Float
scrollTop =
    Decode.field "scrollTop" Decode.float


offsetWidth : Decode.Decoder Float
offsetWidth =
    Decode.field "offsetWidth" Decode.float


offsetHeight : Decode.Decoder Float
offsetHeight =
    Decode.field "offsetHeight" Decode.float


childNode : Int -> Decode.Decoder a -> Decode.Decoder a
childNode idx =
    Decode.at [ "childNodes", String.fromInt idx ]


nextSibling : Decode.Decoder a -> Decode.Decoder a
nextSibling decoder =
    Decode.field "nextSibling" decoder


className : Decode.Decoder String
className =
    Decode.at [ "className" ] Decode.string
