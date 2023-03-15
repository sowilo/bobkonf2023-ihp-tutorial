module Web.Controller.Contacts where

import Web.Controller.Prelude
import Web.View.Contacts.Index
import Web.View.Contacts.New
import Web.View.Contacts.Edit
import Web.View.Contacts.Show

instance Controller ContactsController where
    action ContactsAction = do
        (contactsQ, pagination) <- query @Contact |> paginate
        contacts <- contactsQ |> fetch
        render IndexView { .. }

    action NewContactAction = do
        let contact = newRecord
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
