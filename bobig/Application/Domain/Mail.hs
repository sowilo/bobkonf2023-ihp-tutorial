module Application.Domain.Mail where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

scheduleSendMailJob ::
    (?modelContext::ModelContext) =>
    Id Contact -> Day -> IO SendMailJob
scheduleSendMailJob contactId date = do
    let timeToSend = TimeOfDay 8 0 0
        sendAt = localTimeToUTC utc $ LocalTime date timeToSend
    newRecord @SendMailJob
        |> set #contactId contactId
        |> set #runAt sendAt
        |> set #dateToSend date
        |> create

