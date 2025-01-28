{
  description = "My personal nixos config that is a mix of like three people's";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      overlays = [
        inputs.nixpkgs-wayland.overlay
      ];
    };
    theme = import ./theme;
    user = import ./user {
      inherit pkgs theme;
    };
  in {
    nixosConfigurations = import ./hosts inputs;
    nixosModules =
      {
        system = import ./system;
        user = user.module;

        disko = inputs.disko.nixosModules.default;
        sops-nix = inputs.sops-nix.nixosModules.sops;
        spicetify-nix = inputs.spicetify-nix.nixosModules.default;
        lanzaboote = inputs.lanzaboote.nixosModules.lanzaboote;
        factor = inputs.nixos-facter-modules.nixosModules.facter;
        chaotic = inputs.chaotic.nixosModules.default;
      }
      // import ./modules;

    inherit theme;
    packages.x86_64-linux = user.packages;
    formatter.x86_64-linux = pkgs.alejandra;
    devShells.x86_64-linux.default = user.shell;
  };
}
