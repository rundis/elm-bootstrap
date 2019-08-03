module Bootstrap.Form.InputGroup exposing
    ( view, config, predecessors, successors, text, button, dropdown, splitDropdown, span, Config, Input, Addon
    , password, datetimeLocal, date, month, time, week, number, email, url, search, tel
    , large, small
    , attrs
    )

{-| Easily extend form input controls by adding text and buttons.

    import Bootstrap.Form.InputGroup as InputGroup
    import Bootstrap.Form.Input as Input
    import Bootstrap.Button as Button


    InputGroup.config
        ( InputGroup.text [] )
        |> InputGroup.large
        |> InputGroup.predecessors
            [ InputGroup.span [] [ text "Stuff" ] ]
        |> InputGroup.successors
            [ InputGroup.button [] [ text "DoIt!"] ]
        |> InputGroup.view


# General

@docs view, config, predecessors, successors, text, button, dropdown, splitDropdown, span, Config, Input, Addon


# Additional input flavors

@docs password, datetimeLocal, date, month, time, week, number, email, url, search, tel


# Sizing

@docs large, small


# Further customization

@docs attrs

-}

import Bootstrap.Button as Button
import Bootstrap.Dropdown as Dropdown
import Bootstrap.Form.Input as Input
import Bootstrap.General.Internal exposing (ScreenSize(..), screenSizeOption)
import Html
import Html.Attributes as Attributes


{-| Opaque representation of the view configuration for an input group.
-}
type Config msg
    = Config
        { input : Input msg
        , predecessors : List (Addon msg)
        , successors : List (Addon msg)
        , size : Maybe ScreenSize
        , attributes : List (Html.Attribute msg)
        }


{-| Opaque representation of an input element.
-}
type Input msg
    = Input (Html.Html msg)


{-| Opaque representation of an input-group add-on element.
-}
type Addon msg
    = Addon (Html.Html msg)


{-| Create initial view configuration for an input group.

  - `input` - The input for the input group

-}
config : Input msg -> Config msg
config input_ =
    Config
        { input = input_
        , predecessors = []
        , successors = []
        , size = Nothing
        , attributes = []
        }


{-| Create the view representation for an Input group based on
a Config
-}
view : Config msg -> Html.Html msg
view (Config conf) =
    let
        (Input input_) =
            conf.input
    in
    Html.div
        ([ Attributes.class "input-group" ]
            ++ ([ Maybe.andThen sizeAttribute conf.size ]
                    |> List.filterMap identity
               )
            ++ conf.attributes
        )
        (List.map
            (\(Addon e) -> Html.div [ Attributes.class "input-group-prepend" ] [ e ])
            conf.predecessors
            ++ [ input_ ]
            ++ List.map
                (\(Addon e) -> Html.div [ Attributes.class "input-group-append" ] [ e ])
                conf.successors
        )


{-| Specify a list of add-ons to display before the input.

  - `addons` List of add-ons
  - `config` View configuration for Input group (so far)

-}
predecessors :
    List (Addon msg)
    -> Config msg
    -> Config msg
predecessors addons (Config conf) =
    Config
        { conf | predecessors = addons }


{-| Specify a list of add-ons to display after the input.

  - `addons` List of add-ons
  - `config` View configuration for Input group (so far)

-}
successors :
    List (Addon msg)
    -> Config msg
    -> Config msg
successors addons (Config conf) =
    Config
        { conf | successors = addons }


{-| Create a simple span add-on. Great for simple texts or font icons

  - `attributes` - List of attributes
  - `children` - List of child elements

-}
span : List (Html.Attribute msg) -> List (Html.Html msg) -> Addon msg
span attributes children =
    Html.span
        (Attributes.class "input-group-text" :: attributes)
        children
        |> Addon


{-| Create a button add-on.

  - `options` List of button options
  - `children` LIst of child elements

-}
button :
    List (Button.Option msg)
    -> List (Html.Html msg)
    -> Addon msg
button options children =
    Button.button options children
        |> Addon


{-| Create a dropdown add-on.

For details see the [`Bootstrap.Dropdown`](Bootstrap-Dropdown) module.

-}
dropdown :
    Dropdown.State
    ->
        { toggleMsg : Dropdown.State -> msg
        , toggleButton : Dropdown.DropdownToggle msg
        , options : List (Dropdown.DropdownOption msg)
        , items : List (Dropdown.DropdownItem msg)
        }
    -> Addon msg
dropdown state conf =
    Dropdown.dropdown state conf
        |> Addon


{-| Create a split dropdown add-on.

For details see the [`Bootstrap.Dropdown`](Bootstrap-Dropdown) module.

-}
splitDropdown :
    Dropdown.State
    ->
        { toggleMsg : Dropdown.State -> msg
        , toggleButton : Dropdown.SplitDropdownToggle msg
        , options : List (Dropdown.DropdownOption msg)
        , items : List (Dropdown.DropdownItem msg)
        }
    -> Addon msg
splitDropdown state conf =
    Dropdown.splitDropdown state conf
        |> Addon


{-| Create an input add-on with type="text"
-}
text : List (Input.Option msg) -> Input msg
text =
    input Input.text


{-| Create an input add-on with type="password"
-}
password : List (Input.Option msg) -> Input msg
password =
    input Input.password


{-| Create an input add-on with type="datetime-local"
-}
datetimeLocal : List (Input.Option msg) -> Input msg
datetimeLocal =
    input Input.datetimeLocal


{-| Create an input add-on with type="date"
-}
date : List (Input.Option msg) -> Input msg
date =
    input Input.date


{-| Create an input add-on with type="month"
-}
month : List (Input.Option msg) -> Input msg
month =
    input Input.month


{-| Create an input add-on with type="time"
-}
time : List (Input.Option msg) -> Input msg
time =
    input Input.time


{-| Create an input add-on with type="week"
-}
week : List (Input.Option msg) -> Input msg
week =
    input Input.week


{-| Create an input add-on with type="number"
-}
number : List (Input.Option msg) -> Input msg
number =
    input Input.number


{-| Create an input add-on with type="email"
-}
email : List (Input.Option msg) -> Input msg
email =
    input Input.email


{-| Create an input add-on with type="url"
-}
url : List (Input.Option msg) -> Input msg
url =
    input Input.url


{-| Create an input add-on with type="search"
-}
search : List (Input.Option msg) -> Input msg
search =
    input Input.search


{-| Create an input add-on with type="tel"
-}
tel : List (Input.Option msg) -> Input msg
tel =
    input Input.tel


input :
    (List (Input.Option msg) -> Html.Html msg)
    -> List (Input.Option msg)
    -> Input msg
input inputFn options =
    inputFn options |> Input


{-| Make all controls in an input group large
-}
large : Config msg -> Config msg
large (Config conf) =
    Config
        { conf | size = Just LG }


{-| Make all controls in an input group small
-}
small : Config msg -> Config msg
small (Config conf) =
    Config
        { conf | size = Just SM }


{-| When you need to customize the input group container, use this function to provide customization attributes.
-}
attrs : List (Html.Attribute msg) -> Config msg -> Config msg
attrs attributes (Config conf) =
    Config
        { conf | attributes = attributes }


sizeAttribute : ScreenSize -> Maybe (Html.Attribute msg)
sizeAttribute size =
    Maybe.map
        (\s -> Attributes.class <| "input-group-" ++ s)
        (screenSizeOption size)
