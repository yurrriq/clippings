-- -------------------------------------------------------------- [ Reader.idr ]
-- Module      : Text.Kindle.Clippings.Reader
-- Description : Parse Kinddle clippings.
--
-- License     : This code is distributed under the MIT license. See the
--               file LICENSE in the root directory for its full text.
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
author' = Strings.reverse <$> quoted' ')' '('


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
  s <- Strings.reverse <$> line
  either fail pure (Strings.parse document' s)


||| Parse the beginning of the second line of a clipping for its content type.
contentType : Parser String
contentType = string "- " *> opt (string "Your ")
           *> word
           <* (token "on" <|> token "at")


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
location = (token "Loc. " <|> token "Location" <|> token "location")
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
content = many endOfLine *> pack <$> manyTill anyToken (many endOfLine *> eor)


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


-- --------------------------------------------------------------------- [ EOF ]
