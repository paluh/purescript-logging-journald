# purescript-logging-journald

A drop of glue between `purescript-logging` and `purescript-systemd-journald`.

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

There is also `logger'` constructor if you want to work in given monad:

  ```purescript
    l' ← logger' (journald {})
  ```

You can provide extra fields (through `fields` attribute) - `purescript-systemd-journald` accepts nearly anything there. For more info please consult it's docs.


## Log levels

There are `Ord` and `Eq` instances provided for `Level` type so you can do filtering like `cfilter (\e → e.level > Warning)`.

