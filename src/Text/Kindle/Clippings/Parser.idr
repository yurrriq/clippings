-- -------------------------------------------------------------- [ Parser.idr ]
-- Module      : Text.Kindle.Clippings.Parser
-- Description : Parse Kinddle clippings.
--
-- License     : This code is distributed under the MIT license. See the
--               file LICENSE in the root directory for its full text.
-- --------------------------------------------------------------------- [ EOH ]
module Text.Kindle.Clippings.Parser

import public Text.Kindle.Clippings.Types

import TParsec
import TParsec.Running

-- FIXME: Handle this (better)
%access public export
%default total

-- ----------------------------------------------------------------- [ Parsers ]

||| Parse a series of one or more non-whitespace characters,
||| packing them into a string.
word : Parser String


||| Parse a series of characters up to the end of a line.
line : Parser String


||| Parse an parenthesized author name in reverse.
author' : Parser Author


||| Parse a title, i.e. the rest of a line, in reverse.
title' : Parser Title


||| Parse a document, i.e. a title, followed by
||| a possibly absent parenthesized author, in reverse.
||| N.B. This will consider `"bar"` in `"Foo (bar)"` to be an author.
document' : Parser Document


||| Parse a document, i.e. a title, followed by
||| a possibly absent parenthesized author.
||| N.B. This will consider `"bar"` in `"Foo (bar)"` to be an author.
document : Parser Document


||| Parse the beginning of the second line of a clipping for its content type.
contentType : Parser String


||| Parse a singleton interval, i.e. a single page or location number.
singletonInterval : Parser Interval


-- TODO: enforce from =< to
||| Parse a proper interval, i.e. a range of pages or locations.
properInterval : Parser Interval


||| Parse an proper or singleton interval.
interval : Parser Interval


||| Parse a reference to a page number or range of pages.
page : Parser Page


||| Parse a reference to a location or range of locations.
location : Parser Location


||| Parse date of the form, `"%A, %B %d, %Y %T"`.
||| N.B. For now, this ignores the time.
date : Parser Date

||| Parse the end of a clipping record, i.e. zero or more newlines,
||| followed by `"=========="`.
eor : Parser ()


||| Parse some content, i.e. empty lines for a `Bookmark`, the `selection` of a
||| `Highlight` or the `body` of a `Note`.
content : Parser String


||| Parse an entire clipping.
clipping : Parser (Maybe Clipping)


-- --------------------------------------------------------------------- [ EOF ]
