module Main where

import Graphics.Rendering.Chart.Easy
import Graphics.Rendering.Chart.Backend
import Data.Time.LocalTime
import Data.Time.Calendar

prices' :: [(LocalTime, Double)]
prices' = [(mkDateTime 21 10 1997 10 15, 1337)]

mkDateTime dd mm yyyy hh nn =
    LocalTime (fromGregorian (fromIntegral yyyy) mm dd)
              (dayFractionToTimeOfDay ((hh*60+nn)/1440))

main = toFile def "example2_big.png" $ do
    layoutlr_title .= "Price History"
    layoutlr_left_axis . laxis_override .= axisGridHide
    plotLeft (line "price 1" [ [ (d,v) | (d,v,_) <- prices'] ])