-- --------------------------------------------------------------- [ Types.idr ]
-- Module  : Text.Kindle.Clippings.Types
--
-- License : This code is distributed under the MIT license. See the
--           file LICENSE in the root directory for its full text.
-- --------------------------------------------------------------------- [ EOH ]
module Text.Kindle.Clippings.Types

import        Data.Vect
import public Data.Date

%access  public export
%default total


-- ---------------------------------------------------------------- [ Document ]

||| A title is a string.
Title : Type
Title = String


||| An author is a string.
Author : Type
Author = String


||| A document consists of a title and and maybe an author.
record Document where
    ||| Make a document.
    constructor Doc
    ||| The title of the document.
    title : Title
    ||| The possible missing author of the document.
    author : Maybe Author


implementation Show Document where
    show (Doc title Nothing)       = title
    show (Doc title (Just author)) = title ++ " (" ++ author ++ ")"

implementation Eq Document where
    (Doc titleA authorA) == (Doc titleB authorB) =
        titleA == titleB &&
        authorA == authorB


-- ---------------------------------------------------------------- [ Interval ]

||| An interval is either a single integer or a range of integers.
data Interval : Type where
    ||| A single place, i.e. `Page' or `Location'.
    Singleton : Integer -> Interval
    ||| A range.
    ||| @ from The start of the range.
    ||| @ to   The end of the range.
    Proper : (from, to : Integer) -> Interval


||| A page is an interval.
Page : Type
Page = Interval


||| A location is an interval.
Location : Type
Location = Interval


implementation Show Interval where
    show (Singleton x)    = show x
    show (Proper from to) = show from ++ "-" ++ show to


-- ---------------------------------------------------------------- [ Position ]

||| A position consists of a page, location or both.
data Position : Type where
     ||| A page with no location.
     ||| @ page A page.
     PP : (page : Page) -> Position
     ||| A location with no page.
     ||| @ loc A location.
     Loc : (loc  : Location) -> Position
     ||| A page and location
     ||| @ page A page.
     ||| @ loc  A location.
     PPLoc : (page : Page)     -> (loc : Location) -> Position


||| Given a page, location or both, return a position. If both inputs are
||| `Nothing`, return `Nothing`.
||| @ page Maybe a page.
||| @ loc  Maybe a location.
mkPosition : (page : Maybe Page) -> (loc : Maybe Location) -> Maybe Position
mkPosition  Nothing     Nothing   = Nothing
mkPosition  Nothing    (Just loc) = Just $ Loc loc
mkPosition (Just page)  Nothing   = Just $ PP page
mkPosition (Just page) (Just loc) = Just $ PPLoc page loc


implementation Show Position where
    show (PP page)        = "page " ++ show page
    show (Loc loc)        = "Location " ++ show loc
    show (PPLoc page loc) = unwords [ show page, "|", show loc ]


-- -------------------------------------------------------------------- [ Date ]

||| A date consists of a day, month, date and year.
record Date where
    ||| Make a date.
    constructor MkDate
    ||| A day.
    DDay  : Day
    ||| A month.
    DMon  : Month
    ||| A date.
    DDate : Integer -- Fin 32
    ||| A year.
    DYear : Integer
    -- TODO: data Time where ...


implementation Show Date where
    show (MkDate day month date year) =
        concat $ List.intersperse ", " [ show day
                                       , show month ++ " " ++ show date
                                       , show year ]

implementation Eq Date where
    (MkDate dayA monthA dateA yearA) == (MkDate dayB monthB dateB yearB) =
        dayA   == dayB   &&
        monthA == monthB &&
        dateA  == dateB  &&
        yearA  == yearB


-- ----------------------------------------------------------------- [ Content ]

||| Content is either a bookmark, some highlight text, or a note.
data Content : Type where
   ||| A bookmark.
   Bookmark  : Content
   ||| Some highlighted text.
   ||| @ selection The highlight text.
   Highlight : (selection : String) -> Content
   ||| A note.
   ||| @ body The body of a note.
   Note : (body : String) -> Content


||| If a given string can be parsed as a `Content` data constructor, return just
||| a function that takes a string and returns the appropriate `Content`. If the
||| string can't be parsed, return `Nothing`. N.B. The resulting `Bookmark`
||| function ignores it's input. This makes it easier to use when parsing
||| clippings.
||| @ type A string representing a `Content` data constructor.
mkContent : (type : String) -> Maybe (String -> Content)
mkContent "Bookmark"  = Just (const Bookmark)
mkContent "Highlight" = Just Highlight
mkContent "Note"      = Just Note
mkContent _           = Nothing


contentType : Content -> String
contentType Bookmark      = "Bookmark"
contentType (Highlight _) = "Highlight"
contentType (Note _)      = "Note"


implementation Show Content where
  show Bookmark              = "Bookmark"
  show (Highlight selection) = selection
  show (Note body)           = body



-- ---------------------------------------------------------------- [ Clipping ]

||| A Kindle clipping consists of a document, position, date and content.
record Clipping where
    ||| Make a clipping.
    constructor Clip
    ||| A document.
    document : Document
    ||| A position.
    position : Position
    ||| A date.
    date     : Date
    ||| Some content.
    content  : Content


implementation Show Clipping where
    show (Clip document position date content) =
        unlines [ show document
                , unwords [ "Your", contentType content, "on", show position
                          , "| Added on", show date ]
                , ""
                , show content
                , "==========" ]


-- --------------------------------------------------------------------- [ EOF ]
