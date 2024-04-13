{
  description = "Personal Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    lanzaboote.url = "github:nix-community/lanzaboote";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      inherit (self) outputs;
      # Supported systems for your flake packages, shell, etc.
      systems = [ "x86_64-linux" ];
      # This is a function that generates an attribute by calling a function you
      # pass to it, with each system as an argument
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      # Your custom packages
      # Accessible through 'nix build', 'nix shell', etc
      packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#greypersonal'
      nixosConfigurations = {
        greypersonal = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs outputs;
          };
          modules = [
            # > Our main nixos configuration file <
            ./nixos/configuration.nix
            self.nixosModules
            (
              { pkgs, ... }:
              {
                gaming = true;
                steam = true;
                kde = true;
                battery = true;
                bluetooth = true;
                intel = true;
                lanzaboote = true;
                pipewire = true;
                git = true;
                gnupg = true;
              }
            )
          ] ++ builtins.attrValues self.nixosModules;
        };
      };

      # Standalone home-manager configuration entrypoint
      # Available through 'home-manager --flake .#greysilly7@greypersonal'
      homeConfigurations = {
        "greysilly7@greypersonal" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
          extraSpecialArgs = {
            inherit inputs outputs;
          };
          modules = [
            # > Our main home-manager configuration file <
            ./home-manager/home.nix

            (
              { pkgs, ... }:
              {
                kitty = true;
                git = true;
              }
            )
          ] ++ builtins.attrValues self.homeManagerModules;
        };
      };
    };
}
