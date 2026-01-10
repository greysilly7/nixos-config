{
  config,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./base.nix
  ];
  documentation.nixos.enable = false;
  documentation.enable = false;
  documentation.info.enable = false;
  documentation.man.enable = false;

  environment = {
    variables.BROWSER = "echo";
    stub-ld.enable = false;
  };

  time.timeZone = lib.mkDefault "UTC";
  systemd = {
    enableEmergencyMode = false;
    settings = {
      Manager = {
        RuntimeWatchdogSec = "20s";
        RebootWatchdogSec = "30s";
      };
    };

    sleep.extraConfig = ''
      AllowSuspend=no
      AllowHibernation=no
    '';
  };

  zramSwap.enable = true;

  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.network.wait-online.enable = false;
  systemd.services.systemd-networkd.stopIfChanged = false;
  systemd.services.systemd-resolved.stopIfChanged = false;

  networking = {
    hostName = lib.mkDefault "greysilly-nix-base-server";
    networkmanager.enable = false;
    wireless.enable = false;
    useNetworkd = true;
    firewall = {
      allowPing = true;
      logRefusedConnections = false;
      allowedTCPPorts = [ 22 ];
    };

    nameservers = [
      "1.1.1.1"
      "1.0.0.1"
      "8.8.8.8"
      "8.4.4.8"
    ];
  };

  services.pulseaudio.enable = false;
  fonts.fontconfig.enable = false;
  programs.command-not-found.enable = false;
  xdg.autostart.enable = false;
  xdg.icons.enable = false;
  xdg.menus.enable = false;
  xdg.mime.enable = false;
  xdg.sounds.enable = false;

  users.mutableUsers = false;
  services.resolved.llmnr = "false";

  # This shaves off half a gigabyte of disk space...
  hardware.enableAllFirmware = false;
  hardware.enableRedistributableFirmware = false;
  environment.ldso32 = null;
}
