{
  description = "Flutter/Dart devShell -- Xcode-aware, no global pollution";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "aarch64-darwin" "x86_64-linux" ];
      pkgsFor = system: import nixpkgs { inherit system; };
    in {
      devShells = forAllSystems (system: {
        default = (pkgsFor system).mkShell {
          packages = with (pkgsFor system); [
            flutter
            dart
          ];

          shellHook = ''
            export FLUTTER_XCODE_DIR="/Applications/Xcode.app/Contents/Developer"
          '';
        };
      });
    };
}
