module Control.Logger.Journald
  ( JournaldLogger
  , Level(..)
  , logger
  , logger'
  , LogEntry
  , module Node.Systemd.Journald
  )
  where

import Prelude

import Control.Logger (Logger(..))
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Effect.Class (class MonadEffect, liftEffect)
import Node.Systemd.Journald (Journald, alert, crit, debug, emerg, err, info, notice, warning)

data Level
  = Debug
  | Info
  | Notice
  | Warning
  | Err
  | Crit
  | Alert
  | Emerg
derive instance genericLevel ∷ Generic Level _
derive instance eqLevel ∷ Eq Level
derive instance ordLevel ∷ Ord Level
instance showLevel ∷ Show Level where
  show = genericShow

type LogEntry fields = { level ∷ Level, message ∷ String, fields ∷ Record fields }
type JournaldLogger m fields = Logger m (LogEntry fields)

logger ∷
  ∀ fields m
  . MonadEffect m
  ⇒ Journald
  → JournaldLogger m fields
logger j = Logger (\r → logJournald j r)

logger' ∷
  ∀ fields m
  . MonadEffect m
  ⇒ m Journald
  → m (JournaldLogger m fields)
logger' j = logger <$> j

logJournald ∷ ∀ fields m
  . MonadEffect m
  ⇒ Journald
  → LogEntry fields
  → m Unit
logJournald journald r =
  case r.level of
    Emerg → liftEffect $ emerg journald r.message r.fields
    Alert → liftEffect $ alert journald r.message r.fields
    Crit → liftEffect $ crit journald r.message r.fields
    Err → liftEffect $ err journald r.message r.fields
    Warning → liftEffect $ warning journald r.message r.fields
    Notice → liftEffect $ notice journald r.message r.fields
    Info → liftEffect $ info journald r.message r.fields
    Debug → liftEffect $ debug journald r.message r.fields

