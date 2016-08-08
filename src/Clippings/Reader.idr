module Clippings.Reader

import public Clippings.Types

import public Lightyear
import public Lightyear.Char
import public Lightyear.Strings

%access export

{-
notChar   : Char -> Parser Char
notChar c = satisfy (/= c) <?> "not " ++ show c
-}

{-
author : Parser Author
author = do
  s <- pack <$> (char '(' *> manyTill (noneOf "()") (char ')' *> endOfLine))
  pure $ MkAuthor s
-}

private
word : Parser String
word = pack <$> many (satisfy (not . isSpace))

private
line : Parser String
line = pack <$> manyTill anyChar endOfLine

-- input reversed
private
author': Parser Author
author' = MkAuthor . reverse <$> quoted' ')' '('

-- input reversed
private
title' : Parser Title
title' = MkTitle . reverse . unwords <$> manyTill (word <* spaces) eof

-- input reversed
private
titleAuthor' : Parser (Title, Maybe Author)
titleAuthor'= flip MkPair <$> opt author' <*> title'

titleAuthor : Parser (Title, Maybe Author)
titleAuthor = do
  s <- reverse <$> line
  let Id r = execParserT titleAuthor' s
  case r of
    Success _ x => pure x
    Failure es  => fail $ formatError s es

example : String
example = "Type-Driven Development With Idris (v8) (Edwin Brady)\n"
-- example = "This is the Title and There's No Author\n"


testExample : IO ()
testExample with (parse titleAuthor example)
  | Right (MkTitle "Type-Driven Development With Idris (v8)",
           Just (MkAuthor "Edwin Brady")) =
      putStrLn "Test Passed"
  | other = putStrLn $ "Test Failed: " ++ (show other)
