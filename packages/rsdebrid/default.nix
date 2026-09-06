{ lib, rustPlatform }:
let
  src = builtins.fetchGit {
    url = "git@github.com:Alpaca-Industries/rsdebrid.git";
    rev = "424dfb94f6318fbd8fd9d9c2d046d03db37df5ee";
  };
  cargoToml = lib.importTOML "${src}/crates/api/Cargo.toml";
in
rustPlatform.buildRustPackage {
  pname = cargoToml.package.name;
  version = cargoToml.package.version;

  inherit src;

  cargoLock.lockFile = src + "/Cargo.lock";

  doCheck = false;

  meta = with lib; {
    description = "rsdebrid API and worker";
    mainProgram = "rsdebrid-api";
  };
}
