module Application.Domain.Birthday where

import IHP.Prelude
import Generated.Types
import Data.Time.Calendar
import IHP.HSX.QQ
import IHP.HSX.ToHtml

newtype Birthday = Birthday { unBirthday :: Day }

instance ToHtml Birthday where
  toHtml (Birthday date) =
      [hsx|{formatTime defaultTimeLocale "%d.%m.%Y" date}|]

thisYearsBirthday :: forall a. Day -> Contact' a -> Birthday
thisYearsBirthday today contact =
    let (year, _, _) = toGregorian today
     in thisYearsBirthday' year contact

thisYearsBirthday' :: forall a. Year -> Contact' a -> Birthday
thisYearsBirthday' year contact =
    let (_, m, d) = toGregorian contact.dateOfBirth
        (_, _, d') = toGregorian birthday
        birthday = fromGregorian year m d
     in Birthday $ if d == d' then birthday else addDays 1 birthday

upcomingBirthday :: forall a. Day -> Contact' a -> Birthday
upcomingBirthday today contact =
    let (year, _, _) = toGregorian today
        birthday@(Birthday date) = thisYearsBirthday' year contact
     in if today <= date
        then birthday
        else thisYearsBirthday' (year + 1) contact

eqDate :: Birthday -> Day -> Bool
eqDate (Birthday birthday) date = date == birthday

nextYearsBirthday :: forall a. Day -> Contact' a -> Birthday
nextYearsBirthday today contact =
    let (year, _, _) = toGregorian today
     in thisYearsBirthday' (year + 1) contact
