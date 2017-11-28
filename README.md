# purescript-logging-journald

A glue function which connects `purescript-logging` and `purescript-systemd-journald`. I'm not sure if it is worth publishing...


## API

This logger expects that you run it inside some `MonadEff` and `MonadState` which provides state to store `Journald` instance. To create logger please provide `Lens'` for this instance:

   ```purescript
    logger ∷
      ∀ defaultFields eff fields m r state
      . MonadEff (systemd ∷ SYSTEMD | eff) m
      ⇒ MonadState state m
      ⇒ Record defaultFields
      → Lens' state (Maybe Journald)
      → Logger m (Record (level ∷ Level, message ∷ String, fields ∷ Record fields | r))
    logger defaultFields journaldL = ...
   ```

## Usage

Minimal, working example copied from `tests/Main.purs`:


  ```purescript
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
      log j { level: Emerg, message: "first", fields: { extraInfo: "extra1" }}
      log j { level: Debug, message: "second", fields: { extraInfo: "extra2" }}

    main :: ∀ eff. Eff (systemd ∷ SYSTEMD | eff) Unit
    main = do
      evalStateT loggingSession { journaldInstance: Nothing }
      pure unit
  ```
