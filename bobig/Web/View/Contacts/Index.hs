module Web.View.Contacts.Index where

import Web.View.Prelude
import Application.Domain (upcomingBirthday, eqDate)
import Data.Time.Format
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
        <td style="text-align:right">{birthday}</td>
        <td>{customMsg <$> contact.mailContent}</td>
        <td style="padding-left:2em">{edit}{delete}{mail}{job}</td>
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

        job = postButton contact ScheduleJobAction jobIcon
        jobIcon = (icon Bootstrap "clock"){tooltip = "Schedule job"}

        birthday =
            let birthday = upcomingBirthday today contact
                color = if birthday `eqDate` today
                        then "color:black"
                        else "color:gray"
                cakeIcon = plainIcon (icon FontAwesome "cake-candles"){styles = [color]}
             in [hsx|{birthday}{cakeIcon}|]

        msgIcon = (icon Bootstrap "postcard-heart"){tooltip="Custom Mail"}
        customMsg _ =
            iconLink
                (PreviewMailAction contact.id)
                (icon Bootstrap "postcard-heart")
                    { tooltip = "Preview mail"
                    }

        plainIcon icon@(Icon{styles = other}) =
            icon{styles = "cursor:default" : other}
