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
import Control.Monad.State (class MonadState)
import Data.Lens (Lens', use, (?=))
import Data.Maybe (Maybe(Nothing, Just))
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

logger ∷
  ∀ defaultFields eff fields m r state
  . MonadEff (systemd ∷ SYSTEMD | eff) m
  ⇒ MonadState state m
  ⇒ Record defaultFields
  → Lens' state (Maybe Journald)
  → Logger m (Record (level ∷ Level, message ∷ String, fields ∷ Record fields | r))
logger defaultFields journaldL =
  Logger log'
 where
  log' r = do
    ml ← use journaldL
    case ml of
      Just j → log j r
      Nothing → do
        j ← liftEff (journald defaultFields)
        journaldL ?= j
        log j r

log ∷ ∀ eff fields m r
  .  MonadEff (systemd ∷ SYSTEMD | eff) m
  ⇒ Journald
  → Record
    ( level :: Level
    , message :: String
    , fields :: Record fields
    | r
    )
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
