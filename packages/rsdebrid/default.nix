{ lib, rustPlatform }:
let
  src = /home/greysilly7/rsdebrid;
  cargoToml = lib.importTOML "${src}/crates/api/Cargo.toml";
in
rustPlatform.buildRustPackage {
  pname = cargoToml.package.name;
  version = cargoToml.package.version;

  src = lib.fileset.toSource {
    root = src;
    fileset = lib.fileset.unions [
      (src + "/Cargo.toml")
      (src + "/Cargo.lock")
      (src + "/crates")
      # add any other dirs the build needs, e.g. migrations, build.rs assets
    ];
  };

  cargoLock.lockFile = src + "/Cargo.lock";

  doCheck = false;

  meta = with lib; {
    description = "rsdebrid API and worker";
    mainProgram = "rsdebrid-api";
  };
}
