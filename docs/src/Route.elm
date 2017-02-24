module Route exposing (decode, Route(..))


import UrlParser exposing (Parser, parseHash, s, top, (</>))
import Navigation exposing (Location)


type Route
    = Home
    | Grid
    | Table
    | Progress
    | Alert
    | Badge
    | ListGroup
    | Tab
    | Card
    | Button
    | Dropdown
    | Accordion
    | Modal
    | Navbar
    | Form
    | NotFound


routeParser : Parser (Route -> a) a
routeParser =
    UrlParser.oneOf
        [ UrlParser.map Home top
        , UrlParser.map Grid (s "grid")
        , UrlParser.map Table (s "table")
        , UrlParser.map Progress (s "progress")
        , UrlParser.map Alert (s "alert")
        , UrlParser.map Badge (s "badge")
        , UrlParser.map ListGroup (s "listgroup")
        , UrlParser.map Tab (s "tab")
        , UrlParser.map Card (s "card")
        , UrlParser.map Button (s "button")
        , UrlParser.map Dropdown (s "dropdown")
        , UrlParser.map Accordion (s "accordion")
        , UrlParser.map Modal (s "modal")
        , UrlParser.map Navbar (s "navbar")
        , UrlParser.map Form (s "form")
        ]

decode : Location -> Maybe Route
decode location =
    UrlParser.parseHash routeParser location


