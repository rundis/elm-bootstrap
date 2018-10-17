module Bootstrap.Grid.Internal exposing (ColOption(..), ColOptions, ColumnCount(..), MoveCount(..), Offset, OffsetCount(..), Order, OrderCol(..), Pull, Push, RowOption(..), RowOptions, VAlign, VerticalAlign(..), Width, applyColAlign, applyColOffset, applyColOption, applyColOrder, applyColPull, applyColPush, applyColWidth, applyRowHAlign, applyRowOption, applyRowVAlign, colAttributes, colVAlign, colWidthClass, colWidthsToAttributes, columnCountOption, defaultColOptions, defaultRowOptions, hAlignsToAttributes, moveCountOption, offset, offsetClass, offsetCountOption, offsetsToAttributes, order, orderColOption, orderToAttributes, pull, pullsToAttributes, push, pushesToAttributes, rowAttributes, rowHAlign, rowVAlign, screenSizeToPartialString, vAlignClass, vAlignsToAttributes, verticalAlignOption, width)

import Bootstrap.General.Internal exposing (HAlign, HorizontalAlign(..), ScreenSize(..), hAlignClass, screenSizeOption)
import Bootstrap.Internal.Text as TextInternal
import Bootstrap.Text as Text
import Html
import Html.Attributes exposing (class)


type ColOption msg
    = ColWidth Width
    | ColOffset Offset
    | ColPull Pull
    | ColPush Push
    | ColOrder Order
    | ColAlign VAlign
    | ColAttrs (List (Html.Attribute msg))
    | TextAlign Text.HAlign


type RowOption msg
    = RowVAlign VAlign
    | RowHAlign HAlign
    | RowAttrs (List (Html.Attribute msg))


type alias Width =
    { screenSize : ScreenSize
    , columnCount : ColumnCount
    }


type alias Offset =
    { screenSize : ScreenSize
    , offsetCount : OffsetCount
    }


type alias Pull =
    { screenSize : ScreenSize
    , moveCount : MoveCount
    }


type alias Push =
    { screenSize : ScreenSize
    , moveCount : MoveCount
    }


type alias Order =
    { screenSize : ScreenSize
    , moveCount : OrderCol
    }


type alias VAlign =
    { screenSize : ScreenSize
    , align : VerticalAlign
    }


type ColumnCount
    = Col
    | Col1
    | Col2
    | Col3
    | Col4
    | Col5
    | Col6
    | Col7
    | Col8
    | Col9
    | Col10
    | Col11
    | Col12
    | ColAuto


type OffsetCount
    = Offset0
    | Offset1
    | Offset2
    | Offset3
    | Offset4
    | Offset5
    | Offset6
    | Offset7
    | Offset8
    | Offset9
    | Offset10
    | Offset11


type MoveCount
    = Move0
    | Move1
    | Move2
    | Move3
    | Move4
    | Move5
    | Move6
    | Move7
    | Move8
    | Move9
    | Move10
    | Move11
    | Move12


type OrderCol
    = OrderFirst
    | Order1
    | Order2
    | Order3
    | Order4
    | Order5
    | Order6
    | Order7
    | Order8
    | Order9
    | Order10
    | Order11
    | Order12
    | OrderLast


type VerticalAlign
    = Top
    | Middle
    | Bottom


type alias ColOptions msg =
    { attributes : List (Html.Attribute msg)
    , textAlign : Maybe Text.HAlign
    , widthXs : Maybe Width
    , widthSm : Maybe Width
    , widthMd : Maybe Width
    , widthLg : Maybe Width
    , widthXl : Maybe Width
    , offsetXs : Maybe Offset
    , offsetSm : Maybe Offset
    , offsetMd : Maybe Offset
    , offsetLg : Maybe Offset
    , offsetXl : Maybe Offset
    , pullXs : Maybe Pull
    , pullSm : Maybe Pull
    , pullMd : Maybe Pull
    , pullLg : Maybe Pull
    , pullXl : Maybe Pull
    , pushXs : Maybe Push
    , pushSm : Maybe Push
    , pushMd : Maybe Push
    , pushLg : Maybe Push
    , pushXl : Maybe Push
    , orderXs : Maybe Order
    , orderSm : Maybe Order
    , orderMd : Maybe Order
    , orderLg : Maybe Order
    , orderXl : Maybe Order
    , alignXs : Maybe VAlign
    , alignSm : Maybe VAlign
    , alignMd : Maybe VAlign
    , alignLg : Maybe VAlign
    , alignXl : Maybe VAlign
    }


type alias RowOptions msg =
    { attributes : List (Html.Attribute msg)
    , vAlignXs : Maybe VAlign
    , vAlignSm : Maybe VAlign
    , vAlignMd : Maybe VAlign
    , vAlignLg : Maybe VAlign
    , vAlignXl : Maybe VAlign
    , hAlignXs : Maybe HAlign
    , hAlignSm : Maybe HAlign
    , hAlignMd : Maybe HAlign
    , hAlignLg : Maybe HAlign
    , hAlignXl : Maybe HAlign
    }


width : ScreenSize -> ColumnCount -> ColOption msg
width size count =
    ColWidth <| Width size count


colVAlign : ScreenSize -> VerticalAlign -> ColOption msg
colVAlign size align =
    ColAlign <| VAlign size align


offset : ScreenSize -> OffsetCount -> ColOption msg
offset size count =
    ColOffset <| Offset size count


pull : ScreenSize -> MoveCount -> ColOption msg
pull size count =
    ColPull <| Pull size count


push : ScreenSize -> MoveCount -> ColOption msg
push size count =
    ColPush <| Push size count


order : ScreenSize -> OrderCol -> ColOption msg
order size count =
    ColOrder <| Order size count


rowVAlign : ScreenSize -> VerticalAlign -> RowOption msg
rowVAlign size align =
    RowVAlign <| VAlign size align


rowHAlign : ScreenSize -> HorizontalAlign -> RowOption msg
rowHAlign size align =
    RowHAlign <| HAlign size align


colAttributes : List (ColOption msg) -> List (Html.Attribute msg)
colAttributes modifiers =
    let
        options =
            List.foldl applyColOption defaultColOptions modifiers

        shouldAddDefaultXs =
            (List.filterMap identity
                [ options.widthXs
                , options.widthSm
                , options.widthMd
                , options.widthLg
                , options.widthXl
                ]
                |> List.length
            )
                == 0
    in
    colWidthsToAttributes
        [ if shouldAddDefaultXs then
            Just <| Width XS Col

          else
            options.widthXs
        , options.widthSm
        , options.widthMd
        , options.widthLg
        , options.widthXl
        ]
        ++ offsetsToAttributes
            [ options.offsetXs
            , options.offsetSm
            , options.offsetMd
            , options.offsetLg
            , options.offsetXl
            ]
        ++ pullsToAttributes
            [ options.pullXs
            , options.pullSm
            , options.pullMd
            , options.pullLg
            , options.pullXl
            ]
        ++ pushesToAttributes
            [ options.pushXs
            , options.pushSm
            , options.pushMd
            , options.pushLg
            , options.pushXl
            ]
        ++ orderToAttributes
            [ options.orderXs
            , options.orderSm
            , options.orderMd
            , options.orderLg
            , options.orderXl
            ]
        ++ vAlignsToAttributes "align-self-"
            [ options.alignXs
            , options.alignSm
            , options.alignMd
            , options.alignLg
            , options.alignXl
            ]
        ++ (case options.textAlign of
                Just a ->
                    [ TextInternal.textAlignClass a ]

                Nothing ->
                    []
           )
        ++ options.attributes


rowAttributes : List (RowOption msg) -> List (Html.Attribute msg)
rowAttributes modifiers =
    let
        options =
            List.foldl applyRowOption defaultRowOptions modifiers
    in
    [ class "row" ]
        ++ vAlignsToAttributes "align-items-"
            [ options.vAlignXs
            , options.vAlignSm
            , options.vAlignMd
            , options.vAlignLg
            , options.vAlignXl
            ]
        ++ hAlignsToAttributes
            [ options.hAlignXs
            , options.hAlignSm
            , options.hAlignMd
            , options.hAlignLg
            , options.hAlignXl
            ]
        ++ options.attributes


applyColOption : ColOption msg -> ColOptions msg -> ColOptions msg
applyColOption modifier options =
    case modifier of
        ColAttrs attrs ->
            { options | attributes = options.attributes ++ attrs }

        ColWidth width_ ->
            applyColWidth width_ options

        ColOffset offset_ ->
            applyColOffset offset_ options

        ColPull pull_ ->
            applyColPull pull_ options

        ColPush push_ ->
            applyColPush push_ options

        ColOrder order_ ->
            applyColOrder order_ options

        ColAlign align ->
            applyColAlign align options

        TextAlign align ->
            { options | textAlign = Just align }


applyColWidth : Width -> ColOptions msg -> ColOptions msg
applyColWidth width_ options =
    case width_.screenSize of
        XS ->
            { options | widthXs = Just width_ }

        SM ->
            { options | widthSm = Just width_ }

        MD ->
            { options | widthMd = Just width_ }

        LG ->
            { options | widthLg = Just width_ }

        XL ->
            { options | widthXl = Just width_ }


applyColOffset : Offset -> ColOptions msg -> ColOptions msg
applyColOffset offset_ options =
    case offset_.screenSize of
        XS ->
            { options | offsetXs = Just offset_ }

        SM ->
            { options | offsetSm = Just offset_ }

        MD ->
            { options | offsetMd = Just offset_ }

        LG ->
            { options | offsetLg = Just offset_ }

        XL ->
            { options | offsetXl = Just offset_ }


applyColPull : Pull -> ColOptions msg -> ColOptions msg
applyColPull pull_ options =
    case pull_.screenSize of
        XS ->
            { options | pullXs = Just pull_ }

        SM ->
            { options | pullSm = Just pull_ }

        MD ->
            { options | pullMd = Just pull_ }

        LG ->
            { options | pullLg = Just pull_ }

        XL ->
            { options | pullXl = Just pull_ }


applyColPush : Push -> ColOptions msg -> ColOptions msg
applyColPush push_ options =
    case push_.screenSize of
        XS ->
            { options | pushXs = Just push_ }

        SM ->
            { options | pushSm = Just push_ }

        MD ->
            { options | pushMd = Just push_ }

        LG ->
            { options | pushLg = Just push_ }

        XL ->
            { options | pushXl = Just push_ }


applyColOrder : Order -> ColOptions msg -> ColOptions msg
applyColOrder order_ options =
    case order_.screenSize of
        XS ->
            { options | orderXs = Just order_ }

        SM ->
            { options | orderSm = Just order_ }

        MD ->
            { options | orderMd = Just order_ }

        LG ->
            { options | orderLg = Just order_ }

        XL ->
            { options | orderXl = Just order_ }


applyColAlign : VAlign -> ColOptions msg -> ColOptions msg
applyColAlign align_ options =
    case align_.screenSize of
        XS ->
            { options | alignXs = Just align_ }

        SM ->
            { options | alignSm = Just align_ }

        MD ->
            { options | alignMd = Just align_ }

        LG ->
            { options | alignLg = Just align_ }

        XL ->
            { options | alignXl = Just align_ }


applyRowOption : RowOption msg -> RowOptions msg -> RowOptions msg
applyRowOption modifier options =
    case modifier of
        RowAttrs attrs ->
            { options | attributes = options.attributes ++ attrs }

        RowVAlign align ->
            applyRowVAlign align options

        RowHAlign align ->
            applyRowHAlign align options


applyRowVAlign : VAlign -> RowOptions msg -> RowOptions msg
applyRowVAlign align_ options =
    case align_.screenSize of
        XS ->
            { options | vAlignXs = Just align_ }

        SM ->
            { options | vAlignSm = Just align_ }

        MD ->
            { options | vAlignMd = Just align_ }

        LG ->
            { options | vAlignLg = Just align_ }

        XL ->
            { options | vAlignXl = Just align_ }


applyRowHAlign : HAlign -> RowOptions msg -> RowOptions msg
applyRowHAlign align options =
    case align.screenSize of
        XS ->
            { options | hAlignXs = Just align }

        SM ->
            { options | hAlignSm = Just align }

        MD ->
            { options | hAlignMd = Just align }

        LG ->
            { options | hAlignLg = Just align }

        XL ->
            { options | hAlignXl = Just align }


defaultColOptions : ColOptions msg
defaultColOptions =
    { attributes = []
    , textAlign = Nothing
    , widthXs = Nothing
    , widthSm = Nothing
    , widthMd = Nothing
    , widthLg = Nothing
    , widthXl = Nothing
    , offsetXs = Nothing
    , offsetSm = Nothing
    , offsetMd = Nothing
    , offsetLg = Nothing
    , offsetXl = Nothing
    , pullXs = Nothing
    , pullSm = Nothing
    , pullMd = Nothing
    , pullLg = Nothing
    , pullXl = Nothing
    , pushXs = Nothing
    , pushSm = Nothing
    , pushMd = Nothing
    , pushLg = Nothing
    , pushXl = Nothing
    , orderXs = Nothing
    , orderSm = Nothing
    , orderMd = Nothing
    , orderLg = Nothing
    , orderXl = Nothing
    , alignXs = Nothing
    , alignSm = Nothing
    , alignMd = Nothing
    , alignLg = Nothing
    , alignXl = Nothing
    }


defaultRowOptions : RowOptions msg
defaultRowOptions =
    { attributes = []
    , vAlignXs = Nothing
    , vAlignSm = Nothing
    , vAlignMd = Nothing
    , vAlignLg = Nothing
    , vAlignXl = Nothing
    , hAlignXs = Nothing
    , hAlignSm = Nothing
    , hAlignMd = Nothing
    , hAlignLg = Nothing
    , hAlignXl = Nothing
    }


colWidthsToAttributes : List (Maybe Width) -> List (Html.Attribute msg)
colWidthsToAttributes widths =
    let
        width_ w =
            Maybe.map colWidthClass w
    in
    List.map width_ widths
        |> List.filterMap identity


colWidthClass : Width -> Html.Attribute msg
colWidthClass { screenSize, columnCount } =
    "col"
        ++ (Maybe.map (\v -> "-" ++ v) (screenSizeOption screenSize)
                |> Maybe.withDefault ""
           )
        ++ (Maybe.map (\v -> "-" ++ v) (columnCountOption columnCount)
                |> Maybe.withDefault ""
           )
        |> class


offsetsToAttributes : List (Maybe Offset) -> List (Html.Attribute msg)
offsetsToAttributes offsets =
    let
        offset_ m =
            Maybe.map offsetClass m
    in
    List.map offset_ offsets
        |> List.filterMap identity


offsetClass : Offset -> Html.Attribute msg
offsetClass { screenSize, offsetCount } =
    class <| "offset" ++ screenSizeToPartialString screenSize ++ offsetCountOption offsetCount


pullsToAttributes : List (Maybe Pull) -> List (Html.Attribute msg)
pullsToAttributes pulls =
    let
        pull_ m =
            case m of
                Just { screenSize, moveCount } ->
                    Just <| class <| "pull" ++ screenSizeToPartialString screenSize ++ moveCountOption moveCount

                Nothing ->
                    Nothing
    in
    List.map pull_ pulls
        |> List.filterMap identity


pushesToAttributes : List (Maybe Pull) -> List (Html.Attribute msg)
pushesToAttributes pushes =
    let
        push_ m =
            case m of
                Just { screenSize, moveCount } ->
                    Just <| class <| "push" ++ screenSizeToPartialString screenSize ++ moveCountOption moveCount

                Nothing ->
                    Nothing
    in
    List.map push_ pushes
        |> List.filterMap identity


orderToAttributes : List (Maybe Order) -> List (Html.Attribute msg)
orderToAttributes orders =
    let
        order_ m =
            case m of
                Just { screenSize, moveCount } ->
                    Just <| class <| "order" ++ screenSizeToPartialString screenSize ++ orderColOption moveCount

                Nothing ->
                    Nothing
    in
    List.map order_ orders
        |> List.filterMap identity


vAlignsToAttributes : String -> List (Maybe VAlign) -> List (Html.Attribute msg)
vAlignsToAttributes prefix aligns =
    let
        align a =
            Maybe.map (vAlignClass prefix) a
    in
    List.map align aligns
        |> List.filterMap identity


vAlignClass : String -> VAlign -> Html.Attribute msg
vAlignClass prefix { align, screenSize } =
    class <|
        (prefix
            ++ (Maybe.map (\v -> v ++ "-") (screenSizeOption screenSize)
                    |> Maybe.withDefault ""
               )
            ++ verticalAlignOption align
        )


hAlignsToAttributes : List (Maybe HAlign) -> List (Html.Attribute msg)
hAlignsToAttributes aligns =
    let
        align a =
            Maybe.map hAlignClass a
    in
    List.map align aligns
        |> List.filterMap identity


screenSizeToPartialString : ScreenSize -> String
screenSizeToPartialString screenSize =
    case screenSizeOption screenSize of
        Just s ->
            "-" ++ s ++ "-"

        Nothing ->
            "-"


columnCountOption : ColumnCount -> Maybe String
columnCountOption size =
    case size of
        Col ->
            Nothing

        Col1 ->
            Just "1"

        Col2 ->
            Just "2"

        Col3 ->
            Just "3"

        Col4 ->
            Just "4"

        Col5 ->
            Just "5"

        Col6 ->
            Just "6"

        Col7 ->
            Just "7"

        Col8 ->
            Just "8"

        Col9 ->
            Just "9"

        Col10 ->
            Just "10"

        Col11 ->
            Just "11"

        Col12 ->
            Just "12"

        ColAuto ->
            Just "auto"


offsetCountOption : OffsetCount -> String
offsetCountOption size =
    case size of
        Offset0 ->
            "0"

        Offset1 ->
            "1"

        Offset2 ->
            "2"

        Offset3 ->
            "3"

        Offset4 ->
            "4"

        Offset5 ->
            "5"

        Offset6 ->
            "6"

        Offset7 ->
            "7"

        Offset8 ->
            "8"

        Offset9 ->
            "9"

        Offset10 ->
            "10"

        Offset11 ->
            "11"


moveCountOption : MoveCount -> String
moveCountOption size =
    case size of
        Move0 ->
            "0"

        Move1 ->
            "1"

        Move2 ->
            "2"

        Move3 ->
            "3"

        Move4 ->
            "4"

        Move5 ->
            "5"

        Move6 ->
            "6"

        Move7 ->
            "7"

        Move8 ->
            "8"

        Move9 ->
            "9"

        Move10 ->
            "10"

        Move11 ->
            "11"

        Move12 ->
            "12"


orderColOption : OrderCol -> String
orderColOption size =
    case size of
        OrderFirst ->
            "first"

        Order1 ->
            "1"

        Order2 ->
            "2"

        Order3 ->
            "3"

        Order4 ->
            "4"

        Order5 ->
            "5"

        Order6 ->
            "6"

        Order7 ->
            "7"

        Order8 ->
            "8"

        Order9 ->
            "9"

        Order10 ->
            "10"

        Order11 ->
            "11"

        Order12 ->
            "12"

        OrderLast ->
            "last"


verticalAlignOption : VerticalAlign -> String
verticalAlignOption align =
    case align of
        Top ->
            "start"

        Middle ->
            "center"

        Bottom ->
            "end"
