{
  description = "flake.nix for the NixOS configuration of my personal laptop";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    disko.url = "github:nix-community/disko";
    sops-nix.url = "github:Mic92/sops-nix";
    firefox.url = "github:nix-community/flake-firefox-nightly";
    spicetify-nix.url = "github:gerg-l/spicetify-nix";
    lanzaboote.url = "github:nix-community/lanzaboote";
    nvchad4nix = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    cursor.url = "github:omarcresp/cursor-flake/main";
  };
  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    defaultSystem = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit inputs;
      system = defaultSystem;
    };

    mkHost = {
      path,
      system,
      modules,
      overlays,
    }: let
      theme = import ./theme.nix;
    in
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit inputs theme;
          flake = self;
        };
        modules =
          [
            {
              networking.hostName = nixpkgs.lib.mkDefault (nixpkgs.lib.removeSuffix ".nix" (baseNameOf path));
              nixpkgs.overlays = overlays;
              system.stateVersion = nixpkgs.lib.mkDefault "25.05";
            }
            (import path)
          ]
          ++ modules;
      };
  in {
    nixosConfigurations = let
      sharedModules = [
        inputs.nixos-facter-modules.nixosModules.facter
        inputs.disko.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.spicetify-nix.nixosModules.default
        inputs.lanzaboote.nixosModules.lanzaboote
      ];
    in {
      gaminglaptop = mkHost {
        path = ./hosts/gaminglaptop;
        system = defaultSystem;
        modules = [] ++ sharedModules;
        overlays = [];
      };
    };
    formatter.x86_64-linux = pkgs.alejandra;
    packages.x86_64-linux = import ./pkgs pkgs;
  };
}
