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
import Resolve

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

type ApiHandle a = forall master. (master ~ App
                                   ,AuthId master ~ Key User
                                   ,YesodAuth master
                                   ,YesodPersistBackend master ~ SqlBackend
                                   ,YesodPersist master) =>
                                   HandlerT ApiSub (HandlerT master IO) a

getSettingsR :: ApiHandle RepJson
getSettingsR = do
  app <- lift getYesod
  let appSet = appSettings app
  return $ repJson $ object ["port" .= (appPort appSet)] 

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
