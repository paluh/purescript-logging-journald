module Test.Main where

import Prelude

import Control.Logger (log)
import Control.Logger.Journald (Journald, logger, Level(..), SYSTEMD)
import Control.Monad.Eff (Eff)
import Control.Monad.State (StateT, evalStateT)
import Data.Lens (Lens')
import Data.Lens.Record (prop)
import Data.Maybe (Maybe(..))
import Type.Prelude (SProxy(..))

type State = { journaldInstance ∷ Maybe Journald }

journaldL ∷ Lens' {journaldInstance ∷ Maybe Journald} (Maybe Journald)
journaldL = prop (SProxy ∷ SProxy "journaldInstance")

loggingSession :: ∀ eff. StateT State (Eff (systemd ∷ SYSTEMD | eff)) Unit
loggingSession = do
  let j = logger {} journaldL
  log j { level: Emerg, message: "first", fields: {extraInfo: "extra1"} }
  log j { level: Debug, message: "second", fields: {extraInfo: "extra2"} }

main :: ∀ eff. Eff (systemd ∷ SYSTEMD | eff) Unit
main = do
  evalStateT loggingSession { journaldInstance: Nothing }
  pure unit
