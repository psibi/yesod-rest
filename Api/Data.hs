{-#LANGUAGE RankNTypes#-}

module Api.Data where

import           Yesod
import Yesod.Auth
import Database.Persist.Sql (SqlBackend)
import ClassyPrelude

-- Subsites have foundations just like master sites.
data ApiSub = ApiSub

type ApiHandler a = forall master. (Yesod master, YesodAuth master, YesodPersistBackend master ~ SqlBackend, YesodPersist master) => HandlerT ApiSub (HandlerT master IO) a

-- We have a familiar analogue from mkYesod, with just one extra parameter.
mkYesodSubData "ApiSub" $(parseRoutesFile "config/apiRoutes")
