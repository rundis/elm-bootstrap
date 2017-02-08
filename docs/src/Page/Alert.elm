module Page.Alert exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Alert as Alert
import Util


view : List (Html msg)
view =
    [ Util.simplePageHeader
        "Alert"
        "Provide contextual feedback messages for typical user actions with the handful of available and flexible alert messages."
    , Util.pageContent
        (basic ++ extended)
    ]


basic : List (Html msg)
basic =
    [ h2 [] [ text "Basic alert messages " ]
    , p [] [ text """Alerts are available for any length of text. Use one of the 4 available functions in the Alert module.""" ]
    , Util.example
        [ Alert.success [ text "This is a success message." ]
        , Alert.info [ text "Just a heads up info message." ]
        , Alert.warning [ text "Warning, you shouldn't be doing this." ]
        , Alert.danger [ text "Something bad happened." ]
        ]
    , div [ class "highlight" ]
        [ basicCode ]
    ]


basicCode : Html msg
basicCode =
    Util.toMarkdown """
```elm
div []
    [ Alert.success [ text "This is a success message." ]
    , Alert.info [ text "Just a heads up info message." ]
    , Alert.warning [ text "Warning, you shouldn't be doing this." ]
    , Alert.danger [ text "Something bad happened." ]
    ]


```

"""


extended : List (Html msg)
extended =
    [ h2 [] [ text "Styled links and headings" ]
    , p [] [ text "The Alert module provides a couple of helper functions to make your links and headings nicely styled inside alerts."]
    , Util.example
        [ Alert.info
            [ Alert.h4 [] [ text "Alert heading"]
            , text "This info message has a "
            , Alert.link [ href "javascript:void()" ] [text "link"]
            , p [] [ text "Followed by a paragraph behaving as you'd expect."]
            ]

        ]
    , div [ class "highlight" ]
        [ extendedCode ]
    ]


extendedCode : Html msg
extendedCode =
    Util.toMarkdown """
```elm
Alert.info
    [ Alert.h4 [] [ text "Alert header"]
    , text "This info message has a "
    , Alert.link [ href "javascript:void()" ] [text "link"]
    , p [] [ text "Followed by a paragraph behaving as you'd expect."]
    ]
```
"""
