{ name = "logging-journald"
, dependencies = [ "effect", "logging", "prelude", "systemd-journald" ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
, license = "BSD-3-Clause"
, repository = "https://github.com/paluh/purescript-logging-journald.git"
}
