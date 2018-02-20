module Bootstrap.Utilities.Size exposing (..)

{-| Easily make an element as wide or as tall (relative to its parent) with our width and height utilities.

@docs h25, h50, h75, h100, w25, w50, w75, w100
-}


import Html exposing (Attribute)
import Html.Attributes exposing (class)


{-| Set height to 25% of parent element.
-}
h25 : Attribute msg
h25 =
    class "h-25"

{-| Set height to 50% of parent element.
-}
h50 : Attribute msg
h50 =
    class "h-50"

{-| Set height to 75% of parent element.
-}
h75 : Attribute msg
h75 =
    class "h-75"

{-| Set height to 100% of parent element.
-}
h100 : Attribute msg
h100 =
    class "h-100"


{-| Set width to 25% of parent element.
-}
w25 : Attribute msg
w25 =
    class "w-25"

{-| Set width to 50% of parent element.
-}
w50 : Attribute msg
w50 =
    class "w-50"

{-| Set width to 75% of parent element.
-}
w75 : Attribute msg
w75 =
    class "w-75"

{-| Set width to 100% of parent element.
-}
w100 : Attribute msg
w100 =
    class "w-100"
