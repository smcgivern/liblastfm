-- | Track API module
{-# OPTIONS_HADDOCK prune #-}
module Network.Lastfm.API.Track
  ( addTags, ban, getBuyLinks, getCorrection, getFingerprintMetadata
  , getInfo, getShouts, getSimilar, getTags, getTopFans, getTopTags
  , love, removeTag, scrobble, search, share, unban, unlove, updateNowPlaying
  ) where

import Control.Arrow ((|||))
import Control.Monad (void)
import Control.Monad.Error (runErrorT, throwError)
import Network.Lastfm

-- | Tag a track using a list of user supplied tags.
--
-- More: <http://www.lastfm.ru/api/show/track.addTags>
addTags :: Artist -> Track -> [Tag] -> APIKey -> SessionKey -> Secret -> Lastfm ()
addTags artist track tags apiKey sessionKey secret = runErrorT go
  where go
          | null tags        = throwError $ WrapperCallError method "empty tag list."
          | length tags > 10 = throwError $ WrapperCallError method "tag list length has exceeded maximum."
          | otherwise        = void $ callAPIsigned secret
            [ "method" ?< method
            , "artist" ?< artist
            , "track" ?< track
            , "tags" ?< tags
            , "api_key" ?< apiKey
            , "sk" ?< sessionKey
            ]
            where method = "track.addTags"

-- | Ban a track for a given user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.ban>
ban :: Artist -> Track -> APIKey -> SessionKey -> Secret -> Lastfm ()
ban artist track apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ "method" ?< "track.ban"
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Get a list of Buy Links for a particular track.
--
-- More: <http://www.lastfm.ru/api/show/track.getBuylinks>
getBuyLinks :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Country -> APIKey -> Lastfm Response
getBuyLinks a autocorrect country apiKey = runErrorT . callAPI $
  target a ++
  [ "method" ?< "track.getBuyLinks"
  , "autocorrect" ?< autocorrect
  , "country" ?< country
  , "api_key" ?< apiKey
  ]

-- | Use the last.fm corrections data to check whether the supplied track has a correction to a canonical track.
--
-- More: <http://www.lastfm.ru/api/show/track.getCorrection>
getCorrection :: Artist -> Track -> APIKey -> Lastfm Response
getCorrection artist track apiKey = runErrorT . callAPI $
  [ "method" ?< "track.getCorrection"
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  ]

-- | Retrieve track metadata associated with a fingerprint id generated by the Last.fm Fingerprinter. Returns track elements, along with a 'rank' value between 0 and 1 reflecting the confidence for each match.
--
-- More: <http://www.lastfm.ru/api/show/track.getFingerprintMetadata>
getFingerprintMetadata :: Fingerprint -> APIKey -> Lastfm Response
getFingerprintMetadata fingerprint apiKey = runErrorT . callAPI $
  [ "method" ?< "track.getFingerprintMetadata"
  , "fingerprintid" ?< fingerprint
  , "api_key" ?< apiKey
  ]

-- | Get the metadata for a track on Last.fm.
--
-- More: <http://www.lastfm.ru/api/show/track.getInfo>
getInfo :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Maybe User -> APIKey -> Lastfm Response
getInfo a autocorrect username apiKey = runErrorT . callAPI $
  target a ++
  [ "method" ?< "track.getInfo"
  , "autocorrect" ?< autocorrect
  , "username" ?< username
  , "api_key" ?< apiKey
  ]

-- | Get shouts for this track. Also available as an rss feed.
--
-- More: <http://www.lastfm.ru/api/show/track.getShouts>
getShouts :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Maybe Page -> Maybe Limit -> APIKey -> Lastfm Response
getShouts a autocorrect page limit apiKey = runErrorT . callAPI $
  target a ++
  [ "method" ?< "track.getShouts"
  , "autocorrect" ?< autocorrect
  , "page" ?< page
  , "limit" ?< limit
  , "api_key" ?< apiKey
  ]

-- | Get the similar tracks for this track on Last.fm, based on listening data.
--
-- More: <http://www.lastfm.ru/api/show/track.getSimilar>
getSimilar :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Maybe Limit -> APIKey -> Lastfm Response
getSimilar a autocorrect limit apiKey = runErrorT . callAPI $
  target a ++
  [ "method" ?< "track.getSimilar"
  , "autocorrect" ?< autocorrect
  , "limit" ?< limit
  , "api_key" ?< apiKey
  ]

-- | Get the tags applied by an individual user to a track on Last.fm.
--
-- More: <http://www.lastfm.ru/api/show/track.getTags>
getTags :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> Either User (SessionKey, Secret) -> APIKey -> Lastfm Response
getTags a autocorrect b apiKey = runErrorT $ case b of
  Left user -> callAPI $ target a ++ ["user" ?< user] ++ args
  Right (sessionKey, secret) -> callAPIsigned secret $ target a ++ ["sk" ?< sessionKey] ++ args
  where args =
          [ "method" ?< "track.getTags"
          , "autocorrect" ?< autocorrect
          , "api_key" ?< apiKey
          ]

-- | Get the top fans for this track on Last.fm, based on listening data.
--
-- More: <http://www.lastfm.ru/api/show/track.getTopFans>
getTopFans :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> APIKey -> Lastfm Response
getTopFans a autocorrect apiKey = runErrorT . callAPI $
  target a ++
  [ "method" ?< "track.getTopFans"
  , "autocorrect" ?< autocorrect
  , "api_key" ?< apiKey
  ]

-- | Get the top tags for this track on Last.fm, ordered by tag count.
--
-- More: <http://www.lastfm.ru/api/show/track.getTopTags>
getTopTags :: Either (Artist, Track) Mbid -> Maybe Autocorrect -> APIKey -> Lastfm Response
getTopTags a autocorrect apiKey = runErrorT . callAPI $
  target a ++
  [ "method" ?< "track.getTopTags"
  , "autocorrect" ?< autocorrect
  , "api_key" ?< apiKey
  ]

-- | Love a track for a user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.love>
love :: Artist -> Track -> APIKey -> SessionKey -> Secret -> Lastfm ()
love artist track apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ "method" ?< "track.love"
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Remove a user's tag from a track.
--
-- More: <http://www.lastfm.ru/api/show/track.removeTag>
removeTag :: Artist -> Track -> Tag -> APIKey -> SessionKey -> Secret -> Lastfm ()
removeTag artist track tag apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ "method" ?< "track.removeTag"
  , "artist" ?< artist
  , "track" ?< track
  , "tag" ?< tag
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Used to add a track-play to a user's profile.
--
-- More; <http://www.lastfm.ru/api/show/track.scrobble>
scrobble :: ( Timestamp, Maybe Album, Artist, Track, Maybe AlbumArtist
           , Maybe Duration, Maybe StreamId, Maybe ChosenByUser
           , Maybe Context, Maybe TrackNumber, Maybe Mbid )
         -> APIKey
         -> SessionKey
         -> Secret
         -> Lastfm ()
scrobble (timestamp, album, artist, track, albumArtist, duration, streamId, chosenByUser, context, trackNumber, mbid) apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ "method" ?< "track.scrobble"
  , "timestamp" ?< timestamp
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  , "album" ?< album
  , "albumArtist" ?< albumArtist
  , "duration" ?< duration
  , "streamId" ?< streamId
  , "chosenByUser" ?< chosenByUser
  , "context" ?< context
  , "trackNumber" ?< trackNumber
  , "mbid" ?< mbid
  ]

-- | Search for a track by track name. Returns track matches sorted by relevance.
--
-- More: <http://www.lastfm.ru/api/show/track.search>
search :: Track -> Maybe Page -> Maybe Limit -> Maybe Artist -> APIKey -> Lastfm Response
search limit page track artist apiKey = runErrorT . callAPI $
  [ "method" ?< "track.search"
  , "track" ?< track
  , "page" ?< page
  , "limit" ?< limit
  , "artist" ?< artist
  , "api_key" ?< apiKey
  ]

-- | Share a track twith one or more Last.fm users or other friends.
--
-- More: <http://www.lastfm.ru/api/show/track.share>
share :: Artist -> Track -> [Recipient] -> Maybe Message -> Maybe Public -> APIKey -> SessionKey -> Secret -> Lastfm ()
share artist track recipients message public apiKey sessionKey secret = runErrorT go
  where go
          | null recipients        = throwError $ WrapperCallError method "empty recipient list."
          | length recipients > 10 = throwError $ WrapperCallError method "recipient list length has exceeded maximum."
          | otherwise              = void $ callAPIsigned secret
            [ "method" ?< method
            , "artist" ?< artist
            , "track" ?< track
            , "recipient" ?< recipients
            , "api_key" ?< apiKey
            , "sk" ?< sessionKey
            , "public" ?< public
            , "message" ?< message
            ]
            where method = "track.share"

-- | Unban a track for a user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.unban>
unban :: Artist -> Track -> APIKey -> SessionKey -> Secret -> Lastfm ()
unban artist track apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ "method" ?< "track.unban"
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]

-- | Unlove a track for a user profile.
--
-- More: <http://www.lastfm.ru/api/show/track.unlove>
unlove :: Artist -> Track -> APIKey -> SessionKey -> Secret -> Lastfm ()
unlove artist track apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ "method" ?< "track.unlove"
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  ]


-- | Used to notify Last.fm that a user has started listening to a track. Parameter names are case sensitive.
--
-- More: <http://www.lastfm.ru/api/show/track.updateNowPlaying>
updateNowPlaying :: Artist
                 -> Track
                 -> Maybe Album
                 -> Maybe AlbumArtist
                 -> Maybe Context
                 -> Maybe TrackNumber
                 -> Maybe Mbid
                 -> Maybe Duration
                 -> APIKey
                 -> SessionKey
                 -> Secret
                 -> Lastfm ()
updateNowPlaying artist track album albumArtist context trackNumber mbid duration apiKey sessionKey secret = runErrorT . void . callAPIsigned secret $
  [ "method" ?< "track.updateNowPlaying"
  , "artist" ?< artist
  , "track" ?< track
  , "api_key" ?< apiKey
  , "sk" ?< sessionKey
  , "album" ?< album
  , "albumArtist" ?< albumArtist
  , "context" ?< context
  , "trackNumber" ?< trackNumber
  , "mbid" ?< mbid
  , "duration" ?< duration
  ]

target :: Either (Artist, Track) Mbid -> [(String, String)]
target = (\(artist, track) -> ["artist" ?< artist, "track" ?< track]) ||| return . ("mbid" ?<)
