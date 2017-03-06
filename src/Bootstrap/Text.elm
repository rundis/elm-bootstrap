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
        , alignXlLeft
        , alignXlCenter
        , alignXlRight
        , HAlign
        )

{-| Utilities for text options. Currently only exposing helpers used by Bootstrap.Card for horizontal alignment


@docs alignXsLeft, alignXsCenter, alignXsRight, alignSmLeft, alignSmCenter, alignSmRight, alignMdLeft, alignMdCenter, alignMdRight, alignLgLeft, alignLgCenter, alignLgRight, alignXlLeft, alignXlCenter, alignXlRight, HAlign

-}

import Bootstrap.Grid.Internal as GridInternal
import Bootstrap.Internal.Text as TextInternal exposing (TextAlignDir(..))


{-| Opaque type representing a horizontal alignment option
-}
type alias HAlign =
    TextInternal.HAlign


{-| Align left at smallest responsive breakpoint
-}
alignXsLeft : HAlign
alignXsLeft =
    alignXs Left

{-| Align center at smallest responsive breakpoint
-}
alignXsCenter : HAlign
alignXsCenter =
    alignXs Center


{-| Align right at smallest responsive breakpoint
-}
alignXsRight : HAlign
alignXsRight =
    alignXs Right



alignXs : TextAlignDir -> HAlign
alignXs dir =
    { dir = dir
    , size = GridInternal.SM
    }


{-| Align left at small responsive breakpoint
-}
alignSmLeft : HAlign
alignSmLeft =
    alignSm Left


{-| Align center at small responsive breakpoint
-}
alignSmCenter : HAlign
alignSmCenter =
    alignSm Center

{-| Align right at small responsive breakpoint
-}
alignSmRight : HAlign
alignSmRight =
    alignSm Right


alignSm : TextAlignDir -> HAlign
alignSm dir =
    { dir = dir
    , size = GridInternal.SM
    }


{-| Align left at medium responsive breakpoint
-}
alignMdLeft : HAlign
alignMdLeft =
    alignMd Left

{-| Align center at medium responsive breakpoint
-}
alignMdCenter : HAlign
alignMdCenter =
    alignMd Center


{-| Align right at medium responsive breakpoint
-}
alignMdRight : HAlign
alignMdRight =
    alignMd Right


alignMd : TextAlignDir -> HAlign
alignMd dir =
    { dir = dir
    , size = GridInternal.MD
    }

{-| Align left at large responsive breakpoint
-}
alignLgLeft : HAlign
alignLgLeft =
    alignLg Left


{-| Align center at large responsive breakpoint
-}
alignLgCenter : HAlign
alignLgCenter =
    alignLg Center


{-| Align right at large responsive breakpoint
-}
alignLgRight : HAlign
alignLgRight =
    alignLg Right


alignLg : TextAlignDir -> HAlign
alignLg dir =
    { dir = dir
    , size = GridInternal.LG
    }


{-| Align left at extra large responsive breakpoint
-}
alignXlLeft : HAlign
alignXlLeft =
    alignXl Left


{-| Align center at extra large responsive breakpoint
-}
alignXlCenter : HAlign
alignXlCenter =
    alignXl Center


{-| Align right at extra large responsive breakpoint
-}
alignXlRight : HAlign
alignXlRight =
    alignXl Right


alignXl : TextAlignDir -> HAlign
alignXl dir =
    { dir = dir
    , size = GridInternal.XL
    }
