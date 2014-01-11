{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
module Group (noauth) where

import Control.Lens.Aeson
import Data.Text (Text)
import Network.Lastfm
import Network.Lastfm.Group
import Test.Framework
import Test.Framework.Providers.HUnit

import Helper


noauth :: [Test]
noauth =
  [ testCase "Group.getHype" testGetHype
  , testCase "Group.getMembers" testGetMembers
  , testCase "Group.getWeeklyAlbumChart" testGetWeeklyAlbumChart
  , testCase "Group.getWeeklyArtistChart" testGetWeeklyArtistChart
  , testCase "Group.getWeeklyChartList" testGetWeeklyChartList
  , testCase "Group.getWeeklyTrackChart" testGetWeeklyTrackChart
  ]
 where
  g = "People with no social lives that listen to more music than is healthy who are slightly scared of spiders and can never seem to find a pen"

  testGetHype = query gh $
    getHype <*> group g <*> publicKey

  testGetMembers = query gm $
    getMembers <*> group g <* limit 10 <*> publicKey

  testGetWeeklyAlbumChart = query ga $
    getWeeklyAlbumChart <*> group g <*> publicKey

  testGetWeeklyArtistChart = query gar $
    getWeeklyArtistChart <*> group g <*> publicKey

  testGetWeeklyChartList = query gc $
    getWeeklyChartList <*> group g <*> publicKey

  testGetWeeklyTrackChart = query gt $
    getWeeklyTrackChart <*> group g <*> publicKey


ga, gar, gc, gh, gm, gt :: Query Text
ga  = key "weeklyalbumchart".key "album".values.key "playcount"._String
gar = key "weeklyartistchart".key "artist".values.key "name"._String
gc  = key "weeklychartlist".key "chart".values.key "from"._String
gh  = key "weeklyartistchart".key "artist".values.key "mbid"._String
gm  = key "members".key "user".values.key "name"._String
gt  = key "weeklytrackchart".key "track".values.key "url"._String
