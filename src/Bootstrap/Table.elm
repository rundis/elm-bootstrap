module Bootstrap.Table
    exposing
        ( table
        , thead
        , tbody
        , keyedTBody
        , tr
        , keyedTr
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
        , responsiveSm
        , responsiveMd
        , responsiveLg
        , responsiveXl
        , inversedHead
        , defaultHead
        , rowActive
        , rowDanger
        , rowInfo
        , rowSuccess
        , rowWarning
        , rowPrimary
        , rowSecondary
        , rowLight
        , rowDark
        , cellActive
        , cellDanger
        , cellInfo
        , cellSuccess
        , cellWarning
        , cellPrimary
        , cellSecondary
        , cellLight
        , cellDark
        , THead
        , TBody
        , Row
        , Cell
        , TableOption
        , TableHeadOption
        , RowOption
        , CellOption
        )

{-| Create simple and customizable tables in a fairly type safe manner!


# Table

@docs simpleTable, table


## Table options

@docs inversed, striped, bordered, hover, small, responsive, responsiveSm, responsiveMd, responsiveLg, responsiveXl, attr, TableOption


# Table headers

@docs simpleThead, thead, headAttr, THead


## Header options

@docs defaultHead, inversedHead, TableHeadOption


# Table body

@docs tbody, keyedTBody, TBody


# Rows

@docs tr, keyedTr, Row


## Row options

@docs rowActive, rowPrimary, rowSecondary, rowInfo, rowSuccess, rowWarning, rowDanger, rowLight, rowDark, rowAttr, RowOption


# Cells

@docs td, th, Cell


## Cell options

@docs cellActive, cellPrimary, cellSecondary, cellInfo, cellSuccess, cellWarning, cellDanger, cellLight, cellDark, cellAttr, CellOption

-}

import Html
import Html.Attributes exposing (class)
import Html.Keyed as Keyed
import Bootstrap.Internal.Role as Role exposing (Role(..))
import Bootstrap.Grid.Internal as GridInternal


{-| Opaque type representing possible styling options for a table
-}
type TableOption msg
    = Inversed
    | Striped
    | Bordered
    | Hover
    | Small
    | Responsive (Maybe GridInternal.ScreenSize)
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
    = RoledRow RoledOrActive
    | InversedRow RoledOrActive
    | RowAttr (Html.Attribute msg)


{-| Opaque type representing possible styling options for a cell, ie td and th
-}
type CellOption msg
    = RoledCell RoledOrActive
    | InversedCell RoledOrActive
    | CellAttr (Html.Attribute msg)


type RoledOrActive
    = Roled Role
    | Active


{-| Opaque type representing a tr
-}
type Row msg
    = Row (RowConfig msg)
    | KeyedRow
        { options : List (RowOption msg)
        , cells : List ( String, Cell msg )
        }


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
    | KeyedTBody
        { attributes : List (Html.Attribute msg)
        , rows : List ( String, Row msg )
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


{-| Make table responsive for horizontally scrolling tables accross all breakpoints.
-}
responsive : TableOption msg
responsive =
    Responsive Nothing


{-| Make table responsive for up until the -sm breakpoint.
-}
responsiveSm : TableOption msg
responsiveSm =
    Responsive <| Just GridInternal.SM


{-| Make table responsive for up until the -md breakpoint.
-}
responsiveMd : TableOption msg
responsiveMd =
    Responsive <| Just GridInternal.MD


{-| Make table responsive for up until the -lg breakpoint.
-}
responsiveLg : TableOption msg
responsiveLg =
    Responsive <| Just GridInternal.LG


{-| Make table responsive for up until the -xl breakpoint.
-}
responsiveXl : TableOption msg
responsiveXl =
    Responsive <| Just GridInternal.XL


{-| Allows you to create a simple default table

  - (`thead`, `tbody`) - A tuple of a thead item and a tbody item

-}
simpleTable : ( THead msg, TBody msg ) -> Html.Html msg
simpleTable ( thead, tbody ) =
    table
        { options = []
        , thead = thead
        , tbody = tbody
        }


{-| When you need to customize a table element with a standard Html.Attribute, use this function to create it as a [`TableOption`](#TableOption)
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
            List.filter (\opt -> not (isResponsive opt)) options

        isInversed =
            List.any (\opt -> opt == Inversed) options
    in
        Html.table
            (tableAttributes classOptions)
            [ maybeMapInversedTHead isInversed thead |> renderTHead
            , maybeMapInversedTBody isInversed tbody |> renderTBody
            ]
            |> maybeWrapResponsive options


isResponsive : TableOption msg -> Bool
isResponsive option =
    case option of
        Responsive _ ->
            True

        _ ->
            False


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
maybeMapInversedTBody isTableInversed tbody =
    case ( isTableInversed, tbody ) of
        ( False, _ ) ->
            tbody

        ( True, TBody body ) ->
            TBody { body | rows = List.map mapInversedRow body.rows }

        ( True, KeyedTBody keyedBody ) ->
            KeyedTBody { keyedBody | rows = List.map (\( key, row ) -> ( key, mapInversedRow row )) keyedBody.rows }


mapInversedRow : Row msg -> Row msg
mapInversedRow row =
    let
        inversedOptions options =
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
        case row of
            Row { options, cells } ->
                Row
                    { options = inversedOptions options
                    , cells = List.map mapInversedCell cells
                    }

            KeyedRow { options, cells } ->
                KeyedRow
                    { options = inversedOptions options
                    , cells = List.map (\( key, cell ) -> ( key, mapInversedCell cell )) cells
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


maybeWrapResponsive : List (TableOption msg) -> Html.Html msg -> Html.Html msg
maybeWrapResponsive options table =
    let
        responsiveClass =
            List.filter isResponsive options
                |> List.head
                |> Maybe.andThen
                    (\opt ->
                        case opt of
                            Responsive val ->
                                val

                            _ ->
                                Nothing
                    )
                |> Maybe.andThen GridInternal.screenSizeOption
                |> Maybe.map (\v -> "-" ++ v)
                |> Maybe.withDefault ""
                |> (++) "table-responsive"
                |> class
    in
        if (List.any isResponsive options) then
            Html.div [ responsiveClass ] [ table ]
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


{-| When you need to customize a thead element with a standard Html.Attribute, use this function to create a [`TableHeadOption`](#TableHeadOption)
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

  - `options` List of options to style the thead element
  - `rows` List of rows (aka tr)

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

  - `attributes` List of standard Elm html attributes
  - `rows` List of table row elements (tr)

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


{-| Create a tbody element where each row is keyed

  - `attributes` List of standard Elm html attributes
  - `rows` List of key table row elements (tr) tuples

-}
keyedTBody :
    List (Html.Attribute msg)
    -> List ( String, Row msg )
    -> TBody msg
keyedTBody attributes rows =
    KeyedTBody
        { attributes = attributes
        , rows = rows
        }


renderTBody : TBody msg -> Html.Html msg
renderTBody body =
    case body of
        TBody { attributes, rows } ->
            Html.tbody
                attributes
                (List.map (\row -> maybeAddScopeToFirstCell row |> renderRow) rows)

        KeyedTBody { attributes, rows } ->
            Keyed.node "tbody"
                attributes
                (List.map (\( key, row ) -> ( key, maybeAddScopeToFirstCell row |> renderRow )) rows)


maybeAddScopeToFirstCell : Row msg -> Row msg
maybeAddScopeToFirstCell row =
    case row of
        Row { options, cells } ->
            case cells of
                [] ->
                    row

                first :: rest ->
                    Row
                        { options = options
                        , cells = (addScopeIfTh first) :: rest
                        }

        KeyedRow { options, cells } ->
            case cells of
                [] ->
                    row

                ( firstKey, first ) :: rest ->
                    KeyedRow
                        { options = options
                        , cells = ( firstKey, (addScopeIfTh first) ) :: rest
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


{-| Style a table row with the active color.
-}
rowActive : RowOption msg
rowActive =
    RoledRow Active


{-| Style a table row with the primary color.
-}
rowPrimary : RowOption msg
rowPrimary =
    RoledRow <| Roled Primary


{-| Style a table row with the secondary color.
-}
rowSecondary : RowOption msg
rowSecondary =
    RoledRow <| Roled Secondary


{-| Style a table row with the success color.
-}
rowSuccess : RowOption msg
rowSuccess =
    RoledRow <| Roled Success


{-| Style a table row with the warning color.
-}
rowWarning : RowOption msg
rowWarning =
    RoledRow <| Roled Warning


{-| Style a table row with the danger color.
-}
rowDanger : RowOption msg
rowDanger =
    RoledRow <| Roled Danger


{-| Style a table row with the info color.
-}
rowInfo : RowOption msg
rowInfo =
    RoledRow <| Roled Info


{-| Style a table row with the light color.
-}
rowLight : RowOption msg
rowLight =
    RoledRow <| Roled Light


{-| Style a table row with the dark color.
-}
rowDark : RowOption msg
rowDark =
    RoledRow <| Roled Dark


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
tr options cells =
    Row
        { options = options
        , cells = cells
        }


{-| Create a table row with keyed td or th child elements.
-}
keyedTr :
    List (RowOption msg)
    -> List ( String, Cell msg )
    -> Row msg
keyedTr options keyedCells =
    KeyedRow
        { options = options
        , cells = keyedCells
        }


{-| When you need to customize a td or th with standard Html.Attribute attributes, use this function
-}
cellAttr : Html.Attribute msg -> CellOption msg
cellAttr attr =
    CellAttr attr


{-| Option to style an individual cell with the active color
-}
cellActive : CellOption msg
cellActive =
    RoledCell Active


{-| Option to style an individual cell with the primary color
-}
cellPrimary : CellOption msg
cellPrimary =
    RoledCell <| Roled Primary


{-| Option to style an individual cell with the secondary color
-}
cellSecondary : CellOption msg
cellSecondary =
    RoledCell <| Roled Secondary


{-| Option to style an individual cell with the success color
-}
cellSuccess : CellOption msg
cellSuccess =
    RoledCell <| Roled Success


{-| Option to style an individual cell with the warning color
-}
cellWarning : CellOption msg
cellWarning =
    RoledCell <| Roled Warning


{-| Option to style an individual cell with the danger color
-}
cellDanger : CellOption msg
cellDanger =
    RoledCell <| Roled Danger


{-| Option to style an individual cell with the info color
-}
cellInfo : CellOption msg
cellInfo =
    RoledCell <| Roled Info


{-| Option to style an individual cell with the light color
-}
cellLight : CellOption msg
cellLight =
    RoledCell <| Roled Light


{-| Option to style an individual cell with the dark color
-}
cellDark : CellOption msg
cellDark =
    RoledCell <| Roled Dark


{-| Create a td element

    Table.td [ Table.cellInfo ] [ text "Some info cell"]

  - `options` List of options for customizing
  - `children` List of child elements

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

  - `options` List of options for customizing
  - `children` List of child elements

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
renderRow row =
    case row of
        Row { options, cells } ->
            Html.tr
                (rowAttributes options)
                (List.map renderCell cells)

        KeyedRow { options, cells } ->
            Keyed.node "tr"
                (rowAttributes options)
                (List.map (\( key, cell ) -> ( key, renderCell cell )) cells)


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
                |> List.filterMap identity
           )


tableClass : TableOption msg -> Maybe (Html.Attribute msg)
tableClass option =
    case option of
        Inversed ->
            Just <| class "table-dark"

        Striped ->
            Just <| class "table-striped"

        Bordered ->
            Just <| class "table-bordered"

        Hover ->
            Just <| class "table-hover"

        Small ->
            Just <| class "table-sm"

        Responsive _ ->
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
            class <| "thead-dark"

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
        RoledRow (Roled role) ->
            Role.toClass "table" role

        RoledRow Active ->
            class "table-active"

        InversedRow (Roled role) ->
            Role.toClass "bg" role

        InversedRow Active ->
            class "bg-active"

        RowAttr attr ->
            attr


cellAttributes : List (CellOption msg) -> List (Html.Attribute msg)
cellAttributes options =
    List.map cellAttribute options


cellAttribute : CellOption msg -> Html.Attribute msg
cellAttribute option =
    case option of
        RoledCell (Roled role) ->
            Role.toClass "table" role

        RoledCell Active ->
            class "table-active"

        InversedCell (Roled role) ->
            Role.toClass "bg-" role

        InversedCell Active ->
            class "bg-active"

        CellAttr attr ->
            attr
