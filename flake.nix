{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    alejandra.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    chaotic,
    sops-nix,
    srvos,
    ...
  } @ inputs: {
    nixosConfigurations.greypersonal = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };

      modules = [
        srvos.nixosModules.desktop
        ./hosts/greypersonal/configuration.nix
        chaotic.nixosModules.default
        sops-nix.nixosModules.sops
        home-manager.nixosModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.greysilly7 = import ./home/greysilly7/home.nix;

          nix.settings.trusted-users = ["greysilly7"];
        }
      ];
    };

    nixosConfigurations.greyserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit inputs;
      };

      modules = [
        srvos.nixosModules.server
        ./hosts/greyserver/configuration.nix
        sops-nix.nixosModules.sops
        home-manager.nixosModule
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.greysilly7 = import ./home/greysilly7/home.nix;

          nix.settings.trusted-users = ["greysilly7"];
        }
      ];
    };
  };
}
