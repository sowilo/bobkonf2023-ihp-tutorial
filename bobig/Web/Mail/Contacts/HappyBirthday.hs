module Web.Mail.Contacts.HappyBirthday where
import Web.View.Prelude
import IHP.MailPrelude

data HappyBirthdayMail = HappyBirthdayMail { contact :: Contact }

instance BuildMail HappyBirthdayMail where
    subject = happyBirthdaySubject
    to HappyBirthdayMail { .. } =
      Address { addressName = Just contact.name,
                addressEmail = contact.email }
    from = "hi@example.com"
    html HappyBirthdayMail { .. } = renderBirthdayMail contact

happyBirthdaySubject = "Happy Birthday!"
