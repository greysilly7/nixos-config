args@{
  config,
  pkgs,
  lib,
  flake,
  ...
}:
{
  imports = [
    ../../modules/base-server.nix
    ./disko
  ];

  boot = {
    supportedFilesystems = [ "zfs" ];
  };
  networking.hostId = "777c96a5";

  system.stateVersion = "25.11";
  power = {
    ups = {
      enable = true;
      users.greysilly7 = {
        passwordFile = config.sops.secrets."greysilly7/password".path;
        instcmds = [ "ALL" ];
        actions = [ "SET" ];
      };
      upsmon = {
        enable = true;
        monitor."hehe" = {
          passwordFile = config.sops.secrets."greysilly7/password".path;
          user = "greysilly7";
          powerValue = 2;
        };
      };
      ups."hehe" = {
        driver = "usbhid-ups";
        port = "auto";
      };
    };
  };

  services.udev.extraRules =
    let
      mkRule = as: lib.concatStringsSep ", " as;
      mkRules = rs: lib.concatStringsSep "\n" rs;
    in
    mkRules ([
      (mkRule [
        ''ACTION=="add|change"''
        ''SUBSYSTEM=="block"''
        ''KERNEL=="sd[a-z]"''
        ''ATTR{queue/rotational}=="1"''
        ''RUN+="${pkgs.hdparm}/bin/hdparm -B 90 -S 41 /dev/%k"''
      ])
    ]);

  services.thermald.enable = true;

  powerManagement = {
    enable = true;
    powertop.enable = true;
  };
}
