{
  self,
  nixpkgs,
  ...
}: let
  inherit (self) inputs;
  core = ../system/core;
  bootloader = ../system/core/bootloader.nix;
  impermanence = ../system/core/impermanence.nix;
  server = ../system/server;
  wayland = ../system/wayland;
  gaming = ../system/gaming;
  sunshine = ../system/gaming/sunshine.nix;
  sops-nix = inputs.sops-nix.nixosModules.sops;
  disko = inputs.disko.nixosModules.default;
  hmModule = inputs.home-manager.nixosModules.home-manager;

  # Shared Modules
  shared = [core sops-nix disko];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = ".bak";
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
  };
in {
  # My personal workstation/ laptop
  greyworkstation = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        inputs.nixos-wsl.nixosModules.default
        {
          system.stateVersion = "24.05";
          wsl.enable = true;
          wsl.useWindowsDriver = true;

          networking = {
            hostName = "greyworkstation";
          };
        }
        ./greyworkstation
        hmModule

        {
          inherit home-manager;
        }
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
  # My personal laptop
  greypersonal = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {
          networking = {
            hostName = "greypersonal";
          };
        }
        ./greypersonal
        hmModule
        bootloader
        impermanence
        wayland
        gaming

        {
          inherit home-manager;
        }
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  greyserver = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "greyserver";}
        ./greyserver
        hmModule
        bootloader
        server

        {
          inherit home-manager;
        }
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  iso-installer = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";

    modules = [
      {networking.hostName = "iso-installer";}
      "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix"

      ./iso-installer
      disko
    ];
    specialArgs = {inherit inputs;};
  };

  # My Future Potential Raspberry PI 4 System
  /*
  greyrpi = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules =
      [
        {networking.hostName = "greyrpi";}
        ./greyrpi
        hw.raspberry-pi-4
        ./iapetus
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };
  */
}
