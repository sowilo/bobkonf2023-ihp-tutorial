module Web.View.Contacts.Show where
import Web.View.Prelude
import Web.Mail.Contacts.HappyBirthday
import Application.Domain.Birthday

data ShowView = ShowView { contact :: Contact, date :: Day }

instance View ShowView where
    html ShowView { .. } =  renderModal Modal
        { modalTitle = contact.name
        , modalCloseUrl = pathTo ContactsAction
        , modalFooter = Nothing
        , modalContent =
            let tableRow (l::Text) v =
                    [hsx|<tr><td>{l}</td><td>{v}</td></tr>|]
             in [hsx|
                    <table class="table align-middle" style="margin-bottom:2.5em">
                        {tableRow "Email address" contact.email}
                        {tableRow "Born" (Birthday contact.dateOfBirth)}
                        {tableRow "Next birthday" (upcomingBirthday date contact)}
                    </table>
                    <p><b>{happyBirthdaySubject}</b></p>
                    <p>{renderBirthdayMail contact}</p>
                |]
        }
