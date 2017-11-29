module Control.Logger.Journald
  ( Level(..)
  , log
  , logger
  , module Node.Systemd.Journald
  )
  where

import Prelude

import Control.Logger (Logger(..))
import Control.Monad.Eff.Class (class MonadEff, liftEff)
import Node.Systemd.Journald (Journald, SYSTEMD, alert, crit, debug, emerg, err, info, journald, notice, warning)

data Level
  = Emerg
  | Alert
  | Crit
  | Err
  | Warning
  | Notice
  | Info
  | Debug

type LogEntry fields = { level ∷ Level, message ∷ String, fields ∷ Record fields }
type JournaldLogger m fields = Logger m (LogEntry fields)

logger ∷
  ∀ eff fields m
  . MonadEff (systemd ∷ SYSTEMD | eff) m
  ⇒ Journald
  → JournaldLogger m fields
logger j = Logger (\r → log j r)

log ∷ ∀ eff fields m
  .  MonadEff (systemd ∷ SYSTEMD | eff) m
  ⇒ Journald
  → LogEntry fields
  → m Unit
log journald r =
  case r.level of
    Emerg → liftEff $ emerg journald r.message r.fields
    Alert → liftEff $ alert journald r.message r.fields
    Crit → liftEff $ crit journald r.message r.fields
    Err → liftEff $ err journald r.message r.fields
    Warning → liftEff $ warning journald r.message r.fields
    Notice → liftEff $ notice journald r.message r.fields
    Info → liftEff $ info journald r.message r.fields
    Debug → liftEff $ debug journald r.message r.fields
