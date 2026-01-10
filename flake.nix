{
  description = "My nixos-config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    disko.url = "github:nix-community/disko";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=refs/tags/v0.50.1";
    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.50.0";
      inputs.hyprland.follows = "hyprland";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spacebar = {
      url = "github:spacebarchat/server";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    greysilly7-xyz = {
      url = "github:greysilly7/greysilly7.xyz";
      flake = false;
    };
  };

  outputs =
    inputs: with inputs; {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lix-module.nixosModules.default
            nixos-facter-modules.nixosModules.facter
            disko.nixosModules.default
            sops-nix.nixosModules.sops
            { config.facter.reportPath = ./hosts/laptop/facter.json; }
            ./hosts/laptop/configuration.nix

            (
              { ... }:
              {
                nix = {
                  registry.nixpkgs.flake = nixpkgs;
                  nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
                };
              }
            )
          ];
          specialArgs = {
            inherit hyprland;
            inherit hy3;
            flake = self;
          };
        };
        poweredge-r720 = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lix-module.nixosModules.default
            nixos-facter-modules.nixosModules.facter
            disko.nixosModules.default
            sops-nix.nixosModules.sops
            spacebar.nixosModules.default
            {
              config.facter.reportPath = ./hosts/poweredge-r720/facter.json;
            }
            ./hosts/poweredge-r720/configuration.nix

            (
              { ... }:
              {
                nix = {
                  registry.nixpkgs.flake = nixpkgs;
                  nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
                };
              }
            )
          ];
          specialArgs = {
            flake = self;
            inherit greysilly7-xyz;
          };
        };
        fastbar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            lix-module.nixosModules.default
            ./hosts/fastbar/configuration.nix

            (
              { ... }:
              {
                nix = {
                  registry.nixpkgs.flake = nixpkgs;
                  nixPath = [ "nixpkgs=${nixpkgs.outPath}" ];
                };
              }
            )
          ];
          specialArgs = {
            flake = self;
            inherit inputs spacebar;
          };
        };

      };
      packages.x86_64-linux = import ./pkgs {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
      };
    };

}
