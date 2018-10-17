module Bootstrap.Grid exposing
    ( container, containerFluid
    , row, simpleRow, keyedRow
    , col, colBreak, keyedCol, Column
    )

{-| Bootstrap includes a powerful mobile-first flexbox grid system for building layouts of all shapes and sizes. It’s based on a 12 column layout and has multiple tiers, one for each media query range.

    Grid.container
        [ Grid.row
            [ Row.topXs ]
            [ Grid.col
                [ Col.xs4 ]
                [ text "col1-row1" ]
            , Grid.col
                [ Col.xs8 ]
                [ text "col2-row1" ]
            ]
        , Grid.simpleRow
            [ Grid.col
                [ Col.xs4 ]
                [ text "col1-row2" ]
            , Grid.col
                [ Col.xs6 ]
                [ text "col2-row2" ]
            ]
        ]


# Containers

@docs container, containerFluid


# Rows

@docs row, simpleRow, keyedRow


# Columns

@docs col, colBreak, keyedCol, Column

-}

import Bootstrap.Grid.Col as Col
import Bootstrap.Grid.Internal as GridInternal
import Bootstrap.Grid.Row as Row
import Html exposing (Attribute, Html, div)
import Html.Attributes exposing (class, classList)
import Html.Keyed as Keyed


{-| Opaque type representing a column element
-}
type Column msg
    = Column
        { options : List (GridInternal.ColOption msg)
        , children : List (Html msg)
        }
    | ColBreak (Html.Html msg)
    | KeyedColumn
        { options : List (GridInternal.ColOption msg)
        , children : List ( String, Html msg )
        }


{-| Responsive fixed width container, which changes its max-width at breakpoint
-}
container : List (Attribute msg) -> List (Html msg) -> Html msg
container attributes children =
    div ([ class "container" ] ++ attributes) children


{-| Full width container spanning the entire viewport
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

  - `options` List of row options
  - `cols` List of columns

-}
row : List (Row.Option msg) -> List (Column msg) -> Html msg
row options cols =
    div
        (GridInternal.rowAttributes options)
        (List.map renderCol cols)


{-| Create a row with keyed columns. Handy when you need to move columns around without getting massive rerenders.

  - `options` List of row options
  - `keydCols` List of key, column tuples

-}
keyedRow : List (Row.Option msg) -> List ( String, Column msg ) -> Html msg
keyedRow options keyedCols =
    Keyed.node "div"
        (GridInternal.rowAttributes options)
        (List.map (\( key, col_ ) -> ( key, renderCol col_ )) keyedCols)


{-| Create a column

  - `options` List of column options
  - `children` List of child elments

-}
col : List (Col.Option msg) -> List (Html msg) -> Column msg
col options children =
    Column
        { options = options
        , children = children
        }


{-| Create a column with keyed children

  - `options` List of column options
  - `keyedChildren` List of key,element child element tuples

-}
keyedCol : List (Col.Option msg) -> List ( String, Html msg ) -> Column msg
keyedCol options children =
    KeyedColumn
        { options = options
        , children = children
        }


{-| Creates a full width column with no content. Handy for creating equal width multi-row columns.
-}
colBreak : List (Html.Attribute msg) -> Column msg
colBreak attributes =
    ColBreak <|
        Html.div
            ([ class "w-100" ] ++ attributes)
            []


renderCol : Column msg -> Html msg
renderCol column =
    case column of
        Column { options, children } ->
            div
                (GridInternal.colAttributes options)
                children

        ColBreak e ->
            e

        KeyedColumn { options, children } ->
            Keyed.node "div"
                (GridInternal.colAttributes options)
                children
