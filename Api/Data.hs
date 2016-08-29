module Api.Data where

import           Yesod

-- Subsites have foundations just like master sites.
data ApiSub = ApiSub

-- We have a familiar analogue from mkYesod, with just one extra parameter.
mkYesodSubData "ApiSub" $(parseRoutesFile "config/apiRoutes")
