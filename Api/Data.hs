module Api.Data where

import           Yesod

-- Subsites have foundations just like master sites.
data ApiSub = ApiSub

-- We have a familiar analogue from mkYesod, with just one extra parameter.
-- We'll discuss that later.
mkYesodSubData "ApiSub" [parseRoutes|
/ ApiHomeR GET
|]
