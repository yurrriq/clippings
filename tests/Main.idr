module Main

import Text.Kindle.Clippings

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
