{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_GHC -fno-warn-orphans #-}

module Api
  ( module Api.Data
  , module Api
  ) where

import Api.Data
import Yesod
import Import.NoFoundation

instance (Yesod master
         ,YesodPersistBackend master ~ SqlBackend
         ,YesodPersist master
         ,YesodAuth master) =>
         YesodSubDispatch ApiSub (HandlerT master IO) where
  yesodSubDispatch = $(mkYesodSubDispatch resourcesApiSub)

getUserR :: ApiHandler RepJson
getUserR =  return $ repJson $ object ["name" .= name, "age" .= age]
  where
    name = "Sibi" :: Text
    age = 28 :: Int

postUserR :: ApiHandler RepJson
postUserR = do
  user <- (lift requireJsonBody)
  _ <- lift $ runDB $ insert (user :: User)
  return $ repJson $ object ["ident" .= userIdent user, "password" .= userPassword user]

patchUserPasswordR :: Text -> ApiHandler TypedContent
patchUserPasswordR ident = do
  user <-
    lift $
    runDB $
    do updateWhere [UserIdent ==. ident] [UserPassword =. Nothing]
       user <- selectFirst [UserIdent ==. ident] []
       return user
  let x = invalidArgs ["User id is invalid"]
  maybe x (return . toTypedContent . toJSON) user
