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
    {(textField #email)}
    {(textField #phone)}
    {(textField #dateOfBirth)}
    {submitButton}

|]