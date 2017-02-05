module Page.Progress exposing (view, State, initialState)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Bootstrap.Progress as Progress
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
        "Progress"
        """Use our custom progress component for displaying simple or complex progress bars.
        We don’t use the HTML5 <progress> element, ensuring you can stack progress bars, animate them, and place text labels over them."""
    , Util.pageContent
        [ text "Work in progress" ]
    ]



