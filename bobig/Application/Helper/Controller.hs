module Application.Helper.Controller where

import IHP.ControllerPrelude
import qualified Text.MMark as MMark
import Text.Megaparsec.Error (errorBundlePretty)
import Data.Text (pack)

today :: IO Day
today = utctDay <$> getCurrentTime

validMarkdown :: Validator Text
validMarkdown text = text |> MMark.parse "" |> \case
  Right _ -> Success
  Left err -> Failure . pack $ errorBundlePretty err

maybeValidate :: Validator a -> Validator (Maybe a)
maybeValidate validator = \case
  Nothing -> Success
  Just value -> validator value
