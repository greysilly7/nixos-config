{ lib, rustPlatform }:
rustPlatform.buildRustPackage {
  pname = "rsdebrid";
  version = "0.1.0";
  src = /home/greysilly7/rsdebrid;

  cargoLock.lockFile = /home/greysilly7/rsdebrid/Cargo.lock;

  doCheck = false;

  meta = with lib; {
    description = "rsdebrid API and worker";
    mainProgram = "rsdebrid-api";
  };
}
