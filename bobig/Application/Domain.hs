module Application.Domain where

import IHP.Prelude
import Generated.Types
import Data.Time.Calendar

thisYearsBirthday :: Day -> Contact -> Day
thisYearsBirthday today contact =
    let (year, _, _) = toGregorian today
     in thisYearsBirthday' year contact

thisYearsBirthday' :: Year -> Contact -> Day
thisYearsBirthday' year contact =
    let (_, m, d) = toGregorian contact.dateOfBirth
        (_, _, d') = toGregorian birthday
        birthday = fromGregorian year m d
     in if d == d' then birthday else addDays 1 birthday

upcomingBirthday :: Day -> Contact -> Day
upcomingBirthday today contact =
    let (year, _, _) = toGregorian today
        birthday = thisYearsBirthday' year contact
     in if today <= birthday
        then birthday
        else thisYearsBirthday' (year + 1) contact
