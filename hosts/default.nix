{
  self,
  pkgs,
  ...
}: let
  inherit (self) inputs;
  core = ../system/core;
  bootloader = ../system/core/bootloader.nix;
  impermanence = ../system/core/impermanence.nix;
  # server = ../system/server;
  # wayland = ../system/wayland;
  hw = inputs.nixos-hardware.nixosModules;
  sops-nix = inputs.sops-nix.nixosModules.sops;
  disko = inputs.disko.nixosModules.default;
  hmModule = inputs.home-manager.nixosModules.home-manager;

  # Shared Modules
  shared = [core sops-nix disko];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit self;
    };
    users.greysilly7 = {
      imports = [../home];
    };
  };
in {
  # My personal laptop
  greypersonal = pkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules =
      [
        {networking.hostName = "greypersonal";}
        ./greypersonal
        hmModule
        bootloader
        impermanence

        {inherit home-manager;}
      ]
      ++ shared;
    specialArgs = {inherit inputs;};
  };

  # My Future Potential Raspberry PI 4 System
  greyrpi = pkgs.lib.nixosSystem {
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
}