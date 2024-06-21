{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];
  services.fwupd.enable = true; # Enable fwupd service
}
