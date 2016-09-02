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

||| Parse a series of one or more non-whitespace characters,
||| packing them into a string.
word : Parser String
word = pack <$> some (satisfy (not . isSpace)) <* spaces

||| Parse a series of characters up to the end of a line.
line : Parser String
line = pack <$> manyTill anyChar endOfLine

||| Parse an parenthesized author name in reverse.
author' : Parser Author
author' = reverse <$> quoted' ')' '('

||| Parse a title, i.e. the rest of a line, in reverse.
title' : Parser Title
title' = reverse . unwords <$> many word

||| Parse a document, i.e. a title, followed by
||| a possibly absent parenthesized author, in reverse.
||| N.B. This will consider `"bar"` in `"Foo (bar)"` to be an author.
document' : Parser Document
document'= flip Doc <$> opt author' <*> title'

||| Parse a document, i.e. a title, followed by
||| a possibly absent parenthesized author.
||| N.B. This will consider `"bar"` in `"Foo (bar)"` to be an author.
document : Parser Document
document = do
  s <- reverse <$> line
  let Id r = execParserT document' s; case r of
    Success _ x => pure x
    Failure es  => fail $ formatError s es

||| Parse the beginning of the second line of a clipping for its content type.
contentType : Parser String
contentType = string "- " *> opt (string "Your ")
           *> word
           <* token "on" <|> token "at"

||| Parse a singleton interval, i.e. a single page or location number.
singletonInterval : Parser Interval
singletonInterval = Singleton <$> integer

-- TODO: enforce from =< to
||| Parse a proper interval, i.e. a range of pages or locations.
properInterval : Parser Interval
properInterval = Proper <$> integer <*> (char '-' *> integer)

||| Parse an proper or singleton interval.
interval : Parser Interval
interval = properInterval <|> singletonInterval

||| Parse a reference to a page number or range of pages.
page : Parser Page
page = oneOf "Pp" *> string "age " *> interval <* string " | "

||| Parse a reference to a location or range of locations.
location : Parser Location
location = token "Loc. " <|> token "Location" <|> token "location"
        *> interval
        <* some (oneOf " |")

||| Parse date of the form, `"%A, %B %d, %Y %T"`.
||| N.B. For now, this ignores the time.
date : Parser Date
date = do token "Added on"
          Just day    <- Days.fromString . pack <$> many letter
            | Nothing => fail "Bad day!"
          comma
          Just month  <- Months.fromString . pack <$> many letter
            | Nothing => fail "Bad month!"
          space
          -- Just date'  <- (\i => integerToFin i 32) <$> integer
          --   | Nothing => fail "Bad date!"
          date'       <- integer
          comma
          year        <- integer
          -- -- TODO: time
          manyTill anyToken endOfLine
          pure $ MkDate day month date' year

||| Parse the end of a clipping record, i.e. zero or more newlines,
||| followed by `"=========="`.
eor : Parser ()
eor = many endOfLine *> token "=========="

||| Parse some content, i.e. empty lines for a `Bookmark`, the `selection` of a
||| `Highlight` or the `body` of a `Note`.
content : Parser String
content = many endOfLine *> pack <$> manyTill anyToken (some endOfLine *> eor)

-- ------------------------------------------------------- [ A Clipping Parser ]

||| Parse an entire clipping.
clipping : Parser (Maybe Clipping)
clipping = do
  doc     <- document
  type    <- contentType
  pos     <- liftA2 mkPosition (opt page) (opt location)
  date    <- pure <$> date
  content <- (<*>) (mkContent type) . pure <$> content
  pure $ Clip doc <$> pos <*> date <*> content

-- ---------------------------------------------------------------- [ Examples ]

exampleDocument : String
exampleDocument = "Type-Driven Development With Idris (v8) (Edwin Brady)\n"

exampleTitle : String
exampleTitle = "This is the Title and There's No Author\n"

exampleDate : String
exampleDate = "Added on Wednesday, July 27, 2016 4:19:29 AM\n"

highlightExample : String
highlightExample = exampleDocument
           ++ "- Your Highlight on page 407 | Location 6236-6236 | "
           ++ exampleDate
           ++ "\n\nWhen there are multiple constraints, "
           ++ "they must be given in a parenthesised, "
           ++ "comma separated list.\n\n"
           ++ "==========\n\n"

noteExample : String
noteExample = "Building Web Applications with Erlang (Zachary Kessin)\n"
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

testExampleDocument : IO ()
testExampleDocument with (parse document exampleDocument)
  | Right (Doc "Type-Driven Development With Idris (v8)" (Just "Edwin Brady"))
      = putStrLn "Test Passed"
  | _ = putStrLn "Test Failed"

testExampleTitle : IO ()
testExampleTitle with (parse document exampleTitle)
  | Right (Doc "This is the Title and There's No Author" Nothing)
      = putStrLn "Test Passed"
  | _ = putStrLn "Test Failed"

testExampleDate : IO ()
testExampleDate with (parse date exampleDate)
  | Right (MkDate Wednesday July 27 2016)
      = putStrLn "Test Passed"
  | _ = putStrLn "Test Failed"

testExamples : IO ()
testExamples with (parse (some clipping) examples)
  | Right _ = putStrLn "Test Passed"
  | _       = putStrLn "Test Failed"

-- --------------------------------------------------------------------- [ EOF ]
