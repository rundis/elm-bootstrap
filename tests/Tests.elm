module Tests exposing (..)

import Test exposing (..)
import Bootstrap.AlertTest as AlertTest
import Bootstrap.ButtonTest as ButtonTest
import Bootstrap.CardTest as CardTest
import Bootstrap.TableTest as TableTest
import Bootstrap.TagTest as TagTest

{-| @ltignore -}
all : Test
all =
    Test.concat
        [ AlertTest.all
        , ButtonTest.all
        , CardTest.all
        , TagTest.all
        , TableTest.all
        ]
