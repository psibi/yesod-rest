-- @Api/Data.hs
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ViewPatterns          #-}
{-# LANGUAGE TypeFamilies          #-}


module Api.Data where

import           Yesod
import           Yesod.Auth
import           Database.Persist.Sql (SqlBackend)
import           Data.Text (Text)

-- Subsites have foundations just like master sites.
data ApiSub = ApiSub


type ApiHandler a = forall master. (Yesod master, 
                                    YesodAuth master, 
                                    YesodPersistBackend master ~ SqlBackend, 
                                    YesodPersist master) => 
                                        SubHandlerFor ApiSub master a



-- We have a familiar analogue from mkYesod, with just one extra parameter.
-- We'll discuss that later.
mkYesodSubData "ApiSub" $(parseRoutesFile "config/apiRoutes.yesodroutes")
