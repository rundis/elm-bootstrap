module Bootstrap.TextInput
    exposing
        ( text
        , password
        , datetimeLocal
        , date
        , month
        , time
        , week
        , number
        , email
        , url
        , search
        , tel
        , color
        , small
        , large
        , id
        , attr
        , InputOption
        )
{-| Functions to create standalone textual inputs. It includes convenient helpers
for HTML 5 input types.


# Inputs
@docs text, password, datetimeLocal, date, month, time, week, number, email, url, search, tel, color


# Options
@docs id, small, large, attr, InputOption

-}

import Bootstrap.Internal.Form as FormInternal exposing (InputOption(..), InputType(..))
import Bootstrap.Internal.Grid as GridInternal
import Html


{-| Opaque type representing the type of configuration options available for TextInputs
-}
type alias InputOption msg =
    FormInternal.InputOption msg


{-| Option to make an input smaller (in height)
-}
small : InputOption msg
small =
    InputSize GridInternal.Small



{-| Option to make an input taller
-}
large : InputOption msg
large =
    InputSize GridInternal.Large


{-| Options/shorthand for setting the id of an input -}
id : String -> InputOption msg
id id =
    InputId id

{-| Use this function to handle any Html.Attribute option you wish for your input
-}
attr : Html.Attribute msg -> InputOption msg
attr attr =
    InputAttr attr

{-| Create an input with type="text"

    TextInput.text
        [ TextInput.id "myinput"
        , TextInput.small
        , TextInput.attr <| onInput MyInputMsg
        ]

-}
text : List (InputOption msg) -> Html.Html msg
text =
    renderedInput Text


{-| Create an input with type="password"
-}
password : List (InputOption msg) -> Html.Html msg
password =
    renderedInput Password


{-| Create an input with type="datetime-local"
-}
datetimeLocal : List (InputOption msg) -> Html.Html msg
datetimeLocal =
    renderedInput DatetimeLocal

{-| Create an input with type="date"
-}
date : List (InputOption msg) -> Html.Html msg
date =
    renderedInput Date

{-| Create an input with type="month"
-}
month : List (InputOption msg) -> Html.Html msg
month =
    renderedInput Month

{-| Create an input with type="time"
-}
time : List (InputOption msg) -> Html.Html msg
time =
    renderedInput Time


{-| Create an input with type="week"
-}
week : List (InputOption msg) -> Html.Html msg
week =
    renderedInput Week


{-| Create an input with type="number"
-}
number : List (InputOption msg) -> Html.Html msg
number =
    renderedInput Number


{-| Create an input with type="email"
-}
email : List (InputOption msg) -> Html.Html msg
email =
    renderedInput Email


{-| Create an input with type="url"
-}
url : List (InputOption msg) -> Html.Html msg
url =
    renderedInput Url


{-| Create an input with type="search"
-}
search : List (InputOption msg) -> Html.Html msg
search =
    renderedInput Search


{-| Create an input with type="tel"
-}
tel : List (InputOption msg) -> Html.Html msg
tel =
    renderedInput Tel


{-| Create an input with type="color"
-}
color : List (InputOption msg) -> Html.Html msg
color =
    renderedInput Color


renderedInput : InputType -> List (InputOption msg) -> Html.Html msg
renderedInput tipe =
    FormInternal.input tipe >> FormInternal.renderInput
