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
    ../../system
  ];

  boot.loader.grub = {
    enable = true;
    device = "/dev/vda";
  };

  services.openssh.enable = true;

  networking = {
    hostName = lib.mkForce "fastbar";
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

  documentation.nixos.enable = false;
  documentation.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = false;

  environment = {
    variables.BROWSER = "echo";
    stub-ld.enable = false;
  };

  zramSwap.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  systemd.services.systemd-networkd.stopIfChanged = false;
  systemd.services.systemd-resolved.stopIfChanged = false;

  services.pulseaudio.enable = false;
  fonts.fontconfig.enable = false;
  programs.command-not-found.enable = false;
  xdg.autostart.enable = false;
  xdg.icons.enable = false;
  xdg.menus.enable = false;
  xdg.mime.enable = false;
  xdg.sounds.enable = false;

  hardware.enableAllFirmware = false;
  hardware.enableRedistributableFirmware = false;
  environment.ldso32 = null;

  time.timeZone = "UTC";
  system.stateVersion = "25.11";
}
