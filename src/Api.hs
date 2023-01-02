-- @Api.hs
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE ViewPatterns          #-}
{-# LANGUAGE TypeFamilies          #-}

module Api
    ( module Api.Data
    , module Api
    ) where

import           Api.Data
import           Yesod    
import           Import.NoFoundation hiding ((.))
import           Resolve
import           Yesod.Core.Json


instance (Yesod master
         ,YesodPersistBackend master ~ SqlBackend
         ,YesodPersist master
         ,YesodAuth master) => YesodSubDispatch ApiSub master where
    yesodSubDispatch = $(mkYesodSubDispatch resourcesApiSub)




getUserR :: ApiHandler RepJson
getUserR = return $ repJson $ object ["name" .= name, "age" .= age]
  where
    name = "Sibi" :: Text
    age = 28 :: Int


postUserR :: ApiHandler RepJson
postUserR = do
    user <- requireCheckJsonBody :: SubHandlerFor ApiSub master User
    return $ repJson $ object ["ident" .= userIdent user, "password" .= userPassword user]


type ApiHandle a = forall master. (master ~ App
                                   ,AuthId master ~ Key User
                                   ,YesodAuth master
                                   ,YesodPersistBackend master ~ SqlBackend
                                   ,YesodPersist master) => SubHandlerFor ApiSub master a

getSettingsR :: ApiHandle RepJson
getSettingsR = do
  app <- getYesod
  let appSet = appSettings app
  return $ repJson $ object ["port" .= appPort appSet]


patchUserPasswordR :: Text -> ApiHandler TypedContent
patchUserPasswordR ident = do
    user <-
            liftHandler $ runDB $
                do 
                    updateWhere [UserIdent ==. ident] [UserPassword =. Nothing]
                    user <- selectFirst [UserIdent ==. ident] []
                    return user

    let x = invalidArgs ["User id is invalid"]
    maybe x (return . toTypedContent . toJSON) user


getSubHomeR :: ApiHandler Html
getSubHomeR = liftHandler $ defaultLayout $ do
        setTitle "Welcome To Yesod!"
        [whamlet|
            <h1.jumbotron>
                Welcome to Yesod Api!
        |]
