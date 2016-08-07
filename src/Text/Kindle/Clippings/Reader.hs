-- {-# LANGUAGE OverloadedStrings #-}

module Text.Kindle.Clippings.Reader where

import           Control.Applicative
import           Data.Text                   (pack)
import           Text.Parser.LookAhead
import           Text.Trifecta

import           Text.Kindle.Clippings.Types

crlf :: Parser String
crlf = string "\r\n"

eol :: Parser String
eol = (pure <$> newline) <|> crlf <?> "end of line"

readAuthor :: Parser Author
readAuthor = do
  theAuthor <- parens (some (notChar ')'))
  _       <- eol
  pure . Author . pack $ theAuthor

readTitle :: Parser Title
readTitle = Title . pack <$> manyTill anyChar (lookAhead (try readAuthor))

readDocument :: Parser Document
readDocument = do theTitle  <- readTitle
                  theAuthor <- optional readAuthor
                  -- eol
                  pure $ Document theTitle theAuthor
