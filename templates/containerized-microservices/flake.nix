{
  description = "Containerized microservice devShell";

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
            podman-compose
            dive
            skopeo
            yaml-language-server
          ];

          shellHook = ''
            if ! podman machine inspect --format '{{.Name}}' 2>/dev/null | grep -q microservice; then
              echo "Run: podman machine init --cpus 4 --memory 4096 microservice"
            fi
          '';
        };
      });
    };
}
