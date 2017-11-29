# purescript-logging-journald

A glue function which connects `purescript-logging` and `purescript-systemd-journald`. I'm not sure if it is worth publishing...

## Usage

  ```purescript
    import Control.Logger (log)
    import Control.Logger.Journald (Level(Debug, Emerg), SYSTEMD, journald, logger)
    import Control.Monad.Eff (Eff)

    main :: ∀ eff. Eff (systemd ∷ SYSTEMD | eff) Unit
    main = do
      j ← journald {}
      let l = logger j
      log l { level: Emerg, message: "first", fields: {extraInfo: "extra1"} }
      log l { level: Debug, message: "second", fields: {extraInfo: "extra2"} }
  ```
