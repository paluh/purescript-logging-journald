module Control.Logger.Journald
  ( logger
  , logger'
  , module Node.Systemd.Journald
  , module Types
  ) where

import Prelude

import Control.Logger (Logger(..))
import Control.Logger.Journald.Types (JournaldLogger, Level(..), LogEntry)
import Control.Logger.Journald.Types (JournaldLogger, Level(..), LogEntry) as Types
import Effect.Class (class MonadEffect, liftEffect)
import Node.Systemd.Journald (Journald, alert, crit, debug, emerg, err, info, notice, warning)

logger
  :: forall fields m
   . MonadEffect m
  => Journald
  -> JournaldLogger m fields
logger j = Logger (\r -> logJournald j r)

logger'
  :: forall fields m
   . MonadEffect m
  => m Journald
  -> m (JournaldLogger m fields)
logger' j = logger <$> j

logJournald
  :: forall fields m
   . MonadEffect m
  => Journald
  -> LogEntry fields
  -> m Unit
logJournald journald r =
  case r.level of
    Emerg -> liftEffect $ emerg journald r.message r.fields
    Alert -> liftEffect $ alert journald r.message r.fields
    Crit -> liftEffect $ crit journald r.message r.fields
    Err -> liftEffect $ err journald r.message r.fields
    Warning -> liftEffect $ warning journald r.message r.fields
    Notice -> liftEffect $ notice journald r.message r.fields
    Info -> liftEffect $ info journald r.message r.fields
    Debug -> liftEffect $ debug journald r.message r.fields
