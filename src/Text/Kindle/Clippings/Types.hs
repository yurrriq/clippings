{-# LANGUAGE OverloadedStrings #-}

module Text.Kindle.Clippings.Types
  ( Clipping (..)
  , Document (..)
  , newDocument
  , Title    (..)
  , Author   (..)
  , Content  (..)
  , Range    (..)
  , Page     (..)
  , Location (..)
  , Position (..)
  ) where

import           Data.Text (Text)

data Clipping = Clipping
  { document :: Document
  , position :: Position
  -- , date     :: LocalTime
  , content  :: Content
  } deriving (Eq, Show)

data Document = Document
  { title  :: Title
  , author :: Maybe Author
  } deriving (Eq, Show)

newtype Title = Title Text
  deriving (Eq, Ord, Show)

newtype Author = Author Text
  deriving (Eq, Ord, Show)

newDocument :: Document
newDocument = Document
  { title  = Title "Untitled"
  , author = Nothing
  }

data Content = Bookmark
             | Highlight Text
             | Note Text
  deriving (Eq, Show)

data Range = Single Int | FromTo Int Int
  deriving (Eq, Ord, Show)

newtype Page = Page Range
  deriving (Eq, Ord, Show)

newtype Location = Location Range
  deriving (Eq, Ord, Show)

data Position = PP Page
              | PLoc Page Location
  deriving (Eq, Ord, Show)
