module Bootstrap.Utilities.Border exposing (..)

{-| Use border utilities to quickly style the border and border-radius of an element. Great for images, buttons, or any other element.

# Additive
@docs all, top, bottom, left, right

# Subtractive
@docs none, topNone, bottomNone, leftNone, rightNone

# Colored
@docs primary, secondary, info, success, warning, danger, light, dark

# Border radius
@docs rounded, roundedTop, roundedBottom, roundedLeft, roundedRight, roundedNone, circle


-}

import Html.Attributes exposing (class)
import Html exposing (Attribute)
import Bootstrap.Internal.Role as Role


{-| All sides bordered.
-}
all : Attribute msg
all =
    class "border"

{-| Add top border.
-}
top : Attribute msg
top =
    class "border-top"


{-| Add bottom border.
-}
bottom : Attribute msg
bottom =
    class "border-bottom"


{-| Add left border.
-}
left : Attribute msg
left =
    class "border-left"

{-| Add right border.
-}
right : Attribute msg
right =
    class "border-right"

{-| Force all borders to be removed.
-}
none : Attribute msg
none =
    class "border-0"

{-| Force top border to be removed.
-}
topNone : Attribute msg
topNone =
    class "border-top-0"

{-| Force bottom border to be removed.
-}
bottomNone : Attribute msg
bottomNone =
    class "border-botton-0"

{-| Force left border to be removed.
-}
leftNone : Attribute msg
leftNone =
    class "border-left-0"


{-| Force right border to be removed.
-}
rightNone : Attribute msg
rightNone =
    class "border-right-0"


{-| Color borders with primary color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
primary : Attribute msg
primary =
    Role.toClass "border" Role.Primary


{-| Color borders with secondary color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
secondary : Attribute msg
secondary =
    Role.toClass "border" Role.Secondary


{-| Color borders with success color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
success : Attribute msg
success =
    Role.toClass "border" Role.Success


{-| Color borders with info color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
info : Attribute msg
info =
    Role.toClass "border" Role.Info


{-| Color borders with danger color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
danger : Attribute msg
danger =
    Role.toClass "border" Role.Danger


{-| Color borders with warning color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
warning : Attribute msg
warning =
    Role.toClass "border" Role.Warning


{-| Color borders with dark color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
dark : Attribute msg
dark =
    Role.toClass "border" Role.Dark


{-| Color borders with light color

**Note**: Assumes the element has borders. You might want to use togther with [`all`](#all)
-}
light : Attribute msg
light =
    Role.toClass "border" Role.Light

{-| Give the element rounded corners (through border-radius)
-}
rounded : Attribute msg
rounded =
    class "rounded"


{-| Give element rounded top corners.
-}
roundedTop : Attribute msg
roundedTop =
    class "rounded-top"


{-| Give element rounded bottom corners.
-}
roundedBottom : Attribute msg
roundedBottom =
    class "rounded-bottom"


{-| Give element rounded left corners.
-}
roundedLeft : Attribute msg
roundedLeft =
    class "rounded-left"


{-| Give element rounded right corners.
-}
roundedRight : Attribute msg
roundedRight =
    class "rounded-right"

{-| Remove any border radius that might be set on the element.
-}
roundedNone : Attribute msg
roundedNone =
    class "rounded-0"

{-| Turn your element into a circle.
-}
circle : Attribute msg
circle =
    class "rounded-circle"
