module Web.View.Contacts.New where
import Web.View.Prelude

data NewView = NewView { contact :: Contact }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Contact</h1>
        {renderForm contact}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Contacts" ContactsAction
                , breadcrumbText "New Contact"
                ]

renderForm :: Contact -> Html
renderForm contact = formFor contact [hsx|
    {(textField #name)}
    {(emailField #email) {fieldLabel = "Email address"}}
    {(textField #phone) {fieldLabel = "Phone number"}}
    {(dateField #dateOfBirth) {fieldLabel = "Date of birth"}}
    {submitButton}

|]
