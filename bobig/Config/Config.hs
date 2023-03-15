module Config where

import IHP.Prelude
import IHP.Environment
import IHP.FrameworkConfig
import Web.View.CustomCSSFramework
import IHP.Mail

config :: ConfigBuilder
config = do
    -- See https://ihp.digitallyinduced.com/Guide/config.html
    -- for what you can do here
    option customBootstrap
    option $
        SMTP { host = "127.0.1.1"
             , port = 1025
             , credentials = Nothing
             , encryption = Unencrypted
             }
