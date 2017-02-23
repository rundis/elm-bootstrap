module Page.Navbar exposing
    ( view
    , initialState
    , subscriptions
    , State
    )


import Html exposing (..)
import Html.Attributes exposing (..)

import Bootstrap.Navbar as Navbar
import Bootstrap.Form.Input as Input
import Bootstrap.Button as Button
import Bootstrap.Grid as Grid
import Util

type alias State =
    { basicState : Navbar.State
    , customState : Navbar.State
    }

initialState : (State -> msg) -> (State, Cmd msg)
initialState toMsg =
    let
        (basicState, cmdBasic) =
            Navbar.initialState (\ns -> toMsg { basicState = ns, customState = ns})
        (customState, cmdCustom) =
            Navbar.initialState (\ns -> toMsg { customState = ns, basicState = ns})
    in
        ({ basicState = basicState
         , customState = customState
         }
        , Cmd.batch [cmdBasic, cmdCustom] )



subscriptions : State -> (State -> msg) -> Sub msg
subscriptions state toMsg =
    Sub.batch
        [ Navbar.subscriptions state.basicState (\ns -> toMsg { state | basicState = ns})
        , Navbar.subscriptions state.customState (\ns -> toMsg { state | customState = ns})
        ]


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Navbar"
        """The navbar is a wrapper that positions branding, navigation, and other elements in a concise header.
        It’s easily extensible and supports responsive behavior."""
    , Util.pageContent
        ( basic state toMsg
            ++ custom state toMsg
        )
    ]



basic : State -> (State -> msg) -> List (Html msg)
basic state toMsg =
    [ h2 [] [ text "Basic example" ]
    , p [] [ text """Navbars supports a variety of content. We'll start off with a relatively simple example.
                  Since navbars require state and special care to handle responsibe behavior, there is a bit of wiring
                  needed to set one up.""" ]

    , Util.example
        [ Navbar.config (\ns -> toMsg { state | basicState = ns})
            |> Navbar.withAnimation
            |> Navbar.collapseMedium
            |> Navbar.brand [ href "javascript:void()"] [ text "Brand"]
            |> Navbar.items
                [ Navbar.itemLink [href "javascript:void()"] [ text "Item 1"]
                , Navbar.itemLink [href "javascript:void()"] [ text "Item 2"]
                ]
            |> Navbar.view state.basicState

        , Util.calloutInfo
            [ p [] [ text " Try resizing the window width to see the menu collapse behavior" ] ]
        ]
    , Util.code basicCode
    , Util.calloutInfo
        [ h3 [] [ text "Navbar composition"]
        , ul []
            [ textLi "You start out by using the config function providing the navbar *Msg as it's argument."
            , textLi "Then you compose your modal with optional options, brand, menu items (links or dropdowns) and/or customItems (see next example)."
            , textLi "Finally to turn he navbar into Elm Html you call the view function passing it the current state of the navbar."
            ]
        ]
    ]


textLi : String -> Html msg
textLi str =
    li [] [ text str ]



basicCode : Html msg
basicCode =
    Util.toMarkdownElm """

import Bootstrap.Navbar as Navbar

-- You need to keep track of the view state for the navbar in your model

type alias Model =
    { navbarState : Navbar.State }


-- The navbar needs to know the initial window size, so the inital state for a navbar requires a command to be run by the Elm runtime

initialState : (Model, Cmd Msg)
initialState toMsg =
    let
        (navbarState, navbarCmd)
            = Navbar.initialState NavbarMsg
    in
        ({ navbarState = navbarState }, navBarCmd )


-- Define a message for the navbar

type Msg
    = NavbarMsg


-- You need to handle navbar messages in your update function to step the navbar state forward

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
    case msg of
        NavbarMsg state ->
            ( { model | navbarState = state }, Cmd.none )


view : Model -> Html Msg
view model =
    Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.brand [ href "#"] [ text "Brand"]
        |> Navbar.items
            [ Navbar.itemLink [href "#"] [ text "Item 1"]
            , Navbar.itemLink [href "#"] [ text "Item 2"]
            ]
        |> Navbar.view state.basicState

-- If you use animations as above or you use dropdowns in your navbar you need to configure subscriptions too

subscriptions : Model -> Sub Msg
subscriptions model =
    Navbar.subscriptions model.navbarState NavbarMsg

"""


custom : State -> (State -> msg) -> List (Html msg)
custom state toMsg =
    [ h2 [] [ text "Options, dropdowns and custom content" ]
    , p [] [ text """You can twist and tweak the navbar quite a bit using a pipeline friendly syntax.
                  You may configure coloring with handy helper functions, add dropdowns as menu items and you can add a few flavors of custom content as well.
                  """ ]
    , Util.example
        [ Grid.container []
            [
         Navbar.config (\ns -> toMsg { state | customState = ns })
            |> Navbar.withAnimation
            |> Navbar.collapseMedium
            |> Navbar.info
            |> Navbar.brand
                [ href "javascript:void()" ]
                [ img
                    [ src "assets/images/elm-bootstrap.svg"
                    , class "d-inline-block align-top"
                    , style [ ( "width", "30px" ) ]
                    ]
                    []
                , text " Elm Bootstrap"
                ]
            |> Navbar.items
                [ Navbar.itemLink [ href "javascript:void()" ] [ text "Item 1" ]
                , Navbar.dropdown
                    { id = "mydropdown"
                    , toggle = Navbar.dropdownToggle [] [ text "My dropdown" ]
                    , items =
                        [ Navbar.dropdownHeader [ text "Heading" ]
                        , Navbar.dropdownItem
                            [ href "javascript:void()" ]
                            [ text "Drop item 1" ]
                        , Navbar.dropdownItem
                            [ href "javascript:void()" ]
                            [ text "Drop item 2" ]
                        , Navbar.dropdownDivider
                        , Navbar.dropdownItem
                            [ href "javascript:void()" ]
                            [ text "Drop item 3" ]
                        ]
                    }
                ]
            |> Navbar.customItems
                [ Navbar.formItem []
                    [ Input.text [ Input.attrs [placeholder "enter" ]]
                    , Button.button
                        [ Button.success
                        , Button.attrs [ class "ml-sm-2"]
                        ]
                        [ text "Search"]
                    ]
                , Navbar.textItem [ class "muted ml-sm-2" ] [ text "Text"]
                ]
            |> Navbar.view state.customState
        ]
        ]
    , Util.code customCode
    ]


customCode : Html msg
customCode =
    Util.toMarkdownElm """
Grid.container [] -- Wrap in a container to center the navbar
    [ Navbar.config NavbarMsg
        |> Navbar.withAnimation
        |> Navbar.collapseMedium            -- Collapse menu at the medium breakpoint
        |> Navbar.info                      -- Customize coloring
        |> Navbar.brand                     -- Add logo to your brand with a little styling to align nicely
            [ href "#" ]
            [ img
                [ src "assets/images/elm-bootstrap.svg"
                , class "d-inline-block align-top"
                , style [ ( "width", "30px" ) ]
                ]
                []
            , text " Elm Bootstrap"
            ]
        |> Navbar.items
            [ Navbar.itemLink
                [ href "#" ] [ text "Item 1" ]
            , Navbar.dropdown              -- Adding dropdowns is pretty simple
                { id = "mydropdown"
                , toggle = Navbar.dropdownToggle [] [ text "My dropdown" ]
                , items =
                    [ Navbar.dropdownHeader [ text "Heading" ]
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "Drop item 1" ]
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "Drop item 2" ]
                    , Navbar.dropdownDivider
                    , Navbar.dropdownItem
                        [ href "#" ]
                        [ text "Drop item 3" ]
                    ]
                }
            ]
        |> Navbar.customItems              -- Add custom items
            [ Navbar.formItem []
                [ Input.text [ Input.attr <| placeholder "enter" ]
                , Button.button
                    [ Button.success
                    , Button.attrs [ class "ml-sm-2"]
                    ]
                    [ text "Search"]
                ]
            , Navbar.textItem [ class "muted ml-sm-2" ] [ text "Text"]
            ]
        |> Navbar.view state.customState
    ]
"""

