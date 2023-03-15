module Web.View.Contacts.Index where
import Web.View.Prelude

data IndexView = IndexView { contacts :: [Contact] , pagination :: Pagination }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Contacts
          <a href={pathTo NewContactAction} class="btn btn-primary ms-4">+ New</a>
        </h1>
        <div class="table-responsive">
            <table class="table table-sm table-striped">
                <tbody>{forEach contacts renderContact}</tbody>
            </table>
            {renderPagination pagination}
        </div>
    |]

renderContact :: Contact -> Html
renderContact contact = [hsx|
    <tr>
        <td><a href={ShowContactAction contact.id}>{contact.name}</a></td>
        <td><a href={EditContactAction contact.id} class="text-muted">Edit</a></td>
        <td><a href={DeleteContactAction contact.id} class="js-delete text-muted">Delete</a></td>
    </tr>
|]