module Bootstrap.ProgressTest exposing (..)

import Bootstrap.Progress as Progress
import Html
import Html.Attributes as Attr
import Test exposing (Test, test, describe, fuzz)
import Fuzz
import Expect
import Test.Html.Query as Query
import Test.Html.Selector exposing (text, tag, class, classes, attribute)


{-| @ltignore
-}
all : Test
all =
    Test.concat
        [ vanillaProgress
        , progressMulti
        , options
        ]


vanillaProgress : Test
vanillaProgress =
    let
        html =
            Progress.progress [ Progress.value 30 ]
    in
        describe "Plain progress bar"
            [ test "expect div with progress class" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "div", class "progress" ]
            , test "expect div with progress-bar class and progressbar role" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has [ tag "div", class "progress-bar", attribute "role" "progressbar" ]
            , test "expect minimum = 0, maximum = 100" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.has
                            [ attribute "aria-valuemin" "0"
                            , attribute "aria-valuemax" "100"
                            ]
            , fuzz (Fuzz.intRange 0 100) "expect the progress value is present" <|
                \progressValue ->
                    Progress.progress [ Progress.value progressValue ]
                        |> Query.fromHtml
                        |> Query.find [ tag "div", class "progress-bar" ]
                        |> Query.has
                            [ attribute "aria-value-now" (toString progressValue)
                              {- doesn't work, see https://github.com/eeue56/elm-html-test/issues/3
                                 , attribute "style"
                                     ("width: "
                                         ++ toString progressValue
                                         ++ "%;"
                                     )
                              -}
                            ]
            ]


progressMulti =
    let
        html =
            Progress.progressMulti
                [ [ Progress.value 20, Progress.success, Progress.label "Success" ]
                , [ Progress.value 30, Progress.info, Progress.label "Info" ]
                , [ Progress.value 40, Progress.danger, Progress.label "Danger" ]
                ]
    in
        describe "Progress containing multiple progress bars"
            [ test "expect three progressbars" <|
                \() ->
                    html
                        |> Query.fromHtml
                        |> Query.findAll [ tag "div", class "progress-bar" ]
                        |> Query.count (Expect.equal 3)
            ]


options =
    describe "The option values for Progress"
        [ fuzz (Fuzz.intRange 0 100) "expect the progress value" <|
            \progressValue ->
                Progress.progress [ Progress.value progressValue ]
                    |> Query.fromHtml
                    |> Query.has [ attribute "aria-value-now" (toString progressValue) ]
          {- doesn't work because of a bug in elm-test-html
             , fuzz (Fuzz.intRange 0 1024) "expect the height value" <|
                 \height ->
                     Progress.progress [ Progress.height height ]
                         |> Query.fromHtml
                         |> Query.has [ attribute "height" (toString height) ]
          -}
        , fuzz Fuzz.string "expect a label" <|
            \label ->
                Progress.progress [ Progress.value 42, Progress.label label ]
                    |> Query.fromHtml
                    |> Query.has [ text label ]
        , fuzz Fuzz.string "expect no label when value is not set" <|
            \label ->
                Progress.progress [ Progress.label label ]
                    |> Query.fromHtml
                    |> Query.hasNot [ text (toString label) ]
          -- hack to say `Query.hasNot`, see https://github.com/eeue56/elm-html-test/issues/8
          -- |> Expect.getFailure
          -- |> Expect.notEqual Nothing
        , test "expect a custom label" <|
            \() ->
                Progress.progress [ Progress.customLabel [ Html.div [ Attr.class "custom-label" ] [] ] ]
                    |> Query.fromHtml
                    |> Query.hasNot [ tag "div", class "custom-label" ]
        , test "expect bg-success class" <|
            \() ->
                Progress.progress [ Progress.success ]
                    |> Query.fromHtml
                    |> Query.has [ tag "div", class "progress-bar", class "bg-success" ]
        , test "expect bg-info class" <|
            \() ->
                Progress.progress [ Progress.info ]
                    |> Query.fromHtml
                    |> Query.has [ tag "div", class "progress-bar", class "bg-info" ]
        , test "expect bg-warning class" <|
            \() ->
                Progress.progress [ Progress.warning ]
                    |> Query.fromHtml
                    |> Query.has [ tag "div", class "progress-bar", class "bg-warning" ]
        , test "expect bg-danger class" <|
            \() ->
                Progress.progress [ Progress.danger ]
                    |> Query.fromHtml
                    |> Query.has [ tag "div", class "progress-bar", class "bg-danger" ]
        , test "expect bg-animated and bg-striped class" <|
            \() ->
                Progress.progress [ Progress.animated ]
                    |> Query.fromHtml
                    |> Query.has [ tag "div", class "progress-bar", class "progress-bar-animated", class "progress-bar-striped" ]
        , test "expect bg-striped class" <|
            \() ->
                Progress.progress [ Progress.striped ]
                    |> Query.fromHtml
                    |> Query.has [ tag "div", class "progress-bar", class "progress-bar-striped" ]
        ]
