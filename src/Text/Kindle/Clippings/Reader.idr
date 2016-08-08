-- -------------------------------------------------------------- [ Reader.idr ]
-- Module  : Text.Kindle.Clippings.Reader
-- Description : Parse Kinddle clippings.
--
-- License : This code is distributed under the MIT license. See the
--           file LICENSE in the root directory for its full text.
-- --------------------------------------------------------------------- [ EOH ]
module Text.Kindle.Clippings.Reader

import public Text.Kindle.Clippings.Types

import public Lightyear
import public Lightyear.Char
import public Lightyear.Strings

-- FIXME: Handle this (better)
%access public export

-- -------------------------------------------------------- [ Helper Functions ]

word : Parser String
word = pack <$> manyTill anyChar space

line : Parser String
line = pack <$> manyTill anyChar endOfLine

-- input reversed
author': Parser Author
author' = reverse <$> quoted' ')' '('

-- input reversed
title' : Parser Title
title' = reverse . unwords <$> manyTill (word <* spaces) eof

-- input reversed
document' : Parser Document
document'= flip Doc <$> opt author' <*> title'

document : Parser Document
document = do
  s <- reverse <$> line
  let Id r = execParserT document' s; case r of
    Success _ x => pure x
    Failure es  => fail $ formatError s es

contentType : Parser String
contentType = string "- " *> opt (string "Your ")
           *> word
           <* string " on " <|> string " at " <|> pack <$> some space

singletonInterval : Parser Interval
singletonInterval = Singleton <$> integer

-- TODO: enforce from =< to
properInterval : Parser Interval
properInterval = Proper <$> integer <*> (char '-' *> integer)

interval : Parser Interval
interval = properInterval <|> singletonInterval

page : Parser Page
page = oneOf "Pp" *> string "age " *> interval <* string " | "

location' : Parser String
location' = string "Loc. " <|> (oneOf "Ll" *> string "ocation ")

location : Parser Location
location = location' *> interval <* some (oneOf " |")

date : Parser Date
date = do token "Added on"
          Just day    <- fromString . pack <$> many letter
            | Nothing => fail "Bad day!"
          comma
          month       <- pack <$> many letter
          space
          -- Just date'  <- (\i => integerToFin i 32) <$> integer
          --   | Nothing => fail "Bad date!"
          date'       <- integer
          comma
          year        <- integer
          -- -- TODO: time
          manyTill anyToken endOfLine
          pure $ MkDate day month date' year

eor : Parser ()
eor = many endOfLine *> token "=========="

content : Parser String
content = many endOfLine *> pack <$> manyTill anyToken (some endOfLine *> eor)

-- ------------------------------------------------------- [ A Clipping Parser ]

clipping : Parser (Maybe Clipping)
clipping = go
       <$> document
       <*> contentType
       <*> liftA2 Pos (opt page) (opt location)
       <*> date
       <*> content
  where
    go : Document -> String -> Position -> Date -> String -> Maybe Clipping
    go d t p dd c = case t of
      "Bookmark"  => Just . Clip d p dd $ Bookmark
      "Highlight" => Just . Clip d p dd $ Highlight c
      "Note"      => Just . Clip d p dd $ Note c
      _           => Nothing

-- ---------------------------------------------------------------- [ Examples ]

example : String
example = "Type-Driven Development With Idris (v8) (Edwin Brady)\n"
-- example = "This is the Title and There's No Author\n"

exampleDate : String
exampleDate = "Added on Wednesday, July 27, 2016 4:19:29 AM\n"

highlightExample : String
highlightExample = example
           ++ "- Your Highlight on page 407 | Location 6236-6236 | "
           ++ exampleDate
           ++ "\n\nWhen there are multiple constraints, "
           ++ "they must be given in a parenthesised, "
           ++ "comma separated list.\n\n"
           ++ "==========\n\n"

noteExample : String
noteExample = "﻿Building Web Applications with Erlang (Zachary Kessin)\n"
           ++ "- Your Note on page 22 | Location 308 | "
           ++ "Added on Wednesday, August 13, 2014 12:35:21 AM\n\n\n"
           ++ "This is kind of like built-in mongroup.\n\n"
           ++ "==========\n\n"

bookmarkExample : String
bookmarkExample = "Erlang and OTP in Action "
               ++ "(Martin Logan, Eric Merritt, Richard Carlsson)\n"
               ++ "- Your Bookmark on Location 3839 | "
               ++ "Added on Wednesday, August 12, 2015 3:32:38 AM\n\n\n\n"
               ++ "==========\n\n"

examples : String
examples = bookmarkExample ++ highlightExample ++ noteExample

-- ------------------------------------------------------- [ Testing Functions ]

testExample : IO ()
testExample with (parse document example)
  | Right (Doc "Type-Driven Development With Idris (v8)" (Just "Edwin Brady")) =
    putStrLn "Test Passed"
  | other = putStrLn "Test Failed"

testExamples : IO ()
testExamples with (parse (some clipping) examples)
  | Right _ = putStrLn "Test Passed"
  | _       = putStrLn "Test Failed"

-- --------------------------------------------------------------------- [ EOF ]
