#!/usr/bin/env run-script
module Application.Script.SendMail where

import Application.Script.Prelude hiding (run)
import Web.Mail.Contacts.HappyBirthday (HappyBirthdayMail (..))
import Data.Time.Calendar

run :: Script
run = do
      today <- utctDay <$> getCurrentTime
      let (year, _, _) = toGregorian today
          withThisYearsBirthday c = (c, thisYearsBirthday year c)
      contacts <- query @Contact |> fetch
      let contacts' = filter ((today ==) . snd) $ withThisYearsBirthday <$> contacts
          mailsToSend = (HappyBirthdayMail . fst) <$> contacts'
      mapM_ sendMail mailsToSend

thisYearsBirthday :: Year -> Contact -> Day
thisYearsBirthday year contact =
    let (_, m, d) = toGregorian contact.dateOfBirth
        (_, _, d') = toGregorian birthday
        birthday = fromGregorian year m d
     in if d == d' then birthday else addDays 1 birthday
