{
  lib,
  pkgs,
  inputs,
  system,
  ...
}:

let
  # 1. Instantiate the oxalica rust-overlay for this specific system
  rustPkgs = import inputs.nixpkgs {
    inherit system;
    overlays = [ inputs.rust-overlay.overlays.default ];
  };

  # 2. Grab the exact Rust toolchain the upstream project expects
  rustToolchain = rustPkgs.rust-bin.stable."1.96.0".default;

  # 3. Initialize crane and override its default toolchain with our specific one
  craneLib = (inputs.crane.mkLib pkgs).overrideToolchain rustToolchain;

  src = pkgs.fetchFromGitHub {
    owner = "olivertgwalton";
    repo = "riven-rs";
    rev = "be8a47c528786414318dfa4f99091830c4ef74d0";
    hash = "sha256-MQiMjbAgYSefZ5cJ7bPkG1CGMl26GkD0MXb7U8SZvQ4==";
  };

  # 4. Define our build arguments once
  commonArgs = {
    inherit src;
    pname = "riven";
    version = "unstable-2026-06-19";

    strictDeps = true;

    nativeBuildInputs = [ pkgs.pkg-config ];
    buildInputs = [
      pkgs.fuse3
      pkgs.openssl
    ];

    SQLX_OFFLINE = "true";
  };

  # 5. Build just the cargo dependencies to leverage Nix caching
  cargoArtifacts = craneLib.buildDepsOnly commonArgs;
in
# 6. Build the final application
craneLib.buildPackage (
  commonArgs
  // {
    inherit cargoArtifacts;

    meta = with lib; {
      description = "Rust implementation of the Riven Media tool";
      homepage = "https://github.com/olivertgwalton/riven-rs";
      license = licenses.mit;
      mainProgram = "riven";
    };
  }
)
