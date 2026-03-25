{
  description = "My nixos-config";

  inputs = {
    treefmt-nix.url = "github:numtide/treefmt-nix";
    systems.url = "github:nix-systems/default";

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";
    disko.url = "github:nix-community/disko";
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs = {
        home-manager.follows = "";
        nixpkgs.follows = "";
      };
    };

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
    inputs: with inputs; let
          eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});
                treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosConfigurations = {
        laptop = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            nixos-facter-modules.nixosModules.facter
            disko.nixosModules.default
            sops-nix.nixosModules.sops
            inputs.impermanence.nixosModules.impermanence
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
        fastbar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            sops-nix.nixosModules.sops
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
      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
      # for `nix flake check`
      checks = eachSystem (pkgs: {
        formatting = treefmtEval.${pkgs.system}.config.build.check self;
      });
    };

}
