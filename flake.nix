{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    theme = import ./theme;
    user = import ./user {
      inherit pkgs theme;
      flake = self;
    };
  in {
    packages = {};
    nixosConfigurations = import ./hosts inputs;
    nixosModules =
      {
        system = import ./system;
        user = user.module;
        disko = inputs.disko.nixosModules.default;
        sops-nix = inputs.sops-nix.nixosModules.sops;
        spicetify-nix = inputs.spicetify-nix.nixosModules.default;
        inherit (inputs.lanzaboote.nixosModules) lanzaboote;
        factor = inputs.nixos-facter-modules.nixosModules.facter;
      }
      // import ./modules;

    inherit theme;
    packages.x86_64-linux = user.packages;
    formatter.x86_64-linux = pkgs.alejandra;
    devShells.x86_64-linux.default = user.shell;
  };
}
