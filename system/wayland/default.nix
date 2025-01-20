{
  pkgs,
  lib,
  flake,
  ...
}: {
  systemd.services = {
    seatd = {
      enable = true;
      description = "Seat management daemon";
      script = "${pkgs.seatd}/bin/seatd -g wheel";
      serviceConfig = {
        Type = "simple";
        Restart = "always";
        RestartSec = "1";
      };
      wantedBy = ["multi-user.target"];
    };
  };

  services = {
    greetd = {
      enable = true;
      settings = rec {
        initial_session = {
          command = "${lib.getExe pkgs.uwsm} start -S -F ${flake.packages.${pkgs.system}.hypr}/bin/Hyprland";
          user = "greysilly7";
        };
        default_session = initial_session;
        terminal.vt = 1;
      };
    };
    gnome.glib-networking.enable = true;
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "hibernate";
      extraConfig = ''
        HandlePowerKey=poweroff
        HibernateDelaySec=600
        SuspendState=mem
      '';
    };
  };

  xdg.portal = {
    enable = true;
    config.common.default = "*";
    wlr.enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
