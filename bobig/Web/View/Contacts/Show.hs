module Web.View.Contacts.Show where
import Web.View.Prelude

data ShowView = ShowView { contact :: Contact }

instance View ShowView where
    html ShowView { .. } = [hsx|
        {breadcrumb}
        <h1>Show Contact</h1>
        <p>{contact}</p>

    |]
        where
            breadcrumb = renderBreadcrumb
                            [ breadcrumbLink "Contacts" ContactsAction
                            , breadcrumbText "Show Contact"
                            ]