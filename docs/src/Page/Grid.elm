module Page.Grid exposing (view, State, initialState)

import Html exposing (..)
import Html.Attributes exposing (..)
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row
import Util


type alias State =
    { dummy : Int }


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
        (howItWorks
            ++ equalWidth
            ++ oneColWidth
            ++ variableWidth
            ++ multiRowCol
            ++ stackedSm
            ++ mixMatch
            ++ verticalAlign
            ++ horizontalAlign
            ++ offsets
            ++ pushPull
        )
    ]


textLi : String -> Html msg
textLi str =
    li [] [ text str ]


exampleOneRow : List (Html msg) -> Html msg
exampleOneRow children =
    Util.exampleRow
        [ Util.exampleRow children ]


flexExampleRow : List (Html msg) -> Html msg
flexExampleRow children =
    div
        [ class "bd-example-row bd-example-row-flex-cols" ]
        [ Util.exampleRow children ]


howItWorks : List (Html msg)
howItWorks =
    [ h2 [] [ text "How it works" ]
    , p [] [ text """Bootstrap’s grid system uses a series of containers, rows, and columns to layout and align content. It’s built with flexbox and is fully responsive.
                    Below is simple example.""" ]
    , Util.exampleAndRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [] [ text "One of Three columns" ]
                , Grid.col [] [ text "One of Three columns" ]
                , Grid.col [] [ text "One of Three columns" ]
                ]
            ]
        , Util.code howItWorksCode
        ]
    , p [] [ text "The above example creates three equal-width columns on small, medium, large, and extra large devices using our predefined grid classes. Those columns are centered in the page with the parent container." ]
    , p [] [ text "To understand the underlying details, please consult the Bootstrap 4 Grid documentation." ]
    ]


howItWorksCode : Html msg
howItWorksCode =
    Util.toMarkdownElm """

-- ...
import Bootstrap.Grid as Grid
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row --  not in use in this example, but will be later on.


Grid.container []                                     -- Creates a div that centers content
    [ Grid.row []                                     -- Creates a row with no options
        [ Grid.col [] [ text "One of Three columns" ] -- Creates a column that by default automatically resizes for all media breakpoints
        , Grid.col [] [ text "One of Three columns" ]
        , Grid.col [] [ text "One of Three columns" ]
        ]
    ]

"""


equalWidth : List (Html msg)
equalWidth =
    [ h2 [] [ text "Equal-width" ]
    , p [] [ text "Here is an example of two grid layouts that apply to every device and viewport from XS (Extra Small) to XL (Extra Large)." ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [] [ text "1 of 2" ]
                , Grid.col [] [ text "2 of 2" ]
                ]
            , Grid.row []
                [ Grid.col [] [ text "1 of 3" ]
                , Grid.col [] [ text "2 of 3" ]
                , Grid.col [] [ text "3 of 3" ]
                ]
            ]
        ]
    , Util.code equalWidthCode
    ]


equalWidthCode : Html msg
equalWidthCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col [] [ text "1 of 2"]
        , Grid.col [] [ text "2 of 2"]
        ]
    , Grid.row []
        [ Grid.col [] [ text "1 of 3"]
        , Grid.col [] [ text "2 of 3"]
        , Grid.col [] [ text "3 of 3"]
        ]
    ]
"""


oneColWidth : List (Html msg)
oneColWidth =
    [ h2 [] [ text "Setting one column width" ]
    , p [] [ text """Auto-layout for flexbox grid columns also means you can set the width of one column and the others will automatically resize around it.
                    You may use predefined grid functions (as shown below), grid mixins (sass/less), or inline widths.
                    Note that the other columns will resize no matter the width of the center column.""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [] [ text "1 of 3" ]
                , Grid.col [ Col.xs6 ] [ text "2 of 3 (wider) " ]
                , Grid.col [] [ text "3 of 3" ]
                ]
            , Grid.row []
                [ Grid.col [] [ text "1 of 3" ]
                , Grid.col [ Col.xs5 ] [ text "2 of 3 (wider)" ]
                , Grid.col [] [ text "3 of 3" ]
                ]
            ]
        ]
    , Util.code oneColWidthCode
    , Util.calloutInfo
        [ p [] [ text "To set the width of a column use on of the Col width option functions." ] ]
    ]


oneColWidthCode : Html msg
oneColWidthCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col [] [ text "1 of 3"]
        , Grid.col [ Col.xs6 ] [ text "2 of 3 (wider) "]
        , Grid.col [] [ text "3 of 3"]
        ]
    , Grid.row []
        [ Grid.col [] [ text "1 of 3"]
        , Grid.col [ Col.xs5 ] [ text "2 of 3 (wider)"]
        , Grid.col [] [ text "3 of 3"]
        ]
    ]
"""


variableWidth : List (Html msg)
variableWidth =
    [ h2 [] [ text "Variable width content" ]
    , p [] [ text """Using the Col.{breakpoint}Auto functions, columns can size itself based on the natural width of its content.
                    This is super handy with single line content like inputs, numbers, etc.
                    This, in conjunction with horizontal alignment functions for rows, is very useful for centering layouts with uneven column sizes as viewport width changes.""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row [ Row.centerMd ]
                [ Grid.col
                    [ Col.xs, Col.lg2 ]
                    [ text "1 of 3" ]
                , Grid.col
                    [ Col.xs12, Col.mdAuto ]
                    [ text "Variable width content" ]
                , Grid.col
                    [ Col.xs, Col.lg2 ]
                    [ text "3 of 3" ]
                ]
            , Grid.row []
                [ Grid.col [] [ text "1 of 3" ]
                , Grid.col
                    [ Col.xs12, Col.mdAuto ]
                    [ text "Variable width content" ]
                , Grid.col
                    [ Col.xs, Col.lg2 ]
                    [ text "3 of 3" ]
                ]
            ]
        ]
    , Util.code variableWidthCode
    , Util.calloutWarning
        [ p [] [ text """If you don't define any col widths, it will default add a class `col`.
                     However when you do define widths **and** you want the col to remain a col for lesser breakpoints, you can achieve that by adding Col.xs (which basically adds the `col` class ).""" ] ]
    ]


variableWidthCode : Html msg
variableWidthCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row [ Row.horisontalAlign Row.centerMd ] -- horizontally center all cols in this row for breakpoint MD (medium) and up.
        [ Grid.col
            [ Col.xs, Col.lg2 ]
            [ text "1 of 3" ]
        , Grid.col
            [ Col.xs12, Col.mdAuto ]
            [ text "Variable width content" ]
        , Grid.col
            [ Col.xs, Col.lg2 ]
            [ text "3 of 3" ]
        ]
    , Grid.row []
        [ Grid.col [] [ text "1 of 3" ]
        , Grid.col
            [ Col.xs12, Col.mdAuto ]
            [ text "Variable width content" ]
        , Grid.col
            [ Col.xs, Col.lg2 ]
            [ text "3 of 3" ]
        ]
    ]
"""


multiRowCol : List (Html msg)
multiRowCol =
    [ h2 [] [ text "Equal-width multi-row" ]
    , p [] [ text """Create equal-width columns that span multiple rows by inserting Col.colBreak where you want the columns to break to a new line.
                    Make the breaks responsive by adding attributes with Bootstrap responsive display utilities (classes).""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [] [ text "col" ]
                , Grid.col [] [ text "col" ]
                , Grid.colBreak []
                , Grid.col [] [ text "col" ]
                , Grid.col [] [ text "col" ]
                ]
            ]
        ]
    , Util.code multiRowColCode
    ]


multiRowColCode : Html msg
multiRowColCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col [ ] [ text "col" ]
        , Grid.col [ ] [ text "col" ]
        , Grid.colBreak []
        , Grid.col [ ] [ text "col" ]
        , Grid.col [ ] [ text "col" ]
        ]
    ]
"""


stackedSm : List (Html msg)
stackedSm =
    [ h2 [] [ text "Stacked to horizontal" ]
    , p [] [ text """Using only Col.colSm* widths you can create a basic grid system that starts out stacked on extra small devices
                    before becoming horizontal on desktop (medium) devices.""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [ Col.sm8 ] [ text "col-sm-8" ]
                , Grid.col [ Col.sm4 ] [ text "col-sm-4" ]
                ]
            , Grid.row []
                [ Grid.col [ Col.sm ] [ text "col-sm" ]
                , Grid.col [ Col.sm ] [ text "col-sm" ]
                , Grid.col [ Col.sm ] [ text "col-sm" ]
                ]
            ]
        ]
    , Util.code stackedSmCode
    ]


stackedSmCode : Html msg
stackedSmCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col [ Col.sm8 ] [ text "col-sm-8" ]
        , Grid.col [ Col.sm4] [ text "col-sm-4" ]
        ]
    , Grid.row []
        [ Grid.col [ Col.sm ] [ text "col-sm" ]
        , Grid.col [ Col.sm ] [ text "col-sm" ]
        , Grid.col [ Col.sm ] [ text "col-sm" ]
        ]
    ]
"""


mixMatch : List (Html msg)
mixMatch =
    [ h2 [] [ text "Mix and match" ]
    , p [] [ text """Don’t want your columns to simply stack in some grid tiers?
                    Use a combination of different Column width options  for each tier as needed.
                    See the example below for a better idea of how it all works.""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col
                    [ Col.xs, Col.md8 ]
                    [ text "col col-md-8" ]
                , Grid.col
                    [ Col.xs6, Col.md4 ]
                    [ text "col-6 col-md-4" ]
                ]
            , Grid.row []
                [ Grid.col
                    [ Col.xs6, Col.md4 ]
                    [ text "col-6 col-md-4" ]
                , Grid.col
                    [ Col.xs6, Col.md4 ]
                    [ text "col-6 col-md-4" ]
                , Grid.col
                    [ Col.xs6, Col.md4 ]
                    [ text "col-6 col-md-4" ]
                ]
            , Grid.row []
                [ Grid.col [ Col.xs6 ] [ text "col-6" ]
                , Grid.col [ Col.xs6 ] [ text "col-6" ]
                ]
            ]
        ]
    , Util.code mixMatchCode
    ]


mixMatchCode : Html msg
mixMatchCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col
            [ Col.xs, Col.md8 ]
            [ text "col col-md-8" ]
        , Grid.col
            [ Col.xs6, Col.md4 ]
            [ text "col-6 col-md-4" ]
        ]
    , Grid.row []
        [ Grid.col
            [  Col.xs6, Col.md4 ]
            [ text "col-6 col-md-4" ]
        , Grid.col
            [  Col.xs6, Col.md4 ]
            [ text "col-6 col-md-4" ]
        , Grid.col
            [  Col.xs6, Col.md4 ]
            [ text "col-6 col-md-4" ]
        ]
    , Grid.row []
        [ Grid.col [ Col.xs6 ] [ text "col-6" ]
        , Grid.col [ Col.xs6 ] [ text "col-6" ]
        ]
    ]
"""


verticalAlign : List (Html msg)
verticalAlign =
    [ h2 [] [ text "Vertical alignment" ]
    , p [] [ text """Thanks to flexbox you can vertically align using align functions for either an entire row or individual columns.
                    Both the Row and Col module has functions that create these alignment options for you.""" ]
    , flexExampleRow
        [ Grid.container []
            [ Grid.row
                [ Row.topXs ]
                threeSimpleCols
            , Grid.row
                [ Row.middleXs ]
                threeSimpleCols
            , Grid.row
                [ Row.bottomXs ]
                threeSimpleCols
            ]
        ]
    , Util.code verticalAlignRowCode
    , flexExampleRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col
                    [ Col.topXs ]
                    [ text "One of three columns" ]
                , Grid.col
                    [ Col.middleXs ]
                    [ text "One of three columns" ]
                , Grid.col
                    [ Col.bottomXs ]
                    [ text "One of three columns" ]
                ]
            ]
        ]
    , Util.code verticalAlignColCode
    ]


threeSimpleCols : List (Grid.Column msg)
threeSimpleCols =
    List.repeat 3 <| Grid.col [] [ text "One of three columns" ]


verticalAlignRowCode : Html msg
verticalAlignRowCode =
    Util.toMarkdownElm """

myGrid : Html msg
myGrid =
    Grid.container []
        [ Grid.row
            [ Row.topXs ]
            threeSimpleCols
        , Grid.row
            [ Row.middleXs ]
            threeSimpleCols
        , Grid.row
            [ Row.bottomXs ]
            threeSimpleCols
        ]


threeSimpleCols : List (Grid.Column msg)
threeSimpleCols =
    List.repeat 3 <| Grid.col [] [ text "One of three columns" ]
"""


verticalAlignColCode : Html msg
verticalAlignColCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col
            [ Col.topXs ]
            [ text "One of three columns" ]
        , Grid.col
            [ Col.middleXs ]
            [ text "One of three columns" ]
        , Grid.col
            [ Col.bottomXs ]
            [ text "One of three columns" ]
        ]
    ]
"""

horizontalAlign : List (Html msg)
horizontalAlign =
    [ h2 [] [ text "Horizontal alignment" ]
    , p [] [ text """You can easily horizontally align your columns in a row using the horizontal align options functions in the Row module.""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row
                [ Row.leftXs ]
                twoSimpleCols
            , Grid.row
                [ Row.centerXs ]
                twoSimpleCols
            , Grid.row
                [ Row.rightXs ]
                twoSimpleCols
            , Grid.row
                [ Row.aroundXs ]
                twoSimpleCols
            , Grid.row
                [ Row.betweenXs ]
                twoSimpleCols
            ]
        ]
    , Util.code horizontalAlignCode
    ]

twoSimpleCols : List (Grid.Column msg)
twoSimpleCols =
    List.repeat 2 <|
        Grid.col [ Col.xs4 ] [ text "One of two columns" ]


horizontalAlignCode : Html msg
horizontalAlignCode =
    Util.toMarkdownElm """

myGrid : Html msg
myGrid =
    Grid.container []
        [ Grid.row
            [ Row.leftXs ]
            twoSimpleCols
        , Grid.row
            [ Row.centerXs ]
            twoSimpleCols
        , Grid.row
            [ Row.rightXs ]
            twoSimpleCols
        , Grid.row
            [ Row.aroundXs ]
            twoSimpleCols
        , Grid.row
            [ Row.betweenXs ]
            twoSimpleCols
        ]

twoSimpleCols : List (Grid.Column msg)
twoSimpleCols =
    List.repeat 2 <|
        Grid.col [ Col.xs4 ] [ text "One of two columns" ]
"""

offsets : List (Html msg)
offsets =
    [ h2 [] [ text "Offsetting columns" ]
    , p [] [ text """You can move columns to the right using the Col.offset* functions.
                    For example, Col.offsetMd4 moves the given column 4 column widhts to the right for the medium and up screensizes.""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col [ Col.md4 ] [ text "col-md-4" ]
                , Grid.col
                    [ Col.md4, Col.offsetMd4 ]
                    [ text "col-md-4 offset-md-4" ]
                ]
            , Grid.row []
                [ Grid.col
                    [ Col.md3, Col.offsetMd3 ]
                    [ text "col-md-3 offset-md-3" ]
                , Grid.col
                    [ Col.md3, Col.offsetMd3 ]
                    [ text "col-md-3 offset-md-3" ]
                ]
            , Grid.row []
                [ Grid.col
                    [ Col.md6, Col.offsetMd3 ]
                    [ text "col-md-6 offset-md-3" ]
                ]
            ]
        ]
    , Util.code offsetsCode
    ]


offsetsCode : Html msg
offsetsCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col [ Col.md4 ] [ text "col-md-4" ]
        , Grid.col
            [ Col.md4, Col.offsetMd4 ]
            [ text "col-md-4 offset-md-4" ]
        ]
    , Grid.row []
        [ Grid.col
            [ Col.md3, Col.offsetMd3 ]
            [ text "col-md-3 offset-md-3" ]
        , Grid.col
            [ Col.md3, Col.offsetMd3 ]
            [ text "col-md-3 offset-md-3" ]
        ]
    , Grid.row []
        [ Grid.col
            [ Col.md6, Col.offsetMd3 ]
            [ text "col-md-6 offset-md-3" ]
        ]
    ]
"""


pushPull : List (Html msg)
pushPull =
    [ h2 [] [ text "Push and pull" ]
    , p [] [ text """Change the order of columns by using the Col.push* or Col.pull* functions.""" ]
    , exampleOneRow
        [ Grid.container []
            [ Grid.row []
                [ Grid.col
                    [ Col.md9, Col.pushMd3 ]
                    [ text "col-md-9 push-md-3"]
                , Grid.col
                    [ Col.md3, Col.pullMd9 ]
                    [ text "col-md-3 pull-md-9" ]
                ]
            ]
        ]
    , Util.code pushPullCode
    ]


pushPullCode : Html msg
pushPullCode =
    Util.toMarkdownElm """
Grid.container []
    [ Grid.row []
        [ Grid.col
            [ Col.md9, Col.pushMd3 ]
            [ text "col-md-9 push-md-3"]
        , Grid.col
            [ Col.md3, Col.pullMd9 ]
            [ text "col-md-3 pull-md-9" ]
        ]
    ]
"""
