module Tests exposing (..)

import Bootstrap.AlertTest as AlertTest
import Bootstrap.BadgeTest as BadgeTest
import Bootstrap.ButtonTest as ButtonTest
import Bootstrap.ButtonGroupTest as ButtonGroupTest
import Bootstrap.CardTest as CardTest
import Bootstrap.DropdownTest as DropdownTest
import Bootstrap.ListGroupTest as ListGroupTest
import Bootstrap.TableTest as TableTest
import Bootstrap.ProgressTest as ProgressTest
import Test exposing (..)


{-| @ltignore
-}
all : Test
all =
    Test.concat
        [ AlertTest.all
        , BadgeTest.all
        , ButtonTest.all
        , ButtonGroupTest.all
        , CardTest.all
        , DropdownTest.all
        , ListGroupTest.all
        , TableTest.all
        , ProgressTest.all
        ]
