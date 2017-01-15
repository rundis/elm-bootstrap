module Bootstrap.TextInput
    exposing
        ( text
        , small
        , medium
        , large
        , id
        , attr
        , InputOption
        )

import Bootstrap.Internal.Form as FormInternal exposing (InputOption(..), Input, InputType(..))
import Bootstrap.Internal.Grid as GridInternal
import Html


type alias InputOption msg =
    FormInternal.InputOption msg


small : InputOption msg
small =
    InputSize GridInternal.Small


medium : InputOption msg
medium =
    InputSize GridInternal.Medium


large : InputOption msg
large =
    InputSize GridInternal.Large


id : String -> InputOption msg
id id =
    InputId id


attr : Html.Attribute msg -> InputOption msg
attr attr =
    InputAttr attr


text : List (InputOption msg) -> Html.Html msg
text =
    renderedInput Text


password : List (InputOption msg) -> Html.Html msg
password =
    renderedInput Password


datetimeLocal : List (InputOption msg) -> Html.Html msg
datetimeLocal =
    renderedInput DatetimeLocal


date : List (InputOption msg) -> Html.Html msg
date =
    renderedInput Date


month : List (InputOption msg) -> Html.Html msg
month =
    renderedInput Month


time : List (InputOption msg) -> Html.Html msg
time =
    renderedInput Time


week : List (InputOption msg) -> Html.Html msg
week =
    renderedInput Week


number : List (InputOption msg) -> Html.Html msg
number =
    renderedInput Number


email : List (InputOption msg) -> Html.Html msg
email =
    renderedInput Email


url : List (InputOption msg) -> Html.Html msg
url =
    renderedInput Url


search : List (InputOption msg) -> Html.Html msg
search =
    renderedInput Search


tel : List (InputOption msg) -> Html.Html msg
tel =
    renderedInput Tel


color : List (InputOption msg) -> Html.Html msg
color =
    renderedInput Color


renderedInput : InputType -> List (InputOption msg) -> Html.Html msg
renderedInput tipe =
    FormInternal.input tipe >> FormInternal.renderInput
