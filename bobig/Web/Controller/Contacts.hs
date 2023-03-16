module Web.Controller.Contacts where

import Web.Controller.Prelude
import Web.View.Contacts.Index
import Web.View.Contacts.New
import Web.View.Contacts.Edit
import Web.View.Contacts.Show
import IHP.Pagination.Types
import Web.Mail.Contacts.HappyBirthday
import Web.View.Contacts.PreviewMail
import Web.Job.SendMail
import Application.Domain.Birthday
import Application.Domain.Mail

instance Controller ContactsController where
    action ScheduleJobAction { contactId } = do
        date <- today
        contact <- fetch contactId
        scheduleSendMailJob contactId $ unBirthday $ upcomingBirthday date contact
        redirectTo ContactsAction

    action PreviewMailAction { contactId } = do
        contact <- fetch contactId
        setModal PreviewMailView { .. }
        jumpToAction ContactsAction

    action SendMailAction { contactId } = do
        contact <- fetch contactId
        sendMail HappyBirthdayMail { .. }
        redirectTo ContactsAction

    action ContactsAction = do
        (contactsQ, pagination) <- query @Contact
            |> orderBy #name
            |> paginateWithOptions
                 (defaultPaginationOptions |> set #maxItems 5)
        contacts <- contactsQ |> fetch
        let filterNotStarted = filterWhere (#status, JobStatusNotStarted)
        contacts <- contactsQ
          |> fetch
          >>= pure . map (modify #sendMailJobs filterNotStarted)
          >>= collectionFetchRelated #sendMailJobs
        date <- today
        render IndexView { .. }

    action NewContactAction = do
        date <- today
        let contact = newRecord |> set #dateOfBirth date
        render NewView { .. }

    action ShowContactAction { contactId } = do
        contact <- fetch contactId
        date <- today
        setModal ShowView { .. }
        jumpToAction ContactsAction

    action EditContactAction { contactId } = do
        contact <- fetch contactId
        render EditView { .. }

    action UpdateContactAction { contactId } = do
        contact <- fetch contactId
        contact
            |> buildContact
            |> ifValid \case
                Left contact -> render EditView { .. }
                Right contact -> do
                    contact <- contact |> updateRecord
                    setSuccessMessage "Contact updated"
                    redirectTo EditContactAction { .. }

    action CreateContactAction = do
        let contact = newRecord @Contact
        contact
            |> buildContact
            |> ifValid \case
                Left contact -> render NewView { .. } 
                Right contact -> do
                    contact <- contact |> createRecord
                    setSuccessMessage "Contact created"
                    redirectTo ContactsAction

    action DeleteContactAction { contactId } = do
        contact <- fetch contactId
        deleteRecord contact
        setSuccessMessage "Contact deleted"
        redirectTo ContactsAction

buildContact contact = contact
    |> fill @["name", "email", "phone", "dateOfBirth", "mailContent"]
    |> validateField #name nonEmpty
    |> validateField #email nonEmpty
    |> emptyValueToNothing #phone
    |> validateField #phone (maybeValidate isPhoneNumber)
    |> emptyValueToNothing #mailContent
    |> validateField #mailContent (maybeValidate validMarkdown)
