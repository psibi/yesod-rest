{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE QuasiQuotes           #-}
{-# LANGUAGE TemplateHaskell       #-}

module Api 
    ( module Api.Data
    , module Api) where

import           Api.Data
import           Yesod
import Import.NoFoundation


-- And we'll spell out the handler type signature.
getApiHomeR :: Yesod master => HandlerT ApiSub (HandlerT master IO) Html
getApiHomeR = lift $ defaultLayout [whamlet|Welcome to the subsite!|]

instance Yesod master => YesodSubDispatch ApiSub (HandlerT master IO) where
    yesodSubDispatch = $(mkYesodSubDispatch resourcesApiSub)
