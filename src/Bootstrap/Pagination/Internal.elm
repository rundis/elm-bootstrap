module Bootstrap.Pagination.Internal exposing (Item(..), ItemConfig(..), Link, Status(..), itemAttributes, linkAttributes, viewItem)

import Html
import Html.Attributes exposing (class, href, tabindex)
import Html.Events exposing (custom)
import Json.Decode as Decode


type ItemConfig msg
    = ItemConfig
        { status : Status
        , attrs : List (Html.Attribute msg)
        }


type Item msg
    = Item
        { config : ItemConfig msg
        , link : Link msg
        }


type alias Link msg =
    { htmlFn : List (Html.Attribute msg) -> List (Html.Html msg) -> Html.Html msg
    , attrs : List (Html.Attribute msg)
    , children : List (Html.Html msg)
    }


type Status
    = Default
    | Active
    | Disabled


viewItem : Item msg -> Html.Html msg
viewItem (Item { config, link }) =
    Html.li
        (itemAttributes config)
        [ link.htmlFn
            (linkAttributes config link)
            link.children
        ]


itemAttributes : ItemConfig msg -> List (Html.Attribute msg)
itemAttributes (ItemConfig config) =
    [ class <|
        "page-item"
            ++ (case config.status of
                    Default ->
                        ""

                    Active ->
                        " active"

                    Disabled ->
                        " disabled"
               )
    ]


linkAttributes : ItemConfig msg -> Link msg -> List (Html.Attribute msg)
linkAttributes (ItemConfig itemConfig) { attrs } =
    [ class "page-link", class "disabled" ]
        ++ attrs
        ++ (if itemConfig.status == Disabled then
                [ tabindex -1

                {- TODO: How to handle this in 0.19 ??
                   , custom "click" <|
                       Decode.succeed
                           { message = never
                           , preventDefault = True
                           , stopPropagation = True
                           }
                -}
                ]

            else
                []
           )
