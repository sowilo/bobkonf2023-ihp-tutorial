module Web.Mail.Contacts.HappyBirthday where
import Web.View.Prelude
import IHP.MailPrelude

data HappyBirthdayMail = HappyBirthdayMail { contact :: Contact }

instance BuildMail HappyBirthdayMail where
    subject = "Happy Birthday!"
    to HappyBirthdayMail { .. } =
      Address { addressName = Just contact.name,
                addressEmail = contact.email }
    from = "hi@example.com"
    html HappyBirthdayMail { .. } = [hsx|
        Dear {contact.name}
        <br />
        <br />
        Wishing you a very happy birthday and a splendid year ahead.
        The day is all yours — have fun!
        <br />
        <br />
        Cheers
    |]
