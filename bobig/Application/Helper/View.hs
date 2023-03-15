module Application.Helper.View(
  IconLibrary (..),
  Icon (..),
  IconLink,
  icon,
  iconLink,
  iconLinkDelete,
  renderContactForm,
) where

import Data.Text (intercalate)
import Generated.Types
import IHP.HSX.ToHtml
import IHP.RouterSupport (HasPath)
import IHP.ViewPrelude
import qualified Text.Blaze as Blaze
import Text.Blaze.Html5 ((!))
import qualified Text.Blaze.Html5.Attributes as Blaze

contactForm :: Contact -> Html
contactForm contact = formFor contact [hsx|
    {(textField #name)}
    {(emailField #email) {fieldLabel = "Email address"}}
    {(textField #phone) {fieldLabel = "Phone number"}}
    {(dateField #dateOfBirth) {fieldLabel = "Date of birth"}}
    {submitButton}

|]

data IconLibrary = FontAwesome | Bootstrap

data Icon = Icon
    { name       :: Text
    , lib        :: IconLibrary
    , tooltip    :: Maybe Text
    , classes    :: [Text]
    , attributes :: [Blaze.Attribute]
    }

data IconLink a = IconLink a Icon Bool

icon :: IconLibrary -> Text -> Icon
icon library name =
    Icon { name = name
         , lib = library
         , tooltip = Nothing
         , classes = []
         , attributes = []
         }

iconLink :: HasPath a => a -> Icon -> IconLink a
iconLink action icon = IconLink action icon False

iconLinkDelete :: HasPath a => a -> Icon -> IconLink a
iconLinkDelete action icon = IconLink action icon True

instance ToHtml Icon where
  toHtml Icon{..} =
    let libClasses =
            case lib of
                FontAwesome -> [ "fa", "fa-" <> name ]
                Bootstrap   -> [ "bi", "bi-" <> name ]
        cls = Blaze.textValue $ intercalate " " $ ["btn" ] <> libClasses <> classes
        attrs = Blaze.class_ cls : attributes
     in [hsx|<i title={tooltip} />|] ! mconcat attrs

instance HasPath a => ToHtml (IconLink a) where
  toHtml (IconLink action icon delete) =
    let link = [hsx|<a href={action}>{icon}</a>|]
     in if delete then link ! Blaze.class_ "js-delete" else link
