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
    {(textField #email)}
    {(textField #phone)}
    {(textField #dateOfBirth)}
    {submitButton}

|]