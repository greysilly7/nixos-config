{
  description = "";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    firefox = {
      url = "github:nix-community/flake-firefox-nightly";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:gerg-l/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: let
    pkgs = nixpkgs.legacyPackages.x86_64-linux;
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
        lanzaboote = inputs.lanzaboote.nixosModules.lanzaboote;
      }
      // import ./modules;

    inherit theme;
    packages.x86_64-linux = user.packages;
    formatter.x86_64-linux = pkgs.alejandra;
    devShells.x86_64-linux.default = user.shell;
  };
}
