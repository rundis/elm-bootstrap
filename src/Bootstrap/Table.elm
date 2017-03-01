module Bootstrap.Table
    exposing
        ( table
        , thead
        , tbody
        , tr
        , td
        , th
        , simpleTable
        , simpleThead
        , attr
        , headAttr
        , rowAttr
        , cellAttr
        , inversed
        , striped
        , bordered
        , hover
        , small
        , responsive
        , reflow
        , inversedHead
        , defaultHead
        , rowActive
        , rowDanger
        , rowInfo
        , rowSuccess
        , rowWarning
        , cellActive
        , cellDanger
        , cellInfo
        , cellSuccess
        , cellWarning
        , THead
        , TBody
        , Row
        , Cell
        , TableOption
        , TableHeadOption
        , RowOption
        , CellOption
        )

{-| Create simple nice and customizable tables in a fairly type safe manner !

# Table
@docs simpleTable, table

## Table options
@docs inversed, striped, bordered, hover, small, responsive, reflow, attr, TableOption


# Table headers
@docs simpleThead, thead, headAttr, THead


## Header options
@docs defaultHead, inversedHead, TableHeadOption


# Table body
@docs tbody, TBody


# Rows
@docs tr, Row

## Row options
@docs rowActive, rowInfo, rowSuccess, rowWarning, rowDanger, rowAttr, RowOption


# Cells
@docs td, th, Cell

## Cell options
@docs cellActive, cellInfo, cellSuccess, cellWarning, cellDanger, cellAttr, CellOption

-}
import Html
import Html.Attributes exposing (class)


{-| Opaque type representing possible styling options for a table
-}
type TableOption msg
    = Inversed
    | Striped
    | Bordered
    | Hover
    | Small
    | Responsive
    | Reflow
    | TableAttr (Html.Attribute msg)


{-| Opaque type representing possible styling options for a thead element
-}
type TableHeadOption msg
    = InversedHead
    | DefaultHead
    | HeadAttr (Html.Attribute msg)


{-| Opaque type representing possible styling options for a tr element (both in thead and tbody)
-}
type RowOption msg
    = RoledRow Role
    | InversedRow Role
    | RowAttr (Html.Attribute msg)


{-| Opaque type representing possible styling options for a cell, ie td and th
-}
type CellOption msg
    = RoledCell Role
    | InversedCell Role
    | CellAttr (Html.Attribute msg)


type Role
    = Active
    | Success
    | Warning
    | Danger
    | Info

{-| Opaque type representing a tr
-}
type Row msg
    = Row (RowConfig msg)


type alias RowConfig msg =
    { options : List (RowOption msg)
    , cells : List (Cell msg)
    }

{-| Opaque type representing a cell (tr or td)
-}
type Cell msg
    = Td (CellConfig msg)
    | Th (CellConfig msg)


type alias CellConfig msg =
    { options : List (CellOption msg)
    , children : List (Html.Html msg)
    }

{-| Opaque type representing a thead element
-}
type THead msg
    = THead
        { options : List (TableHeadOption msg)
        , rows : List (Row msg)
        }


{-| Opaque type representing a tbody element
-}
type TBody msg
    = TBody
        { attributes : List (Html.Attribute msg)
        , rows : List (Row msg)
        }


{-| Option to give a table an inversed color scheme (dark backround, light text)
-}
inversed : TableOption msg
inversed =
    Inversed


{-| Option to give a table a striped look (zebra style)
-}
striped : TableOption msg
striped =
    Striped


{-| Option to put borders around a table
-}
bordered : TableOption msg
bordered =
    Bordered


{-| Change row coloring to highlight row when hovered over
-}
hover : TableOption msg
hover =
    Hover


{-| Option to give a more condensed table with less padding/margins
-}
small : TableOption msg
small =
    Small


{-| Make table scroll horizontally on small devices (under 768px). When viewing on anything larger than 768px wide, you will not see any difference in the table.
-}
responsive : TableOption msg
responsive =
    Responsive

{-| Turn traditional tables on their side. When using reflow, the table header becomes the first column of the table, the first row within the table body becomes the second column, the second row becomes the third column, etc. Only works out nicely for simple tables (e.g. no colspans, rowspans or multiple header rows etc.)
-}
reflow : TableOption msg
reflow =
    Reflow


{-| Allows you to create a simple default table


* (`thead`, `tbody`) - A tuple of a thead item and a tbody item

-}
simpleTable : (THead msg,  TBody msg) -> Html.Html msg
simpleTable (thead, tbody) =
    table
        { options = []
        , thead = thead
        , tbody = tbody
        }

{-| When you need to customize the table element with standard Html.Attribute, use this function to create it as a [`TableOption`](#TableOption)
-}
attr : Html.Attribute msg -> TableOption msg
attr attr =
    TableAttr attr

{-| Create a customizable table

    Table.table
        { options = [ Table.striped ] -- list of table options
        , thead = Table.thead ... etc
        , tbody = Table.tbody ... etc
        }

-}
table :
    { options : List (TableOption msg)
    , thead : THead msg
    , tbody : TBody msg
    }
    -> Html.Html msg
table { options, thead, tbody } =
    let
        classOptions =
            List.filter (\opt -> opt /= Responsive) options

        isResponsive =
            List.any (\opt -> opt == Responsive) options

        isInversed =
            List.any (\opt -> opt == Inversed) options
    in
        Html.table
            (tableAttributes classOptions)
            [ maybeMapInversedTHead isInversed thead |> renderTHead
            , maybeMapInversedTBody isInversed tbody |> renderTBody
            ]
            |> wrapResponsiveWhen isResponsive


maybeMapInversedTHead : Bool -> THead msg -> THead msg
maybeMapInversedTHead isTableInversed (THead thead) =
    let
        isHeadInversed =
            List.any (\opt -> opt == InversedHead) thead.options
    in
        (if (isTableInversed || isHeadInversed) then
            { thead | rows = List.map mapInversedRow thead.rows }
         else
            thead
        )
            |> THead


maybeMapInversedTBody : Bool -> TBody msg -> TBody msg
maybeMapInversedTBody isTableInversed (TBody tbody) =
    (if isTableInversed then
        { tbody | rows = List.map mapInversedRow tbody.rows }
     else
        tbody
    )
        |> TBody


mapInversedRow : Row msg -> Row msg
mapInversedRow ((Row { options, cells }) as row) =
    let
        inversedOptions =
            List.map
                (\opt ->
                    case opt of
                        RoledRow role ->
                            InversedRow role

                        _ ->
                            opt
                )
                options
    in
        Row
            { options = inversedOptions
            , cells = List.map mapInversedCell cells
            }


mapInversedCell : Cell msg -> Cell msg
mapInversedCell cell =
    let
        inverseOptions options =
            List.map
                (\opt ->
                    case opt of
                        RoledCell role ->
                            InversedCell role

                        _ ->
                            opt
                )
                options
    in
        case cell of
            Th cellCfg ->
                Th { cellCfg | options = inverseOptions cellCfg.options }

            Td cellCfg ->
                Td { cellCfg | options = inverseOptions cellCfg.options }


wrapResponsiveWhen : Bool -> Html.Html msg -> Html.Html msg
wrapResponsiveWhen isResponsive table =
    if isResponsive then
        Html.div
            [ class "table-responsive" ]
            [ table ]
    else
        table

{-| Option to inverse thead element. Dark background and light text color
-}
inversedHead : TableHeadOption msg
inversedHead =
    InversedHead

{-| Option to color header with default color scheme.
-}
defaultHead : TableHeadOption msg
defaultHead =
    DefaultHead


{-| When you need to customize the thead element with standard Html.Attribute, use this function to create a [`TableHeadOption`](#TableHeadOption)
-}
headAttr : Html.Attribute msg -> TableHeadOption msg
headAttr attr =
    HeadAttr attr


{-| Create a default thead with one row of cells (typically th elements)

    simpleThead
        [ Table.th [] [ text "Col1" ]
        , Table.th [] [ text "Col2" ]
        ]

-}
simpleThead : List (Cell msg) -> THead msg
simpleThead cells =
    thead [] [ tr [] cells ]



{-| Create a customizable thead element

* `options` List of options to style the thead element
* `rows` List of rows (aka tr)
-}
thead :
    List (TableHeadOption msg)
    -> List (Row msg)
    -> THead msg
thead options rows =
    THead
        { options = options
        , rows = rows
        }


renderTHead : THead msg -> Html.Html msg
renderTHead (THead { options, rows }) =
    Html.thead
        (theadAttributes options)
        (List.map renderRow rows)



{-| Create a tbody element

* `attributes` List of standard Elm html attributes
* `rows` List of table row elements (tr)

-}
tbody :
    List (Html.Attribute msg)
    -> List (Row msg)
    -> TBody msg
tbody attributes rows =
    TBody
        { attributes = attributes
        , rows = rows
        }


renderTBody : TBody msg -> Html.Html msg
renderTBody (TBody { attributes, rows }) =
    Html.tbody
        attributes
        (List.map (\row -> maybeAddScopeToFirstCell row |> renderRow) rows)


maybeAddScopeToFirstCell : Row msg -> Row msg
maybeAddScopeToFirstCell ((Row { options, cells }) as row) =
    case cells of
        [] ->
            row

        first :: rest ->
            Row
                { options = options
                , cells = (addScopeIfTh first) :: rest
                }


addScopeIfTh : Cell msg -> Cell msg
addScopeIfTh cell =
    case cell of
        Th cellConfig ->
            Th
                { cellConfig
                    | options = (cellAttr <| Html.Attributes.scope "row") :: cellConfig.options
                }

        Td _ ->
            cell

{-| Style table row with active color.
-}
rowActive : RowOption msg
rowActive =
    RoledRow Active


{-| Style table row with success color.
-}
rowSuccess : RowOption msg
rowSuccess =
    RoledRow Success


{-| Style table row with warning color.
-}
rowWarning : RowOption msg
rowWarning =
    RoledRow Warning


{-| Style table row with danger color.
-}
rowDanger : RowOption msg
rowDanger =
    RoledRow Danger


{-| Style table row with info color.
-}
rowInfo : RowOption msg
rowInfo =
    RoledRow Info


{-| When you need to customize a tr element with standard Html.Attribute attributes, use this function
-}
rowAttr : Html.Attribute msg -> RowOption msg
rowAttr attr =
    RowAttr attr



{-| Create a table row

    -- For use (typically) in a tbody
    Table.tr
        [ Table.rowInfo ]
        [ Table.td [] [ text "Some cell" ]
        , Table.td [] [ text "Another cell" ]
        ]

    -- alternatively when creating a thead
    Table.tr
        [ Table.rowInfo ]
        [ Table.th [] [ text "Col1" ]
        , Table.th [] [ text "Col2" ]
        ]

-}
tr :
    List (RowOption msg)
    -> List (Cell msg)
    -> Row msg
tr options cells  =
    Row
        { options = options
        , cells = cells
        }

{-| When you need to customize a td or th with standard Html.Attribute attributes, use this function
-}
cellAttr : Html.Attribute msg -> CellOption msg
cellAttr attr =
    CellAttr attr

{-| Option to style an individual cell with active color
-}
cellActive : CellOption msg
cellActive =
    RoledCell Active


{-| Option to style an individual cell with success color
-}
cellSuccess : CellOption msg
cellSuccess =
    RoledCell Success


{-| Option to style an individual cell with warning color
-}
cellWarning : CellOption msg
cellWarning =
    RoledCell Warning


{-| Option to style an individual cell with danger color
-}
cellDanger : CellOption msg
cellDanger =
    RoledCell Danger


{-| Option to style an individual cell with info color
-}
cellInfo : CellOption msg
cellInfo =
    RoledCell Info


{-| Create a td element

    Table.td [ Table.cellInfo ] [ text "Some info cell"]

* `options` List of options for customizing
* `children` List of child elements

-}
td :
    List (CellOption msg)
    -> List (Html.Html msg)
    -> Cell msg
td options children =
    Td
        { options = options
        , children = children
        }

{-| Create a th element

    Table.th [ Table.cellInfo ] [ text "Some info header cell"]

* `options` List of options for customizing
* `children` List of child elements

-}
th :
    List (CellOption msg)
    -> List (Html.Html msg)
    -> Cell msg
th options children =
    Th
        { options = options
        , children = children
        }


renderRow : Row msg -> Html.Html msg
renderRow (Row { options, cells }) =
    Html.tr
        (rowAttributes options )
        (List.map renderCell cells)


renderCell : Cell msg -> Html.Html msg
renderCell cell =
    case cell of
        Td { options, children } ->
            Html.td
                (cellAttributes options)
                children

        Th { options, children } ->
            Html.th
                (cellAttributes options)
                children


tableAttributes : List (TableOption msg) -> List (Html.Attribute msg)
tableAttributes options =
    (class "table")
        :: (List.map tableClass options
            |> List.filterMap identity)


tableClass : (TableOption msg) -> Maybe (Html.Attribute msg)
tableClass option =
    case option of
        Inversed ->
            Just <| class "table-inverse"

        Striped ->
            Just <| class "table-striped"

        Bordered ->
            Just <| class "table-bordered"

        Hover ->
            Just <| class "table-hover"

        Small ->
            Just <| class "table-sm"

        Responsive ->
            Nothing

        Reflow ->
            Just <| class "table-reflow"

        TableAttr attr ->
            Just attr


theadAttributes : List (TableHeadOption msg) -> List (Html.Attribute msg)
theadAttributes options =
    List.map theadAttribute options


theadAttribute : TableHeadOption msg -> Html.Attribute msg
theadAttribute option =
        case option of
            InversedHead ->
                class <| "thead-inverse"

            DefaultHead ->
                class <| "thead-default"

            HeadAttr attr ->
                attr


rowAttributes : List (RowOption msg) -> List (Html.Attribute msg)
rowAttributes options =
    List.map rowClass options


rowClass : RowOption msg -> Html.Attribute msg
rowClass option =
    case option of
        RoledRow role ->
            class <| "table-" ++ roleOption role

        InversedRow role ->
            class <| "bg-" ++ roleOption role

        RowAttr attr ->
            attr


cellAttributes : List (CellOption msg) -> List (Html.Attribute msg)
cellAttributes options =
    List.map cellAttribute options



cellAttribute : CellOption msg -> Html.Attribute msg
cellAttribute option =
        case option of
            RoledCell role ->
                class <| "table-" ++ roleOption role

            InversedCell role ->
                class <| "bg-" ++ roleOption role

            CellAttr attr ->
                attr


roleOption : Role -> String
roleOption role =
    case role of
        Active ->
            "active"

        Success ->
            "success"

        Warning ->
            "warning"

        Danger ->
            "danger"

        Info ->
            "info"
