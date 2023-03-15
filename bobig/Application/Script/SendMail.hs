#!/usr/bin/env run-script
module Application.Script.SendMail where

import Application.Script.Prelude hiding (run)
import Web.Mail.Contacts.HappyBirthday (HappyBirthdayMail (..))
import Application.Domain (thisYearsBirthday)

run :: Script
run = do
    today <- utctDay <$> getCurrentTime
    contacts <- query @Contact |> fetch
    let withThisYearsBirthday c = (c, thisYearsBirthday today c)
        contacts' =
            filter ((today ==) . snd) $ withThisYearsBirthday <$> contacts
        mailsToSend = (HappyBirthdayMail . fst) <$> contacts'
    mapM_ sendMail mailsToSend
