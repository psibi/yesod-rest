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

instance YesodSubDispatch ApiSub App where
  yesodSubDispatch = $(mkYesodSubDispatch resourcesApiSub)

-- getUserR :: ApiHandler RepJson
getUserR :: SubHandlerFor ApiSub App RepJson
getUserR =  return $ repJson $ object ["name" .= name, "age" .= age]
  where
    name = "Sibi" :: Text
    age = 28 :: Int

-- postUserR :: ApiHandler RepJson
postUserR :: SubHandlerFor ApiSub App RepJson
postUserR = do
  user <- (requireJsonBody)
  _ <- liftHandler $ runDB $ insert (user :: User)
  return $ repJson $ object ["ident" .= userIdent user, "password" .= userPassword user]

type ApiHandle a = forall master. (master ~ App
                                   ,AuthId master ~ Key User
                                   ,YesodAuth master
                                   ,YesodPersistBackend master ~ SqlBackend
                                   ,YesodPersist master) =>
                                   HandlerFor ApiSub a

-- getSettingsR :: ApiHandle RepJson
-- getSettingsR :: SubHandlerFor ApiSub App RepJson
-- getSettingsR = do
--   app <- getYesod
--   let appSet = appSettings app
--   return $ repJson $ object ["port" .= (appPort appSet)]

-- patchUserPasswordR :: Text -> ApiHandler TypedContent


patchUserPasswordR :: Text -> SubHandlerFor ApiSub App TypedContent
patchUserPasswordR ident = do
  user <-
    liftHandler $
    runDB $
    do updateWhere [UserIdent ==. ident] [UserPassword =. Nothing]
       user <- selectFirst [UserIdent ==. ident] []
       return user
  let x = invalidArgs ["User id is invalid"]
  maybe x (return . toTypedContent . toJSON) user
