module Tests exposing (..)

import Bootstrap.AlertTest as AlertTest
import Bootstrap.BadgeTest as BadgeTest
import Bootstrap.ButtonTest as ButtonTest
import Bootstrap.CardTest as CardTest
import Bootstrap.DropdownTest as DropdownTest
import Bootstrap.TableTest as TableTest
import Test exposing (..)

{-| @ltignore -}
all : Test
all =
    Test.concat
        [ AlertTest.all
        , BadgeTest.all
        , ButtonTest.all
        , CardTest.all
        , DropdownTest.all
        , TableTest.all
        ]
