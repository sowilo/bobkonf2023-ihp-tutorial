module Web.View.Contacts.PreviewMail where
import Web.View.Prelude
data PreviewMailView = PreviewMailView { contact :: Contact }

instance View PreviewMailView where
    html PreviewMailView { .. } = renderModal Modal
        { modalTitle = contact.name <> "'s Custom Message"
        , modalCloseUrl = pathTo ContactsAction
        , modalFooter = Nothing
        , modalContent = renderBirthdayMail contact
        }
