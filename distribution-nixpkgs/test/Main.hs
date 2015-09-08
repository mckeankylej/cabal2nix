module Main ( main ) where

import Control.DeepSeq
import Control.Exception
import Control.Lens
import Distribution.Nixpkgs.License
import Distribution.Nixpkgs.Meta
import Test.DocTest
import Test.Hspec

main :: IO ()
main = do
  doctest [ "-isrc", "-optP-include", "-optPdist/build/autogen/cabal_macros.h", "src" ]

  hspec $ do
    describe "DeepSeq instances work properly for" $ do
      it "License" $ mapM_ hitsBottom [Known undefined, Unknown (Just undefined)]
      it "Meta" $ mapM_ hitsBottom
                    [ nullMeta & homepage .~ undefined
                    , nullMeta & description .~ undefined
                    , nullMeta & license .~ undefined
                    , nullMeta & platforms .~ undefined
                    , nullMeta & maintainers .~ undefined
                    , nullMeta & broken .~ undefined
                    ]

hitsBottom :: NFData a => a -> Expectation
hitsBottom x = evaluate (rnf x) `shouldThrow` anyErrorCall
