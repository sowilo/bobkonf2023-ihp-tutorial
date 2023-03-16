module Web.Routes where
import IHP.RouterPrelude
import Generated.Types
import Web.Types

-- Generator Marker
instance AutoRoute StaticController
instance AutoRoute ContactsController where
    allowedMethodsForAction "SendMailAction" = [ POST ]
    allowedMethodsForAction "ScheduleJobAction" = [ POST ]
    allowedMethodsForAction "CreateContactAction" = [ POST ]
    allowedMethodsForAction "UpdateContactAction" = [ POST, PATCH ]
    allowedMethodsForAction "DeleteContactAction" = [ DELETE ]
    allowedMethodsForAction _ = [ GET, HEAD ]
