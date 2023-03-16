module Web.Job.SendMail where

import Web.Controller.Prelude
import Web.Mail.Contacts.HappyBirthday (HappyBirthdayMail (..))
import Application.Domain.Birthday (Birthday (..), nextYearsBirthday)
import Application.Domain.Mail
import Data.Time.LocalTime
import Control.Monad (void)

instance Job SendMailJob where
    perform SendMailJob { .. } = do
      contact <- fetch contactId
      sendMail HappyBirthdayMail { .. }
      today <- utctDay <$> getCurrentTime
      let (Birthday dayToSend) = nextYearsBirthday today contact
      void $ scheduleSendMailJob contactId dayToSend

    -- increase interval to poll the queue table from one minute (default) to one hour
    queuePollInterval = 3600 * 1000000
