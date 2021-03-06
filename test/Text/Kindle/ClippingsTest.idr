-- ------------------------------------------------------- [ ClippingsTest.idr ]
-- Module  : Text.Kindle.ClippingsTest
--
-- License : This code is distributed under the MIT license. See the
--           file LICENSE in the root directory for its full text.
-- --------------------------------------------------------------------- [ EOH ]
module Text.Kindle.ClippingsTest

import Text.Kindle.Clippings

import Specdris.Spec


-- ---------------------------------------------------------------- [ Examples ]

exampleDocument : String
exampleDocument = "Type-Driven Development With Idris (v8) (Edwin Brady)\n"


exampleTitle : String
exampleTitle = "This is the Title and There's No Author\n"


exampleDate : String
exampleDate = "Added on Wednesday, July 27, 2016 4:19:29 AM\n"


bookmarkExample : String
bookmarkExample = "Erlang and OTP in Action "
               ++ "(Martin Logan, Eric Merritt, Richard Carlsson)\n"
               ++ "- Your Bookmark on Location 3839 | "
               ++ "Added on Wednesday, August 12, 2015 3:32:38 AM\n\n\n\n"
               ++ "==========\n\n"


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


-- ------------------------------------------------------------------- [ Tests ]

export specSuite : IO ()
specSuite = spec $ do
  describe "specdris ftw" $ do
    it "parses a document with an author" $ do
      parse document exampleDocument `shouldBe`
      Right (Doc "Type-Driven Development With Idris (v8)" (Just "Edwin Brady"))
    it "parses a document without an author" $ do
      parse document exampleTitle `shouldBe`
      Right (Doc "This is the Title and There's No Author" Nothing)
    it "parses a date" $ do
      parse date exampleDate `shouldBe`
      Right (MkDate Wednesday July 27 2016)
    it "parses a bookmark" $ do
      parse clipping bookmarkExample `shouldSatisfy` isRight
    it "parses a highlight" $ do
      parse clipping highlightExample `shouldSatisfy` isRight
    it "parses a note" $ do
      parse clipping noteExample `shouldSatisfy` isRight


-- --------------------------------------------------------------------- [ EOF ]
