module Application.Helper.View where

import Generated.Types
import IHP.ViewPrelude

contactForm :: Contact -> Html
contactForm contact = formFor contact [hsx|
    {(textField #name)}
    {(emailField #email) {fieldLabel = "Email address"}}
    {(textField #phone) {fieldLabel = "Phone number"}}
    {(dateField #dateOfBirth) {fieldLabel = "Date of birth"}}
    {submitButton}

|]
