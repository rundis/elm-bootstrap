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
        , simpleTbody
        , simpleTr
        , simpleTh
        , simpleTd
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

import Html
import Html.Attributes exposing (class)


type TableOption
    = Inversed
    | Striped
    | Bordered
    | Hover
    | Small
    | Responsive
    | Reflow


type TableHeadOption
    = InversedHead
    | DefaultHead


type RowOption
    = RoledRow Role
    | InversedRow Role


type CellOption
    = RoledCell Role
    | InversedCell Role


type Role
    = Active
    | Success
    | Warning
    | Danger
    | Info


type Row msg
    = Row
        { options : List RowOption
        , attributes : List (Html.Attribute msg)
        , cells : List (Cell msg)
        }


type Cell msg
    = Td (CellConfig msg)
    | Th (CellConfig msg)


type alias CellConfig msg =
    { options : List CellOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type THead msg
    = THead
        { options : List TableHeadOption
        , attributes : List (Html.Attribute msg)
        , rows : List (Row msg)
        }


type TBody msg
    = TBody
        { attributes : List (Html.Attribute msg)
        , rows : List (Row msg)
        }


inversed : TableOption
inversed =
    Inversed


striped : TableOption
striped =
    Striped


bordered : TableOption
bordered =
    Bordered


hover : TableOption
hover =
    Hover


small : TableOption
small =
    Small


responsive : TableOption
responsive =
    Responsive


reflow : TableOption
reflow =
    Reflow



simpleTable : (THead msg,  TBody msg) -> Html.Html msg
simpleTable (thead, tbody) =
    table
        { options = []
        , attributes = []
        , thead = thead
        , tbody = tbody
        }

table :
    { options : List TableOption
    , attributes : List (Html.Attribute msg)
    , thead : THead msg
    , tbody : TBody msg
    }
    -> Html.Html msg
table { options, attributes, thead, tbody } =
    let
        classOptions =
            List.filter (\opt -> opt /= Responsive) options

        isResponsive =
            List.any (\opt -> opt == Responsive) options

        isInversed =
            List.any (\opt -> opt == Inversed) options
    in
        Html.table
            (tableAttributes classOptions ++ attributes)
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
mapInversedRow ((Row { options, attributes, cells }) as row) =
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
            , attributes = attributes
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


inversedHead : TableHeadOption
inversedHead =
    InversedHead


defaultHead : TableHeadOption
defaultHead =
    DefaultHead


simpleThead : List (Cell msg) -> THead msg
simpleThead cells =
    thead
        { options = []
        , attributes = []
        , rows = [simpleTr cells]
        }


thead :
    { options : List TableHeadOption
    , attributes : List (Html.Attribute msg)
    , rows : List (Row msg)
    }
    -> THead msg
thead { options, attributes, rows } =
    THead
        { options = options
        , attributes = attributes
        , rows = rows
        }


renderTHead : THead msg -> Html.Html msg
renderTHead (THead { options, attributes, rows }) =
    Html.thead
        (theadAttributes options  ++ attributes)
        (List.map renderRow rows)



simpleTbody : List (Row msg) -> TBody msg
simpleTbody rows =
    tbody
        { attributes = []
        , rows = rows
        }

tbody :
    { attributes : List (Html.Attribute msg)
    , rows : List (Row msg)
    }
    -> TBody msg
tbody { attributes, rows } =
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
maybeAddScopeToFirstCell ((Row { options, attributes, cells }) as row) =
    case cells of
        [] ->
            row

        first :: rest ->
            Row
                { options = options
                , attributes = attributes
                , cells = (addScopeIfTh first) :: rest
                }


addScopeIfTh : Cell msg -> Cell msg
addScopeIfTh cell =
    case cell of
        Th { options, attributes, children } ->
            Th
                { options = options
                , attributes = (Html.Attributes.scope "row") :: attributes
                , children = children
                }

        Td _ ->
            cell


rowActive : RowOption
rowActive =
    RoledRow Active


rowSuccess : RowOption
rowSuccess =
    RoledRow Success


rowWarning : RowOption
rowWarning =
    RoledRow Warning


rowDanger : RowOption
rowDanger =
    RoledRow Danger


rowInfo : RowOption
rowInfo =
    RoledRow Info



simpleTr : List (Cell msg) -> Row msg
simpleTr cells =
    tr
        { options = []
        , attributes = []
        , cells = cells
        }

tr :
    { options : List RowOption
    , attributes : List (Html.Attribute msg)
    , cells : List (Cell msg)
    }
    -> Row msg
tr { options, attributes, cells } =
    Row
        { options = options
        , attributes = attributes
        , cells = cells
        }


cellActive : CellOption
cellActive =
    RoledCell Active


cellSuccess : CellOption
cellSuccess =
    RoledCell Success


cellWarning : CellOption
cellWarning =
    RoledCell Warning


cellDanger : CellOption
cellDanger =
    RoledCell Danger


cellInfo : CellOption
cellInfo =
    RoledCell Info


simpleTd : List (Html.Html msg) -> Cell msg
simpleTd children =
    td
        { options = []
        , attributes = []
        , children = children
        }

td :
    { options : List CellOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }
    -> Cell msg
td { options, attributes, children } =
    Td
        { options = options
        , attributes = attributes
        , children = children
        }

simpleTh : List (Html.Html msg) -> Cell msg
simpleTh children =
    th
        { options = []
        , attributes = []
        , children = children
        }

th :
    { options : List CellOption
    , attributes : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }
    -> Cell msg
th { options, attributes, children } =
    Th
        { options = options
        , attributes = attributes
        , children = children
        }


renderRow : Row msg -> Html.Html msg
renderRow (Row { options, attributes, cells }) =
    Html.tr
        (rowAttributes options ++ attributes)
        (List.map renderCell cells)


renderCell : Cell msg -> Html.Html msg
renderCell cell =
    case cell of
        Td { options, attributes, children } ->
            Html.td
                (cellAttributes options  ++ attributes)
                children

        Th { options, attributes, children } ->
            Html.th
                (cellAttributes options ++ attributes)
                children


tableAttributes : List TableOption -> List (Html.Attribute msg)
tableAttributes options =
    (class "table")
        :: List.map tableClass options


tableClass : TableOption -> Html.Attribute msg
tableClass option =
    (case option of
        Inversed ->
            "table-inverse"

        Striped ->
            "table-striped"

        Bordered ->
            "table-bordered"

        Hover ->
            "table-hover"

        Small ->
            "table-sm"

        Responsive ->
            ""

        Reflow ->
            "table-reflow")
            |> class


theadAttributes : List TableHeadOption -> List (Html.Attribute msg)
theadAttributes options =
    List.map theadClass options


theadClass : TableHeadOption -> Html.Attribute msg
theadClass option =
    class <|
        case option of
            InversedHead ->
                "thead-inverse"

            DefaultHead ->
                "thead-default"


rowAttributes : List RowOption -> List (Html.Attribute msg)
rowAttributes options =
    List.map rowClass options


rowClass : RowOption -> Html.Attribute msg
rowClass option =
    class <|
        case option of
            RoledRow role ->
                "table-" ++ roleOption role

            InversedRow role ->
                "bg-" ++ roleOption role


cellAttributes : List CellOption -> List (Html.Attribute msg)
cellAttributes options =
    List.map cellClass options



cellClass : CellOption -> Html.Attribute msg
cellClass option =
    class <|
        case option of
            RoledCell role ->
                "table-" ++ roleOption role

            InversedCell role ->
                "bg-" ++ roleOption role


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
