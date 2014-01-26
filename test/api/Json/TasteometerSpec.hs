{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
module Json.TasteometerSpec (spec) where

import           Control.Lens.Aeson
import           Data.Text (Text)
import           Network.Lastfm
import qualified Network.Lastfm.Tasteometer as Taste
import           Test.Hspec

import           SpecHelper


spec :: Spec
spec = do
  it "compare" $
    publicly (Taste.compare (user "smpcln") (user "MCDOOMDESTROYER"))
   `shouldHaveJson`
    jsonQuery

  it "compare" $
    publicly (Taste.compare (user "smpcln") (artists ["enduser", "venetian snares"]))
   `shouldHaveJson`
    jsonQuery

  it "compare" $
    publicly (Taste.compare (artists ["enduser", "venetian snares"]) (user "smpcln"))
   `shouldHaveJson`
    jsonQuery

  it "compare" $
    publicly (Taste.compare (artists ["enduser", "venetian snares"]) (artists ["enduser", "venetian snares"]))
   `shouldHaveJson`
    jsonQuery

jsonQuery :: Query JSON Text
jsonQuery = key "comparison".key "result".key "score"._String