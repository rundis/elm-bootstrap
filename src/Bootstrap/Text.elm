module Bootstrap.Text
    exposing
        ( alignXsLeft
        , alignXsCenter
        , alignXsRight
        , alignSmLeft
        , alignSmCenter
        , alignSmRight
        , alignMdLeft
        , alignMdCenter
        , alignMdRight
        , alignLgLeft
        , alignLgCenter
        , alignLgRight
        , HAlign
        )

import Bootstrap.Internal.Grid as GridInternal
import Bootstrap.Internal.Text as TextInternal exposing (TextAlignDir(..))


type alias HAlign =
    TextInternal.HAlign


alignXsLeft : HAlign
alignXsLeft =
    alignXs Left


alignXsCenter : HAlign
alignXsCenter =
    alignXs Center


alignXsRight : HAlign
alignXsRight =
    alignXs Right


alignXs : TextAlignDir -> HAlign
alignXs dir =
    { dir = dir
    , size = GridInternal.ExtraSmall
    }


alignSmLeft : HAlign
alignSmLeft =
    alignSm Left


alignSmCenter : HAlign
alignSmCenter =
    alignSm Center


alignSmRight : HAlign
alignSmRight =
    alignSm Right


alignSm : TextAlignDir -> HAlign
alignSm dir =
    { dir = dir
    , size = GridInternal.Small
    }


alignMdLeft : HAlign
alignMdLeft =
    alignMd Left


alignMdCenter : HAlign
alignMdCenter =
    alignMd Center


alignMdRight : HAlign
alignMdRight =
    alignMd Right


alignMd : TextAlignDir -> HAlign
alignMd dir =
    { dir = dir
    , size = GridInternal.Medium
    }


alignLgLeft : HAlign
alignLgLeft =
    alignLg Left


alignLgCenter : HAlign
alignLgCenter =
    alignLg Center


alignLgRight : HAlign
alignLgRight =
    alignLg Right


alignLg : TextAlignDir -> HAlign
alignLg dir =
    { dir = dir
    , size = GridInternal.Large
    }
