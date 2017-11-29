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
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Node.Systemd.Journald (Journald, SYSTEMD, alert, crit, debug, emerg, err, info, journald, notice, warning)

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
  ∀ eff fields m
  . MonadEff (systemd ∷ SYSTEMD | eff) m
  ⇒ Journald
  → JournaldLogger m fields
logger j = Logger (\r → logJournald j r)

logger' ∷
  ∀ eff fields m
  . MonadEff (systemd ∷ SYSTEMD | eff) m
  ⇒ m Journald
  → m (JournaldLogger m fields)
logger' j = logger <$> j

logJournald ∷ ∀ eff fields m
  .  MonadEff (systemd ∷ SYSTEMD | eff) m
  ⇒ Journald
  → LogEntry fields
  → m Unit
logJournald journald r =
  case r.level of
    Emerg → liftEff $ emerg journald r.message r.fields
    Alert → liftEff $ alert journald r.message r.fields
    Crit → liftEff $ crit journald r.message r.fields
    Err → liftEff $ err journald r.message r.fields
    Warning → liftEff $ warning journald r.message r.fields
    Notice → liftEff $ notice journald r.message r.fields
    Info → liftEff $ info journald r.message r.fields
    Debug → liftEff $ debug journald r.message r.fields

