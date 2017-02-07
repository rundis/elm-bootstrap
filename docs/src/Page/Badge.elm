module Page.Badge exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Util
import Bootstrap.Badge as Badge


view : List (Html msg)
view =
    [ Util.simplePageHeader
        "Badge"
        "Small and adaptive tag for adding context to just about any content."
    , Util.pageContent
        (example ++ contextual ++ pills)
    ]


example : List (Html msg)
example =
    [ h2 [] [ text "Example" ]
    , p [] [ text "Badges scale to match the size of the immediate parent element by using relative font sizing and em units" ]
    , Util.example
        [ h1 [] [ text "Heading 1 ", Badge.badge [] [ text "New" ] ]
        , h2 [] [ text "Heading 2 ", Badge.badge [] [ text "New" ] ]
        , h3 [] [ text "Heading 3 ", Badge.badge [] [ text "New" ] ]
        , h4 [] [ text "Heading 4 ", Badge.badge [] [ text "New" ] ]
        , h5 [] [ text "Heading 5 ", Badge.badge [] [ text "New" ] ]
        , h6 [] [ text "Heading 6 ", Badge.badge [] [ text "New" ] ]
        ]
    , div [ class "highlight" ]
        [ exampleCode ]
    ]


exampleCode : Html msg
exampleCode =
    Util.toMarkdown """
```elm
div []
    [ h1 [] [ text "Heading 1 ", Badge.badge [] [ text "New"] ]
    , h2 [] [ text "Heading 2 ", Badge.badge [] [ text "New"] ]
    , h3 [] [ text "Heading 3 ", Badge.badge [] [ text "New"] ]
    , h4 [] [ text "Heading 4 ", Badge.badge [] [ text "New"] ]
    , h5 [] [ text "Heading 5 ", Badge.badge [] [ text "New"] ]
    , h6 [] [ text "Heading 6 ", Badge.badge [] [ text "New"] ]
    ]

```
"""


contextual : List (Html msg)
contextual =
    [ h2 [] [ text "Contextual variations" ]
    , p [] [ text "Use the following functions to change the appearance of a badge." ]
    , Util.example
        [ Badge.badge [] [ text "Default" ]
        , Badge.badgePrimary [ class "ml-1" ] [ text "Primary" ]
        , Badge.badgeSuccess [ class "ml-1" ] [ text "Success" ]
        , Badge.badgeInfo [ class "ml-1" ] [ text "Info" ]
        , Badge.badgeWarning [ class "ml-1" ] [ text "Warning" ]
        , Badge.badgeDanger [ class "ml-1" ] [ text "Danger" ]
        ]
    , div [ class "highlight" ]
        [ contextualCode ]
    ]


contextualCode : Html msg
contextualCode =
    Util.toMarkdown """
```elm
div []
    [ Badge.badge [] [ text "Default" ]
    , Badge.badgePrimary [ class "ml-1" ] [ text "Primary" ]
    , Badge.badgeSuccess [ class "ml-1" ] [ text "Success" ]
    , Badge.badgeInfo [ class "ml-1" ] [ text "Info" ]
    , Badge.badgeWarning [ class "ml-1" ] [ text "Warning" ]
    , Badge.badgeDanger [ class "ml-1" ] [ text "Danger" ]
    ]

```
"""


pills =
    [ h2 [] [ text "Pill badges" ]
    , p [] [ text "To create more rounded badges use the pill* functions." ]
    , Util.example
        [ Badge.pill [] [ text "Default" ]
        , Badge.pillPrimary [ class "ml-1" ] [ text "Primary" ]
        , Badge.pillSuccess [ class "ml-1" ] [ text "Success" ]
        , Badge.pillInfo [ class "ml-1" ] [ text "Info" ]
        , Badge.pillWarning [ class "ml-1" ] [ text "Warning" ]
        , Badge.pillDanger [ class "ml-1" ] [ text "Danger" ]
        ]
    , div [ class "highlight" ]
        [ pillsCode ]
    ]


pillsCode : Html msg
pillsCode =
    Util.toMarkdown """
```elm
div []
    [ Badge.pill [] [ text "Default" ]
    , Badge.pillPrimary [ class "ml-1" ] [ text "Primary" ]
    , Badge.pillSuccess [ class "ml-1" ] [ text "Success" ]
    , Badge.pillInfo [ class "ml-1" ] [ text "Info" ]
    , Badge.pillWarning [ class "ml-1" ] [ text "Warning" ]
    , Badge.pillDanger [ class "ml-1" ] [ text "Danger" ]
    ]

```
"""
