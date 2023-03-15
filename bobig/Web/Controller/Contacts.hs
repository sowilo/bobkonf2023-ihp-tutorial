module Web.Controller.Contacts where

import Web.Controller.Prelude
import Web.View.Contacts.Index
import Web.View.Contacts.New
import Web.View.Contacts.Edit
import Web.View.Contacts.Show
import IHP.Pagination.Types
import Web.Mail.Contacts.HappyBirthday

instance Controller ContactsController where
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
        date <- today
        render IndexView { .. }

    action NewContactAction = do
        date <- today
        let contact = newRecord |> set #dateOfBirth date
        render NewView { .. }

    action ShowContactAction { contactId } = do
        contact <- fetch contactId
        render ShowView { .. }

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
    |> fill @["name", "email", "phone", "dateOfBirth"]
    |> validateField #name nonEmpty
    |> validateField #email nonEmpty
    |> emptyValueToNothing #phone
    |> validateField #phone isPhoneNumber'
    where
        isPhoneNumber' :: Validator (Maybe Text)
        isPhoneNumber' = \case
            Nothing -> Success
            Just value -> isPhoneNumber value
