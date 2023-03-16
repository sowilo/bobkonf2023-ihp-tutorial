module Web.Job.SendMail where
import Web.Controller.Prelude

instance Job SendMailJob where
    perform SendMailJob { .. } = do
        putStrLn "Hello World!"
