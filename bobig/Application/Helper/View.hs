module Application.Helper.View(
  IconLibrary (..),
  Icon (..),
  IconLink,
  IconButton (..),
  icon,
  iconLink,
  iconLinkDelete,
  contactForm,
  postButton,
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
    , attributes :: [Blaze.Attribute]
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
     in if delete then link ! Blaze.class_ "js-delete" else link

instance ToHtml IconButton where
  toHtml (IconButton icon@(Icon{tooltip=tooltip})) =
    [hsx|<button title={tooltip} />|] ! toAttribute icon

toAttribute :: Icon -> Blaze.Attribute
toAttribute Icon{..} =
  let libClasses = case lib of
        FontAwesome -> [ "fa", "fa-" <> name ]
        Bootstrap -> [ "bi", "bi-" <> name ]
      cls = Blaze.textValue $ intercalate " " $ ["btn"] <> libClasses <> classes
      attrs = Blaze.class_ cls : attributes
   in mconcat attrs
