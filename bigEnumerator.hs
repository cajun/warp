{-# LANGUAGE OverloadedStrings, BangPatterns #-}
import Network.Wai
import Network.Wai.Handler.Warp
import Blaze.ByteString.Builder (fromByteString)
import qualified Data.ByteString.Char8 as B
import Data.Enumerator (Iteratee, ($$), joinI, enumList, run_) 

kilo = fromByteString $ B.pack $ take 1024 $ repeat '.'
kilos n = take (fromInteger n) $ repeat kilo

response n = re
  where re = ResponseEnumerator $ \f -> run_ $ enumList 1 (kilos n) $$ f s h 
        s = status200
        h = [ ("Content-Type", "text/plain")
            , ("Content-Length", B.pack $ show $ n * 1024)
            ]

main = run 3000 $ const $ return $ response 128
