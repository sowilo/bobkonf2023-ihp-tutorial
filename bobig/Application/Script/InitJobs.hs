#!/usr/bin/env run-script
module Application.Script.InitJobs where

import Application.Script.Prelude hiding (run)
import Application.Domain.Birthday
import Web.Job.SendMail

run :: Script
run = do
    today <- utctDay <$> getCurrentTime
    let filterNotStarted = filterWhere (#status, JobStatusNotStarted)
        filterSucceeded = filterWhere (#status, JobStatusSucceeded)
        -- :: QueryBuilder "send_mail_jobs" -> QueryBuilder "send_mail_jobs"
        queryPending = queryOr filterNotStarted filterSucceeded

        birthday = upcomingBirthday today
        needsJob c =
            let pendingJobs = (get #dateToSend) <$> c.sendMailJobs
             in null (filter (eqDate (birthday c)) pendingJobs)

    contacts <- query @Contact
          |> fetch
          >>= pure . map (modify #sendMailJobs queryPending)
          >>= collectionFetchRelated #sendMailJobs

    let datesToSchedule =
            (\c -> (c.id, unBirthday $ birthday c)) <$>
                (filter needsJob contacts)

    mapM_ (uncurry scheduleSendMailJob) datesToSchedule
