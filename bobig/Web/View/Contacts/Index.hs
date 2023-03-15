module Web.View.Contacts.Index where
import Web.View.Prelude

data IndexView = IndexView { contacts :: [Contact] , pagination :: Pagination }

instance View IndexView where
    html IndexView { .. } = [hsx|
        {breadcrumb}

        <h1>Index<a href={pathTo NewContactAction} class="btn btn-primary ms-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Contact</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach contacts renderContact}</tbody>
            </table>
            {renderPagination pagination}
        </div>
    |]
        where
            breadcrumb = renderBreadcrumb
                [ breadcrumbLink "Contacts" ContactsAction
                ]

renderContact :: Contact -> Html
renderContact contact = [hsx|
    <tr>
        <td>{contact}</td>
        <td><a href={ShowContactAction contact.id}>Show</a></td>
        <td><a href={EditContactAction contact.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteContactAction contact.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]