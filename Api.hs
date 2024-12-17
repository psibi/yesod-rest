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
import Foundation ()

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
  user <- requireCheckJsonBody
  _ <- liftHandler $ runDB $ insert user
  return $ repJson $ object ["ident" .= userIdent user, "password" .= userPassword user]

patchUserPasswordR :: Text -> SubHandlerFor ApiSub App TypedContent
patchUserPasswordR ident = do
  user <-
    liftHandler $
     helperFunc ident
  let x = invalidArgs ["User id is invalid"]
  maybe x (return . toTypedContent . toJSON) user

helperFunc :: Text -> HandlerFor App (Maybe (Entity User))
helperFunc ident = runDB $ do
  updateWhere [UserIdent ==. ident] [UserPassword =. Nothing]
  user <- selectFirst [UserIdent ==. ident] []
  return user
