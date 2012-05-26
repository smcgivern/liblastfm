module Network.Lastfm.API.Event
  ( attend, getAttendees, getInfo, getShouts, share, shout
  ) where

import Network.Lastfm

attend ∷ ResponseType → Event → Status → APIKey → SessionKey → Secret → Lastfm Response
attend t event status apiKey sessionKey secret = callAPIsigned t secret
  [ (#) (Method "event.attend")
  , (#) event
  , (#) status
  , (#) apiKey
  , (#) sessionKey
  ]

getAttendees ∷ ResponseType → Event → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getAttendees t event page limit apiKey = callAPI t
  [ (#) (Method "event.getAttendees")
  , (#) event
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

getInfo ∷ ResponseType → Event → APIKey → Lastfm Response
getInfo t event apiKey = callAPI t
  [ (#) (Method "event.getInfo")
  , (#) event
  , (#) apiKey
  ]

getShouts ∷ ResponseType → Event → Maybe Page → Maybe Limit → APIKey → Lastfm Response
getShouts t event page limit apiKey = callAPI t
  [ (#) (Method "event.getShouts")
  , (#) event
  , (#) page
  , (#) limit
  , (#) apiKey
  ]

share ∷ ResponseType → Event → Recipient → Maybe Message → Maybe Public → APIKey → SessionKey → Secret → Lastfm Response
share t event recipient message public apiKey sessionKey secret = callAPIsigned t secret
  [ (#) (Method "event.share")
  , (#) event
  , (#) public
  , (#) message
  , (#) recipient
  , (#) apiKey
  , (#) sessionKey
  ]

shout ∷ ResponseType → Event → Message → APIKey → SessionKey → Secret → Lastfm Response
shout t event message apiKey sessionKey secret = callAPIsigned t secret
  [ (#) (Method "event.shout")
  , (#) event
  , (#) message
  , (#) apiKey
  , (#) sessionKey
  ]
