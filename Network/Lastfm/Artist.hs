{-# LANGUAGE GeneralizedNewtypeDeriving #-}
module Network.Lastfm.Artist
  ( Artist(..)
  , getCorrection
  , search, share, shout
  , addTags, removeTag
  )where

import Network.Lastfm.Auth (APIKey, SessionKey)
import Network.Lastfm.Core

newtype Artist = Artist String deriving (Show, LastfmValue)
newtype Limit = Limit Int deriving (Show, LastfmValue)
newtype Message = Message String deriving (Show, LastfmValue)
newtype Page = Page String deriving (Show, LastfmValue)
newtype Public = Public Bool deriving (Show, LastfmValue)
newtype Recipient = Recipient String deriving (Show, LastfmValue)
newtype Tag = Tag String deriving (Show, LastfmValue)

getCorrection :: Artist -> APIKey -> IO Response
getCorrection artist apiKey = callAPI "artist.getCorrection" $
  [ "artist" ?< artist
  , "api_key" ?< apiKey
  ]

shout :: Artist -> Message -> APIKey -> SessionKey -> IO ()
shout artist message apiKey sessionKey = callAPI_ "artist.shout" $
  [ "artist" ?< artist
  , "message" ?< message
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

search :: Maybe Limit -> Maybe Page -> Artist -> APIKey -> IO Response
search limit page artist apiKey = callAPI "artist.search" $
  [ "artist" ?< artist
  , "api_key" ?< apiKey
  ] ++ optional
    [ "limit" ?<< limit
    , "page" ?<< page
    ]

share :: Artist -> [Recipient] -> Maybe Message -> Maybe Public -> APIKey -> SessionKey -> IO ()
share artist recipients message public apiKey sessionKey = callAPI_ "artist.share" $
  [ "artist" ?< artist
  , "recipient" ?< recipients
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ] ++ optional
    [ "public" ?<< public
    , "message" ?<< message
    ]

addTags :: Artist -> [Tag] -> APIKey -> SessionKey -> IO ()
addTags artist tags apiKey sessionKey
  | null tags        = error "Artist.addTags: empty tag list."
  | length tags > 10 = error "Artist.addTags: tag list length has exceeded maximum."
  | otherwise        = callAPI_ "arist.addTags"
    [ "artist" ?< artist
    , "tags" ?< tags
    , "api_key" ?< apiKey
    , "sk" ?< sessionKey
    ]

removeTag :: Artist -> Tag -> APIKey -> SessionKey -> IO ()
removeTag artist tag apiKey sessionKey = callAPI_ "artist.removeTag"
  [ "artist" ?< artist
  , "tag" ?< tag
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]
