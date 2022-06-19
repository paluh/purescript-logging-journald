module Control.Logger.Journald.Types where

import Prelude

import Control.Logger (Logger)
import Data.Generic.Rep (class Generic)
import Data.Show.Generic (genericShow)

data Level
  = Debug
  | Info
  | Notice
  | Warning
  | Err
  | Crit
  | Alert
  | Emerg

derive instance Generic Level _
derive instance Eq Level
derive instance Ord Level
instance Show Level where
  show = genericShow

type LogEntry fields = { level :: Level, message :: String, fields :: Record fields }
type JournaldLogger m fields = Logger m (LogEntry fields)
