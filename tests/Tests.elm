module Tests exposing (..)

import Test exposing (..)
import Bootstrap.TagTest as TagTest
import Bootstrap.AlertTest as AlertTest
import Bootstrap.ButtonTest as ButtonTest
import Bootstrap.CardTest as CardTest

{-| @ltignore -}
all : Test
all =
    Test.concat
        [ TagTest.all
        , AlertTest.all
        , ButtonTest.all
        , CardTest.all
        ]
