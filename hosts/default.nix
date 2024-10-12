{
  self,
  nixpkgs,
  ...
}: let
  inherit (self) inputs;

  # Core system modules
  core = ../system/core;
  bootloader = ../system/core/bootloader.nix;
  impermanence = ../system/core/impermanence.nix;

  # Server modules
  server = ../system/server;

  # Wayland modules
  wayland = ../system/wayland;

  # Gaming modules
  gaming = ../system/gaming;
  sunshine = ../system/gaming/sunshine.nix;

  # External modules
  sops-nix = inputs.sops-nix.nixosModules.sops;
  disko = inputs.disko.nixosModules.default;
  hmModule = inputs.home-manager.nixosModules.home-manager;

  # Shared Modules
  shared = [core sops-nix disko];

  # Home Manager configuration
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
  # My personal workstation/laptop
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
        {inherit home-manager;}
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
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # My personal server
  greyserver = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "greyserver";}
        ./greyserver
        hmModule
        bootloader
        server
        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # ISO installer
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

  # Future Raspberry Pi 4 system
  /*
  greyrpi = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    modules = [
      { networking.hostName = "greyrpi"; }
      ./greyrpi
      hw.raspberry-pi-4
      ./iapetus
      { inherit home-manager; }
    ] ++ shared;
    specialArgs = { inherit inputs; };
  };
  */
}
