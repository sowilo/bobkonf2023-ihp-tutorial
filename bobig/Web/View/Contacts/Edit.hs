module Web.View.Contacts.Edit where
import Web.View.Prelude

data EditView = EditView { contact :: Contact }

instance View EditView where
    html EditView { .. } = [hsx|
        {breadcrumb}
        <h1>Edit Contact</h1>
        {renderForm contact}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Contacts" ContactsAction
                , breadcrumbText "Edit Contact"
                ]

renderForm :: Contact -> Html
renderForm contact = formFor contact [hsx|
    {(textField #name)}
    {(emailField #email) {fieldLabel = "Email address"}}
    {(textField #phone) {fieldLabel = "Phone number"}}
    {(dateField #dateOfBirth) {fieldLabel = "Date of birth"}}
    {submitButton}

|]
