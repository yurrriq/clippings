-- --------------------------------------------------------------- [ Types.idr ]
-- Module  : Text.Kindle.Clippings.Types
--
-- License : This code is distributed under the MIT license. See the
--           file LICENSE in the root directory for its full text.
-- --------------------------------------------------------------------- [ EOH ]
module Text.Kindle.Clippings.Types

import        Data.Vect
import public Data.Date

%access public export

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
  title  : Title
  ||| The possible missing author of the document.
  author : Maybe Author

data Interval = Singleton Integer
              | Proper Integer Integer

||| A page is an interval.
Page : Type
Page = Interval

||| A location is an interval.
Location : Type
Location = Interval

record Position where
  constructor Pos
  page     : Maybe Page
  location : Maybe Location

||| A date consists of a day, month, date and year.
record Date where
  ||| Make a date.
  constructor MkDate
  ||| A day.
  DDay  : Day
  ||| A month.
  DMon  : String -- TODO: data Month where ...
  ||| A date.
  DDate : Integer -- Fin 32
  ||| A year.
  DYear : Integer
  -- TODO: data Time where ...

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

-- --------------------------------------------------------------------- [ EOF ]
