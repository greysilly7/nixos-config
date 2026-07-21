{
  description = "Rust devShell with memory-efficient defaults";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, nixpkgs, rust-overlay }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ];
      pkgsFor = system: import nixpkgs {
        inherit system;
        overlays = [ rust-overlay.overlays.default ];
      };
    in {
      devShells = forAllSystems (system: {
        default = (pkgsFor system).mkShell {
          packages = with (pkgsFor system); [
            (rust-bin.stable.latest.default.override {
              extensions = [ "rust-analyzer" "rust-src" "clippy" ];
            })
            cargo-nextest
            cargo-audit
            cargo-deny
          ];

          RUSTFLAGS = "-C link-arg=-fuse-ld=lld";
          CARGO_BUILD_RUSTFLAGS = "-C link-arg=-fuse-ld=lld";
        };
      });
    };
}
