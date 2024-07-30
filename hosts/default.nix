{
  self,
  nixpkgs,
  ...
}: let
  inherit (self) inputs;
  core = ../system/core;
  bootloader = ../system/core/bootloader.nix;
  # impermanence = ../system/core/impermanence.nix;
  server = ../system/server;
  wayland = ../system/wayland;
  gaming = ../system/gaming;
  sunshine = ../system/gaming/sunshine.nix;
  chaotic = inputs.chaotic.nixosModules.default;
  sops-nix = inputs.sops-nix.nixosModules.sops;
  disko = inputs.disko.nixosModules.default;
  hmModule = inputs.home-manager.nixosModules.home-manager;

  # Shared Modules
  shared = [core sops-nix disko chaotic];

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
  # My personal laptop
  greypersonal = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {
          networking = {
            hostName = "greypersonal";
            hostId = "5a8a3fd9";
          };
        }
        ./greypersonal
        hmModule
        bootloader
        # impermanence
        wayland
        gaming

        {
          home-manager.users.greysilly7 = {
            imports = ["../homes/greysilly7@greypersonal"];
          };
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
        bootloader
        server
        wayland
        sunshine
        gaming
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
