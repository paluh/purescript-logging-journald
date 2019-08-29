module Control.Logger.Journald.Types where

import Prelude

import Control.Logger (Logger)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

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
