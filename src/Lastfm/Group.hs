{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
-- | Lastfm group API
--
-- This module is intended to be imported qualified:
--
-- @
-- import qualified Lastfm.Group as Group
-- @
module Lastfm.Group
  ( getHype, getMembers, getWeeklyAlbumChart, getWeeklyArtistChart, getWeeklyChartList, getWeeklyTrackChart
  ) where

import Lastfm.Request


-- | Get the hype list for a group
--
-- <http://www.last.fm/api/show/group.getHype>
getHype :: Request f (Group -> APIKey -> Ready)
getHype = api "group.getHype"


-- | Get a list of members for this group.
--
-- Optional: 'page', 'limit'
--
-- <http://www.last.fm/api/show/group.getMembers>
getMembers :: Request f (Group -> APIKey -> Ready)
getMembers = api "group.getMembers"


-- | Get an album chart for a group, for a given date range.
-- If no date range is supplied, it will return the most recent album chart for this group.
--
-- Optional: 'from', 'to'
--
-- <http://www.last.fm/api/show/group.getWeeklyAlbumChart>
getWeeklyAlbumChart :: Request f (Group -> APIKey -> Ready)
getWeeklyAlbumChart = api "group.getWeeklyAlbumChart"


-- | Get an artist chart for a group, for a given date range.
-- If no date range is supplied, it will return the most recent album chart for this group.
--
-- Optional: 'from', 'to'
--
-- <http://www.last.fm/api/show/group.getWeeklyArtistChart>
getWeeklyArtistChart :: Request f (Group -> APIKey -> Ready)
getWeeklyArtistChart = api "group.getWeeklyArtistChart"


-- | Get a list of available charts for this group, expressed as
-- date ranges which can be sent to the chart services.
--
-- <http://www.last.fm/api/show/group.getWeeklyChartList>
getWeeklyChartList :: Request f (Group -> APIKey -> Ready)
getWeeklyChartList = api "group.getWeeklyChartList"


-- | Get a track chart for a group, for a given date range.
-- If no date range is supplied, it will return the most recent album chart for this group.
--
-- Optional: 'from', 'to'
--
-- <http://www.last.fm/api/show/group.getWeeklyTrackChart>
getWeeklyTrackChart :: Request f (Group -> APIKey -> Ready)
getWeeklyTrackChart = api "group.getWeeklyTrackChart"
