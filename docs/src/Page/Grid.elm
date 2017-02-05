module Page.Grid exposing (view, State, initialState)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.Grid as Grid
import Bootstrap.Accordion as Accordion
import Util
import Bootstrap.Checkbox as Checkbox


type alias State =
    { dummy : Int
    }


initialState : State
initialState =
    { dummy = 0 }


view : State -> (State -> msg) -> List (Html msg)
view state toMsg =
    [ Util.simplePageHeader
        "Grid"
        """Bootstrap includes a powerful mobile-first flexbox grid system for building layouts of all shapes and sizes.
        It’s based on a 12 column layout and has multiple tiers, one for each media query range.
        You can use it with Sass mixins or our predefined classes."""
    , Util.pageContent
        [ text "Work in progress" ]
    ]



