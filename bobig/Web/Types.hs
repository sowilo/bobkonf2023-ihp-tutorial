module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data ContactsController
    = ContactsAction
    | NewContactAction
    | ShowContactAction { contactId :: !(Id Contact) }
    | CreateContactAction
    | EditContactAction { contactId :: !(Id Contact) }
    | UpdateContactAction { contactId :: !(Id Contact) }
    | DeleteContactAction { contactId :: !(Id Contact) }
    | SendMailAction { contactId :: !(Id Contact) }
    | PreviewMailAction { contactId :: !(Id Contact) }
    deriving (Eq, Show, Data)
