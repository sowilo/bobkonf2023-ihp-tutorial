module Web.View.Contacts.Index where

import Web.View.Prelude
import Application.Domain (upcomingBirthday)
import Data.Time.Format
import qualified Text.Blaze.Html5.Attributes as Blaze
import IHP.HSX.ToHtml

data IndexView = IndexView
    { contacts :: [Contact]
    , date :: Day
    , pagination :: Pagination
    }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <h1>Contacts
          <a href={pathTo NewContactAction} class="btn btn-primary ms-4">+ New</a>
        </h1>
        <div class="table-responsive">
            <table class="table table-sm table-striped">
                <tbody>{forEach contacts (renderContact date)}</tbody>
            </table>
            {renderPagination pagination}
        </div>
    |]

renderContact :: Day -> Contact -> Html
renderContact today contact = [hsx|
    <tr>
        <td>
            <a href={ShowContactAction contact.id} title="Show">
                {contact.name}
            </a>
        </td>
        <td style="text-align:right">
          {upcomingBirthday today contact}{cake}
        </td>
        <td style="padding-left:2em">{edit}{delete}{mail}</td>
    </tr>
|]
    where
        edit =
            iconLink
                (EditContactAction contact.id)
                (icon FontAwesome "pen")
                    { tooltip = "Edit"
                    }
        delete =
            iconLinkDelete
                (DeleteContactAction contact.id)
                (icon Bootstrap "trash3-fill")
                    { tooltip = "Delete"
                    }

        mail = postButton contact SendMailAction mailIcon
        mailIcon = (icon Bootstrap "envelope-heart"){tooltip = "Send mail"}

        cake = (icon FontAwesome "cake-candles")
                   { attributes = [Blaze.style "cursor:default; color:gray"] }

instance ToHtml Day where
  toHtml date = [hsx|{formatTime defaultTimeLocale "%d.%m.%Y" date}|]
