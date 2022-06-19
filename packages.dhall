let mkPackage =
      https://raw.githubusercontent.com/purescript/package-sets/psc-0.13.0-20190626/src/mkPackage.dhall
        sha256:0b197efa1d397ace6eb46b243ff2d73a3da5638d8d0ac8473e8e4a8fc528cf57

let upstream =
      https://github.com/purescript/package-sets/releases/download/psc-0.15.2-20220615/packages.dhall
        sha256:6b62a899c22125a2735a7c354bbb66a2fe24ff45cec0a8b8b890769a01a99210

in  upstream
  with systemd-journald =
      mkPackage
        [ "effect", "prelude" ]
        "https://git@github.com/paluh/purescript-systemd-journald.git"
        "v0.3.0"
