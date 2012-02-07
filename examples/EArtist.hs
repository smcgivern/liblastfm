module EArtist (start) where

import Control.Monad ((<=<))

import Network.Lastfm.Response
import Network.Lastfm.Types
import qualified Network.Lastfm.API.Artist as Artist

import Kludges

apiKey = APIKey "b25b959554ed76058ac220b7b2e0a026"

getCorrection :: IO ()
getCorrection = do response <- Artist.getCorrection (Artist "Meshugah") apiKey
                   putStr "Correction: "
                   case response of
                     Left e  -> print e
                     Right r -> print (correction r)
  where correction = getContent <=< lookupChild "name" <=< lookupChild "artist" <=< lookupChild "correction" <=< lookupChild "corrections" <=< wrap

getEvents :: IO ()
getEvents = do response <- Artist.getEvents (Just (Artist "Meshuggah")) Nothing Nothing Nothing (Just (Limit 3)) Nothing apiKey
               putStr "First event place: "
               case response of
                 Left e  -> print e
                 Right r -> print (place r)
  where place = getContent <=< lookupChild "name" <=< lookupChild "venue" <=< lookupChild "event" <=< lookupChild "events" <=< wrap

getImages :: IO ()
getImages = do response <- Artist.getImages (Just (Artist "Meshuggah")) Nothing Nothing Nothing (Just (Limit 3)) Nothing apiKey
               putStr "First three images links: "
               case response of
                 Left e  -> print e
                 Right r -> print (links r)
  where links = mapM (getContent <=< lookupChild "url") <=< lookupChildren "image" <=< lookupChild "images" <=< wrap

getInfo :: IO ()
getInfo = do response <- Artist.getInfo (Just (Artist "Meshuggah")) Nothing Nothing Nothing Nothing apiKey
             putStr "Listeners count: "
             case response of
               Left e  -> print e
               Right r -> print (listeners r)
  where listeners = getContent <=< lookupChild "listeners" <=< lookupChild "stats" <=< lookupChild "artist" <=< wrap

getPastEvents :: IO ()
getPastEvents = do response <- Artist.getPastEvents (Just (Artist "Meshugah")) Nothing (Just (Autocorrect True)) Nothing Nothing apiKey
                   putStr "All event artists: "
                   case response of
                     Left e  -> print e
                     Right r -> print (artists r)
  where artists = mapM getContent <=< lookupChildren "artist" <=< lookupChild "artists" <=< lookupChild "event" <=< lookupChild "events" <=< wrap

getPodcast :: IO ()
getPodcast = do response <- Artist.getPodcast (Just (Artist "Meshuggah")) Nothing Nothing apiKey
                putStr "First channel description: "
                case response of
                  Left e  -> print e
                  Right r -> print (description r)
  where description = getContent <=< lookupChild "description" <=< lookupChild "channel" <=< lookupChild "rss" <=< wrap

getShouts :: IO ()
getShouts = do response <- Artist.getShouts (Just (Artist "Meshuggah")) Nothing Nothing Nothing (Just (Limit 5)) apiKey
               putStr "Last 5 shouts authors: "
               case response of
                 Left e  -> print e
                 Right r -> print (authors r)
  where authors = mapM (getContent <=< lookupChild "author") <=< lookupChildren "shout" <=< lookupChild "shouts" <=< wrap

getSimilar :: IO ()
getSimilar = do response <- Artist.getSimilar (Just (Artist "Meshuggah")) Nothing Nothing (Just (Limit 7)) apiKey
                putStr "7 similar artists: "
                case response of
                  Left e  -> print e
                  Right r -> print (artists r)
  where artists = mapM (getContent <=< lookupChild "name") <=< lookupChildren "artist" <=< lookupChild "similarartists" <=< wrap

getTopAlbums :: IO ()
getTopAlbums = do response <- Artist.getTopAlbums (Just (Artist "Meshuggah")) Nothing Nothing Nothing (Just (Limit 3)) apiKey
                  putStr "3 most popular albums: "
                  case response of
                    Left e  -> print e
                    Right r -> print (albums r)
  where albums = mapM (getContent <=< lookupChild "name") <=< lookupChildren "album" <=< lookupChild "topalbums" <=< wrap

getTopFans :: IO ()
getTopFans = do response <- Artist.getTopFans (Just (Artist "Meshuggah")) Nothing Nothing apiKey
                putStr "Top fans: "
                case response of
                  Left e  -> print e
                  Right r -> print (fans r)
  where fans = mapM (getContent <=< lookupChild "name") <=< lookupChildren "user" <=< lookupChild "topfans" <=< wrap

getTopTags :: IO ()
getTopTags = do response <- Artist.getTopTags (Just (Artist "Meshuggah")) Nothing Nothing apiKey
                putStr "Top tags: "
                case response of
                  Left e  -> print e
                  Right r -> print (tags r)
  where tags = mapM (getContent <=< lookupChild "name") <=< lookupChildren "tag" <=< lookupChild "toptags" <=< wrap

getTopTracks :: IO ()
getTopTracks = do response <- Artist.getTopTracks (Just (Artist "Meshuggah")) Nothing Nothing Nothing (Just (Limit 10)) apiKey
                  putStr "10 most popular tracks: "
                  case response of
                    Left e  -> print e
                    Right r -> print (tracks r)
  where tracks = mapM (getContent <=< lookupChild "name") <=< lookupChildren "track" <=< lookupChild "toptracks" <=< wrap

search :: IO ()
search = do response <- Artist.search (Artist "Mesh") Nothing (Just (Limit 12)) apiKey
            putStr "12 search results for \"Mesh\" query: "
            case response of
              Left e  -> print e
              Right r -> print (artists r)
  where artists = mapM (getContent <=< lookupChild "name") <=< lookupChildren "artist" <=< lookupChild "artistmatches" <=< lookupChild "results" <=< wrap

start :: IO ()
start = do -- addTags (requires authorization)
           getCorrection
           getEvents
           getImages
           getInfo
           getPastEvents
           getPodcast
           getShouts
           getSimilar
           -- getTags (requires authorization)
           getTopAlbums
           getTopFans
           getTopTags
           getTopTracks
           -- removeTag (requires authorization)
           search
           -- share (requires authorization)
           -- shout (requires authorization)