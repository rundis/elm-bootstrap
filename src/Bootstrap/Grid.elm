module Bootstrap.Grid
    exposing
        ( container
        , containerFluid
        , simpleRow
        , row
        , col
        , Column
        )

{-| Bootstrap includes a powerful mobile-first flexbox grid system for building layouts of all shapes and sizes. It’s based on a 12 column layout and has multiple tiers, one for each media query range.

    Grid.container
        [ Grid.row
            [ Row.verticalAlign Row.topXs ]
            [ Grid.col
                [ Col.width Col.xs4 ]
                [ text "col1-row1"]

            , Grid.col
                [ Col.width Col.xs8 ]
                [ text "col2-row1"]
            ]
        , Grid.simpleRow
            [ Grid.col
                [ Col.width Col.xs4 ]
                [ text "col1-row1"]

            , Grid.col
                [ Col.width Col.xs6 ]
                [ text "col2-row1"]

            ]

        ]

# Containers
@docs container, containerFluid

# Rows
@docs row, simpleRow


# Columns
@docs col, Column


-}

import Html exposing (Html, div, Attribute)
import Html.Attributes exposing (class, classList)
import Bootstrap.Grid.Internal as GridInternal2
import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Row as Row





{-| Opaque type represetning a column element
-}
type Column msg
    = Column
        { options : List (GridInternal2.ColOption msg)
        , children : List (Html msg)
        }


{-| Responsive fixed width container, which changes it's maz-width at breakpoint
-}
container : List (Attribute msg) -> List (Html msg) -> Html msg
container attributes children =
    div ([ class "container" ] ++ attributes) children


{-| Full width contaienr spanning the entire viewport
-}
containerFluid : List (Attribute msg) -> List (Html msg) -> Html msg
containerFluid attributes children =
    div ([ class "container-fluid" ] ++ attributes) children


{-| Create a row with no configuration options
-}
simpleRow : List (Column msg) -> Html msg
simpleRow cols =
    row [] cols


{-| Create a row

* `options` List of row options
* `cols` List of columns
-}
row : List (Row.RowOption msg) -> List (Column msg) -> Html msg
row options cols =
    div
        (GridInternal2.rowAttributes options)
        (List.map renderCol cols)


{-| Create a column

* `options` List of column options
* `cols` List of child elments
-}
col : List (Col.ColOption msg) -> List (Html msg) -> Column msg
col options children =
    Column
        { options = options
        , children = children
        }

renderCol : Column msg -> Html msg
renderCol (Column { options, children }) =
    div
        (GridInternal2.colAttributes options)
        children



