module Web.View.Contacts.New where
import Web.View.Prelude

data NewView = NewView { contact :: Contact }

instance View NewView where
    html NewView { .. } = [hsx|
        {breadcrumb}
        <h1>New Contact</h1>
        {contactForm contact}
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Contacts" ContactsAction
                , breadcrumbText "New Contact"
                ]
