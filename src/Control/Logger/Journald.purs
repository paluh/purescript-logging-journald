module Control.Logger.Journald
  ( Level(..)
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
  Logger log
 where
  log r = do
    ml ← use journaldL
    case ml of
      Just l → log' r l
      Nothing → do
        l ← liftEff (journald defaultFields)
        journaldL ?= l
        log' r l

  log' r l =
    case r.level of
      Emerg → liftEff $ emerg l r.message r.fields
      Alert → liftEff $ alert l r.message r.fields
      Crit → liftEff $ crit l r.message r.fields
      Err → liftEff $ err l r.message r.fields
      Warning → liftEff $ warning l r.message r.fields
      Notice → liftEff $ notice l r.message r.fields
      Info → liftEff $ info l r.message r.fields
      Debug → liftEff $ debug l r.message r.fields
