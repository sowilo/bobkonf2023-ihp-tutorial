module Application.Helper.Controller where

import IHP.ControllerPrelude

today :: IO Day
today = utctDay <$> getCurrentTime
