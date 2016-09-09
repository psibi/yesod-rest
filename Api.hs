{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Api 
    ( module Api.Data
    , module Api) where

import           Api.Data
import           Yesod
import Import.NoFoundation


-- And we'll spell out the handler type signature.
getApiHomeR :: ApiHandler TypedContent
getApiHomeR = selectRep $ do
                provideRep $ return $ object
                          [ "name" .= name
                          , "age" .= age]
    where
      name = "Sibi" :: Text
      age = 28 :: Int

instance (Yesod master, YesodPersistBackend master ~ SqlBackend, YesodPersist master) => YesodSubDispatch ApiSub (HandlerT master IO) where
    yesodSubDispatch = $(mkYesodSubDispatch resourcesApiSub)
