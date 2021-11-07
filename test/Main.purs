module Test.Main where

import Prelude

import Control.Logger (log)
import Control.Logger.Journald (Level(Debug, Emerg), logger)
import Effect (Effect)
import Node.Systemd.Journald (journald)

main :: Effect Unit
main = do
  j <- journald {}
  let l = logger j
  log l { level: Emerg, message: "first", fields: { extraInfo: "extra1" } }
  log l { level: Debug, message: "second", fields: { extraInfo: "extra2" } }
