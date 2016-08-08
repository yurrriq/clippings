-- ---------------------------------------------------------------- [ Date.idr ]
-- Module  : Data.Date
-- Description : Simple data types and helper functions to represent dates.
--
-- License : This code is distributed under the MIT license. See the
--           file LICENSE in the root directory for its full text.
-- --------------------------------------------------------------------- [ EOH ]
module Data.Date

%access public export

-- -------------------------------------------------------------- [ Data Types ]

||| A day of the week.
data Day = Monday
         | Tuesday
         | Wednesday
         | Thursday
         | Friday
         | Saturday
         | Sunday

%name Day day, day1, day2

||| A month of the year.
data Month = January
           | February
           | March
           | April
           | May
           | June
           | July
           | August
           | September
           | October
           | November
           | December

%name Month month, month1, month2

-- ------------------------------------------------------ [ Eq Implementations ]

Eq Day where
  Monday    == Monday    = True
  Tuesday   == Tuesday   = True
  Wednesday == Wednesday = True
  Thursday  == Thursday  = True
  Friday    == Friday    = True
  Saturday  == Saturday  = True
  Sunday    == Sunday    = True
  _         == _         = False

Eq Month where
  January   == January   = True
  February  == February  = True
  March     == March     = True
  April     == April     = True
  May       == May       = True
  June      == June      = True
  July      == July      = True
  August    == August    = True
  September == September = True
  October   == October   = True
  November  == November  = True
  December  == December  = True
  _         == _         = False

-- ------------------------------------------------------ [ Show Implementations ]

Show Day where
  show Monday    = "Monday"
  show Tuesday   = "Tuesday"
  show Wednesday = "Wednesday"
  show Thursday  = "Thursday"
  show Friday    = "Friday"
  show Saturday  = "Saturday"
  show Sunday    = "Sunday"

Show Month where
  show January   = "January"
  show February  = "February"
  show March     = "March"
  show April     = "April"
  show May       = "May"
  show June      = "June"
  show July      = "July"
  show August    = "August"
  show September = "September"
  show October   = "October"
  show November  = "November"
  show December  = "December"

-- -------------------------------------------------------- [ Helper Functions ]

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

namespace Months
  ||| Convert a string to a month, if possible, otherwise return `Nothing`.
  ||| @ str A string representing a month.
  fromString : (str : String) -> Maybe Month
  fromString "January"   = Just January
  fromString "February"  = Just February
  fromString "March"     = Just March
  fromString "April"     = Just April
  fromString "May"       = Just May
  fromString "June"      = Just June
  fromString "July"      = Just July
  fromString "August"    = Just August
  fromString "September" = Just September
  fromString "October"   = Just October
  fromString "November"  = Just November
  fromString "December"  = Just December
  fromString _           = Nothing

-- --------------------------------------------------------------------- [ EOF ]
