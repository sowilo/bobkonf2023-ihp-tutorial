module Application.Helper.Controller where

import IHP.ControllerPrelude

today :: IO Day
today = utctDay <$> getCurrentTime

maybeValidate :: Validator a -> Validator (Maybe a)
maybeValidate validator = \case
  Nothing -> Success
  Just value -> validator value
