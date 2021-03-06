{-# LANGUAGE CPP #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
-- | Lastfm authentication procedure helpers
--
-- Basically, lastfm provides 3 ways to authenticate user:
--
--  - web application - <http://www.last.fm/api/webauth>
--
--  - desktop application - <http://www.last.fm/api/desktopauth>
--
--  - modile application - <http://www.last.fm/api/mobileauth>
--
-- Note that you can use any of them in your
-- application despite their names
--
-- How to get session key for yourself for debug with GHCi:
--
-- >>> import Lastfm
-- >>> import Lastfm.Authentication
-- >>> :set -XOverloadedStrings
-- >>> con <- newConnection
-- >>> lastfm con $ getToken <*> apiKey "__API_KEY__" <* json
-- Right (Object (fromList [("token",String "__TOKEN__")]))
-- >>> putStrLn . link $ apiKey "__API_KEY__" <* token "__TOKEN__"
-- http://www.last.fm/api/auth/?api_key=__API_KEY__&token=__TOKEN__
-- >>> -- Click that link ^^^
-- >>> lastfm con $ sign "__SECRET__" $ getSession <*> token "__TOKEN__" <*> apiKey "__API_KEY__"  <* json
-- Right (Object (fromList [("session",Object (fromList [("subscriber",String "0"),("key",String "__SESSION_KEY__"),("name",String "__USER__")]))]))
module Lastfm.Authentication
  ( -- * Helpers
    getToken, getSession, getMobileSession
  , link
  ) where

#if __GLASGOW_HASKELL__ < 710
import Control.Applicative
import Data.Monoid
#endif

import Lastfm.Internal
import Lastfm.Request


-- | Get authorization token
getToken :: Request f (APIKey -> Ready)
getToken = api "auth.getToken"


-- | Get session key
getMobileSession :: Request f (Username -> Password -> APIKey -> Sign)
getMobileSession = api "auth.getMobileSession" <* post


-- | Get session key
getSession :: Request f (Token -> APIKey -> Sign)
getSession = api "auth.getSession"


-- | Construct link user should follow to approve application
link :: Request f a -> String
link q = render . unwrap q $ R
  { _host = "http://www.last.fm/api/auth/"
  , _method = mempty
  , _query = mempty
  }
