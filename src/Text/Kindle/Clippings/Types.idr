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

Title : Type
Title = String

Author : Type
Author = String

record Document where
  constructor Doc
  title  : Title
  author : Maybe Author

data Interval = Singleton Integer
              | Proper Integer Integer

Page : Type
Page = Interval

Location : Type
Location = Interval

record Position where
  constructor Pos
  page     : Maybe Page
  location : Maybe Location

record Date where
  constructor MkDate
  DDay  : Day
  DMon  : String -- TODO: data Month where ...
  DDate : Integer -- Fin 32
  DYear : Integer
  -- TODO: data Time where ...

data Content : Type where
   Bookmark  : Content
   Highlight : (selection : String) -> Content
   Note      : (note : String) -> Content

||| A Kindle clipping.
record Clipping where
  constructor Clip
  document : Document
  position : Position
  date     : Date
  content  : Content

-- --------------------------------------------------------------------- [ EOF ]
