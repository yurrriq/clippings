module Data.Date

-- %include C "time.h"

%access public export

||| A day of the week.
data Day = Monday
         | Tuesday
         | Wednesday
         | Thursday
         | Friday
         | Saturday
         | Sunday

%name Day day, day1, day2

Eq Day where
  Monday    == Monday    = True
  Tuesday   == Tuesday   = True
  Wednesday == Wednesday = True
  Thursday  == Thursday  = True
  Friday    == Friday    = True
  Saturday  == Saturday  = True
  Sunday    == Sunday    = True
  _         == _         = False

Show Day where
  show Monday    = "Monday"
  show Tuesday   = "Tuesday"
  show Wednesday = "Wednesday"
  show Thursday  = "Thursday"
  show Friday    = "Friday"
  show Saturday  = "Saturday"
  show Sunday    = "Sunday"

namespace Days
  ||| Convert a string to a day, if possible, otherwise return `Nothing`.
  ||| @ str A string representing a day.
  fromString : (str : String) -> Maybe Day
  fromString "Monday"    = Just Monday
  fromString "Tuesday"   = Just Tuesday
  fromString "Wednesday" = Just Wednesday
  fromString "Thursday"  = Just Thursday
  fromString "Friday"    = Just Friday
  fromString "Saturday"  = Just Saturday
  fromString "Sunday"    = Just Sunday
  fromString _           = Nothing
