{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ./spacebar.nix
    ../../system/users
    ../../system/net
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  services.openssh.enable = true;

  networking = {
    hostname = lib.mkForce "fastbar";
    firewall = {
      allowedTCPPorts = [
        22
        3001
        3002
        3003
      ];
      allowedUDPPorts = [
        3001
        3002
        3003
      ];
    };
  };
  time.timeZone = "UTC";
  system.stateVersion = "25.11";
}
