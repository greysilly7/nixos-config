{
  inputs,
  pkgs,
  config,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  home-manager.users.greysilly7 = {
    imports = [
      ../../homes/greysilly7_greyserver
    ];
  };

  services.fwupd.enable = true; # Enable fwupd service
}
