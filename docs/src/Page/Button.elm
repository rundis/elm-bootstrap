module Page.Button exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Button as Button
import Bootstrap.ButtonGroup as ButtonGroup
import Util


view : List (Html msg)
view =
    [ Util.simplePageHeader
        "Button"
        """Use Bootstrap’s custom button styles for actions in forms, dialogs, and more.
        Includes support for a handful of contextual variations, sizes, states, and more."""
    , Util.pageContent
        (examples
            ++ linkButtons
            ++ outlines
            ++ sizes
            ++ disableds
            ++ composing
        )
    ]


examples : List (Html msg)
examples =
    [ h2 [] [ text "Examples" ]
    , p [] [ text "Bootstrap includes six predefined button styles, each serving its own semantic purpose." ]
    , Util.example
        [ Button.button [ Button.primary ] [ text "Primary" ]
        , Button.button [ Button.secondary, Button.attrs [ class "ml-1" ] ] [ text "Secondary" ]
        , Button.button [ Button.success, Button.attrs [ class "ml-1" ] ] [ text "Success" ]
        , Button.button [ Button.info, Button.attrs [ class "ml-1" ] ] [ text "Info" ]
        , Button.button [ Button.warning, Button.attrs [ class "ml-1" ] ] [ text "Warning" ]
        , Button.button [ Button.danger, Button.attrs [ class "ml-1" ] ] [ text "Danger" ]
        , Button.button [ Button.roleLink, Button.attrs [ class "ml-1" ] ] [ text "Link" ]
        ]
    , Util.code examplesCode
    ]


examplesCode : Html msg
examplesCode =
    Util.toMarkdownElm """
div []
    [ Button.button [ Button.primary ] [ text "Primary" ]
    , Button.button [ Button.secondary, Button.attrs [ class "ml-1"] ] [ text "Secondary" ]
    , Button.button [ Button.success, Button.attrs [ class "ml-1"] ] [ text "Success" ]
    , Button.button [ Button.info, Button.attrs [ class "ml-1"] ] [ text "Info" ]
    , Button.button [ Button.warning, Button.attrs [ class "ml-1"] ] [ text "Warning" ]
    , Button.button [ Button.danger, Button.attrs [ class "ml-1"] ] [ text "Danger" ]
    , Button.button [ Button.roleLink, Button.attrs [ class "ml-1"] ] [ text "Link" ]
    ]
"""


linkButtons : List (Html msg)
linkButtons =
    [ h2 [] [ text "Link buttons" ]
    , p [] [ text """You can also make links look like buttons using the linkButton function.
                  You would typically use that to trigger in-page functionality.""" ]
    , Util.example
        [ Button.linkButton [ Button.primary, Button.attrs [ href "javascript:void()"] ] [ text "Link button"] ]
    , Util.code linkButtonsCode
    ]

linkButtonsCode : Html msg
linkButtonsCode =
    Util.toMarkdownElm """
Button.linkButton [ Button.primary, Button.attrs [ href "#"] ] [ text "Link button" ]
"""


outlines : List (Html msg)
outlines =
    [ h2 [] [ text "Examples" ]
    , p [] [ text "In need of a button, but not the hefty background colors they bring? Use the outline* functions to remove all background images and colors on any button." ]
    , Util.example
        [ Button.button [ Button.outlinePrimary ] [ text "Primary" ]
        , Button.button [ Button.outlineSecondary, Button.attrs [ class "ml-1" ] ] [ text "Secondary" ]
        , Button.button [ Button.outlineSuccess, Button.attrs [ class "ml-1" ] ] [ text "Success" ]
        , Button.button [ Button.outlineInfo, Button.attrs [ class "ml-1" ] ] [ text "Info" ]
        , Button.button [ Button.outlineWarning, Button.attrs [ class "ml-1" ] ] [ text "Warning" ]
        , Button.button [ Button.outlineDanger, Button.attrs [ class "ml-1" ] ] [ text "Danger" ]
        ]
    , Util.code outlinesCode
    ]


outlinesCode : Html msg
outlinesCode =
    Util.toMarkdownElm """
div []
    [ Button.button [ Button.outlinePrimary ] [ text "Primary" ]
    , Button.button [ Button.outlineSecondary, Button.attrs [ class "ml-1" ] ] [ text "Secondary" ]
    , Button.button [ Button.outlineSuccess, Button.attrs [ class "ml-1" ] ] [ text "Success" ]
    , Button.button [ Button.outlineInfo, Button.attrs [ class "ml-1" ] ] [ text "Info" ]
    , Button.button [ Button.outlineWarning, Button.attrs [ class "ml-1" ] ] [ text "Warning" ]
    , Button.button [ Button.outlineDanger, Button.attrs [ class "ml-1" ] ] [ text "Danger" ]
    ]
"""


sizes : List (Html msg)
sizes =
    [ h2 [] [ text "Sizes" ]
    , p [] [ text "Fancy larger or smaller buttons? Use the large or small options."]
    , Util.example
        [ Button.button
            [ Button.large, Button.primary ] [ text "Large button "]
        , Button.button
            [ Button.small, Button.primary, Button.attrs [ class "ml-1"] ]
            [ text "Small button" ]
        ]
    , Util.code sizesCode
    , p [] [ text "Create block level button, those that span the full width of a parent, by using the block option." ]
    , Util.example
        [ Button.button
            [ Button.primary, Button.block, Button.large ]
            [ text "Block level button" ]
        ]
    , Util.code blockCode
    ]


sizesCode : Html msg
sizesCode =
    Util.toMarkdownElm """
div []
    [ Button.button
        [ Button.large, Button.primary ] [ text "Large button" ]
    , Button.button
        [ Button.small, Button.primary, Button.attrs [ class "ml-1"] ]
        [ text "Small button" ]
    ]
"""

blockCode : Html msg
blockCode =
    Util.toMarkdownElm """
Button.button
    [ Button.primary, Button.block, Button.large ]
    [ text "Block level button" ]
"""

disableds : List (Html msg)
disableds =
    [ h2 [] [ text "Disabled state"]
    , p [] [ text "Make buttons look inactive by using the disable option." ]
    , Util.example
        [ Button.button [ Button.primary, Button.disabled True ] [ text "Button" ]
        , Button.button
            [ Button.secondary, Button.disabled True, Button.attrs [ class "ml-1" ] ]
            [ text "Button" ]
        , Button.linkButton
            [ Button.primary, Button.disabled True, Button.attrs [ class "ml-1", href "#" ] ]
            [ text "Link" ]
        , Button.linkButton
            [ Button.secondary, Button.disabled True, Button.attrs [ class "ml-1", href "#" ] ]
            [ text "Link" ]
        ]
    , Util.code disabledsCode
    , Util.calloutWarning
        [ p [] [ text """The disabled option uses pointer-events: none to try to disable the link functionality of <a>s, but that CSS property is not yet standardized.
                        In addition, even in browsers that do support pointer-events: none, keyboard navigation remains unaffected, meaning that sighted keyboard users and users of assistive technologies will still be able to activate these links.
                        So to be safe, add a tabindex="-1" attribute on these links (to prevent them from receiving keyboard focus) and use custom JavaScript to disable their functionality. """]]
    ]

disabledsCode : Html msg
disabledsCode =
    Util.toMarkdownElm """
div []
    [ Button.button [ Button.primary, Button.disabled ] [ text "Button" ]
    , Button.button
        [ Button.secondary, Button.disabled, Button.attrs [ class "ml-1" ] ]
        [ text "Button" ]
    , Button.linkButton
        [ Button.primary, Button.disabled, Button.attrs [ class "ml-1", href "#" ] ]
        [ text "Link" ]
    , Button.linkButton
        [ Button.secondary, Button.disabled, Button.attrs [ class "ml-1", href "#" ] ]
        [ text "Link" ]
    ]
"""


composing : List (Html msg)
composing =
    [ h2 [] [ text "Composing buttons"]
    , p [] [ text "Group a series of buttons together on a single line with the button group, or nest even further to create a button toolbar." ]
    , h3 [] [ text "Basic example" ]
    , Util.example
        [ ButtonGroup.group [] bunchOfButtons ]
    , Util.code groupBasicCode
    , h3 [] [ text "Sizing"]
    , p [] [ text "Instead of applying sizing options to individual buttons, you can apply one size option for all buttons in a group" ]
    , Util.example
        [ ButtonGroup.group [ ButtonGroup.large ] bunchOfButtons
        , ButtonGroup.group
            [ ButtonGroup.small, ButtonGroup.attrs [ style [("display", "block")]] ]
            bunchOfButtons
        ]
    , Util.code groupSizingCode
    , h3 [] [ text "Vertical variation" ]
    , p [] [ text "Make a set of buttons appear vertically stacked rather than horizontally." ]
    , Util.example
        [ ButtonGroup.group [ ButtonGroup.vertical ] bunchOfButtons ]
    , Util.code verticalGroupCode
    , h3 [] [ text "Button toolbar" ]
    , p [] [ text "Combine sets of button groups into button toolbars for more complex components. Use utility classes as needed to space out groups, buttons, and more." ]
    , Util.example
        [ ButtonGroup.toolbar []
            [ ButtonGroup.groupItem [] bunchOfButtons
            , ButtonGroup.groupItem [ ButtonGroup.attrs [ class "ml-1"] ] bunchOfButtons
            , ButtonGroup.groupItem [ ButtonGroup.attrs [ class "ml-3"] ] bunchOfButtons
            ]
        ]
    , Util.code toolbarCode
    , Util.calloutWarning
        [ h4 [] [ text "ButtonGroup.groupItem" ]
        , p [] [ text """Note the use of the function groupItem. It has the same signature as the group function, except that it doesn't return Html
                      This separation is in place to ensure type safety and control over what is placed within a button toolbar."""
               ]
        ]
    ]

bunchOfButtons : List (ButtonGroup.ButtonItem msg)
bunchOfButtons =
    [ ButtonGroup.button [ Button.secondary ] [  text "Left" ]
    , ButtonGroup.button [ Button.secondary ] [  text "Middle" ]
    , ButtonGroup.button [ Button.secondary ] [  text "Right" ]
    ]


groupBasicCode : Html msg
groupBasicCode =
    Util.toMarkdownElm """
ButtonGroup.group []
    [ ButtonGroup.button [ Button.secondary ] [  text "Left" ]
    , ButtonGroup.button [ Button.secondary ] [  text "Middle" ]
    , ButtonGroup.button [ Button.secondary ] [  text "Right" ]
    ]
"""

groupSizingCode : Html msg
groupSizingCode =
    Util.toMarkdownElm """
div []
    [ ButtonGroup.group [ ButtonGroup.large ] bunchOfButtons
    , ButtonGroup.group
        [ ButtonGroup.small, ButtonGroup.attrs [ style [("display", "block")]] ]
        bunchOfButtons
    ]

bunchOfButtons : List (ButtonGroup.ButtonItem msg)
bunchOfButtons =
    [ ButtonGroup.button [ Button.secondary ] [  text "Left" ]
    , ButtonGroup.button [ Button.secondary ] [  text "Middle" ]
    , ButtonGroup.button [ Button.secondary ] [  text "Right" ]
    ]
"""

verticalGroupCode : Html msg
verticalGroupCode =
    Util.toMarkdownElm """
ButtonGroup.group [ ButtonGroup.vertical ] bunchOfButtons
"""

toolbarCode : Html msg
toolbarCode =
    Util.toMarkdownElm """
ButtonGroup.toolbar []
    [ ButtonGroup.groupItem [] bunchOfButtons
    , ButtonGroup.groupItem [ ButtonGroup.attrs [ class "ml-1"] ] bunchOfButtons
    , ButtonGroup.groupItem [ ButtonGroup.attrs [ class "ml-3"] ] bunchOfButtons
    ]
"""
