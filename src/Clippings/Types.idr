module Clippings.Types

%access public export

data Title = MkTitle String

Show Title where
  show (MkTitle t) = show t

data Author = MkAuthor String

Show Author where
  show (MkAuthor a) = show a
