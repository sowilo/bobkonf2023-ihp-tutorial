module Application.Helper.View(
  IconLibrary (..),
  Icon (..),
  IconLink,
  IconButton (..),
  icon,
  iconLink,
  iconLinkDelete,
  contactForm,
  renderBirthdayMail,
  postButton,
) where

import Data.Text (intercalate)
import Generated.Types
import IHP.HSX.ToHtml
import IHP.RouterSupport (HasPath)
import IHP.ViewPrelude
import Text.Blaze.Html5 ((!))
import qualified Text.Blaze as H
import qualified Text.Blaze.Html5 as H
import qualified Text.Blaze.Html5.Attributes as A
import Generated.Types
import qualified Text.MMark as MMark

contactForm :: Contact -> Html
contactForm contact = formFor contact [hsx|
    {(textField #name)}
    {(emailField #email) {fieldLabel = "Email address"}}
    {(textField #phone) {fieldLabel = "Phone number"}}
    {(dateField #dateOfBirth) {fieldLabel = "Date of birth"}}
    {(textareaField #mailContent)
        { helpText = "You can use Markdown here"
        , fieldLabel = "Happy Birthday Mail"
        , additionalAttributes = [("rows", "10")] }}
    {submitButton}
|]


renderBirthdayMail :: Contact -> H.Html
renderBirthdayMail contact =
  maybe defaultMail renderPrepared contact.mailContent
  where
    defaultMail = defaultBirthdayMail contact.name
    renderPrepared mailContent =
      either (const defaultMail) renderMarkdown (mailContent |> MMark.parse "")
    renderMarkdown markdown = MMark.render markdown |> tshow |> preEscapedToHtml

defaultBirthdayMail :: Text -> H.Html
defaultBirthdayMail name = [hsx|
    Dear {name}
    <br/>
    <br/>
    Wishing you a very happy birthday and a splendid year ahead.<br/>
    The day is all yours — have fun!
    <br/>
    <br/>
    Cheers
|]


postButton ::
  forall record controller.
  ( ?context :: ControllerContext
  , ModelFormAction record
  , HasField "meta" record MetaBag
  , HasPath controller
  , HasField "id" record (Id record)
  ) =>
  record ->
  (Id record -> controller) ->
  Icon ->
  Html
postButton record toController icon = formForWithOptions record
  (\formContext ->
     formContext
     |> set #formAction (pathTo . toController . (get #id) $ record)
     |> set #formClass "inline-form")
  [hsx|{IconButton icon}|]


data IconLibrary = FontAwesome | Bootstrap

data Icon = Icon
    { name       :: Text
    , lib        :: IconLibrary
    , tooltip    :: Maybe Text
    , classes    :: [Text]
    , styles     :: [Text]
    , attributes :: [H.Attribute]
    }

data IconLink a = IconLink a Icon Bool

newtype IconButton = IconButton Icon

icon :: IconLibrary -> Text -> Icon
icon library name =
    Icon { name = name
         , lib = library
         , tooltip = Nothing
         , classes = []
         , attributes = []
         , styles = []
         }

iconLink :: HasPath a => a -> Icon -> IconLink a
iconLink action icon = IconLink action icon False

iconLinkDelete :: HasPath a => a -> Icon -> IconLink a
iconLinkDelete action icon = IconLink action icon True

instance ToHtml Icon where
  toHtml icon@(Icon{tooltip=tooltip}) =
    [hsx|<i title={tooltip} />|] ! toAttribute icon

instance HasPath a => ToHtml (IconLink a) where
  toHtml (IconLink action icon delete) =
    let link = [hsx|<a href={action}>{icon}</a>|]
     in if delete then link ! A.class_ "js-delete" else link

instance ToHtml IconButton where
  toHtml (IconButton icon@(Icon{tooltip=tooltip})) =
    [hsx|<button title={tooltip} />|] ! toAttribute icon

toAttribute :: Icon -> H.Attribute
toAttribute Icon{..} =
  let libClasses = case lib of
        FontAwesome -> [ "fa", "fa-" <> name ]
        Bootstrap -> [ "bi", "bi-" <> name ]
      cls = H.textValue $ intercalate " " $ ["btn"] <> libClasses <> classes
      sts = if null styles
          then [] else [A.style $ H.textValue $ intercalate ";" $ styles]
      attrs = A.class_ cls : (sts <> attributes)
   in mconcat attrs
