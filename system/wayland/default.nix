{
  pkgs,
  inputs,
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
          command = "uwsm start ${flake.packages.${pkgs.system}.hypr}/bin/Hyprland";
          user = "greysilly7";
        };
        default_session = initial_session;
        terminal.vt = 1;
      };
    };
    gnome.glib-networking.enable = true;
    logind = {
      lidSwitch = "suspend";
      lidSwitchExternalPower = "suspend";
      extraConfig = ''
        # HandlePowerKey=suspend
        HibernateDelaySec=3600
      '';
    };
  };

  programs.hyprland = {
    enable = true;
    withUWSM = true;
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

  homix = {
    ".config/uwsm/env-hyprland".text = ''
      export NIXOS_OZONE_WL="1"
      export __GL_GSYNC_ALLOWED="0"
      export __GL_VRR_ALLOWED="0"
      export _JAVA_AWT_WM_NONEREPARENTING="1"
      # export SSH_AUTH_SOCK="/run/user/1000/keyring/ssh"
      export DISABLE_QT5_COMPAT="0"
      export GDK_BACKEND="wayland"
      export ANKI_WAYLAND="1"
      export DIRENV_LOG_FORMAT=""
      export WLR_DRM_NO_ATOMIC="1"
      export QT_AUTO_SCREEN_SCALE_FACTOR="1"
      export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"
      export QT_QPA_PLATFORM="xcb"
      export QT_QPA_PLATFORMTHEME="qt5ct"
      export QT_STYLE_OVERRIDE="kvantum"
      export MOZ_ENABLE_WAYLAND="1"
      export WLR_BACKEND="vulkan"
      export WLR_RENDERER="vulkan"
      export WLR_NO_HARDWARE_CURSORS="1"
      export AQ_DRM_DEVICES="/dev/dri/card0:/dev/dri/card1"
      export XDG_SESSION_TYPE="wayland"
      export SDL_VIDEODRIVER="wayland"
      export CLUTTER_BACKEND="wayland"
      # export GTK_THEME="Gruvbox-Green-Dark"
      export XCURSOR_THEME="default" # Use the default Hyprland cursor theme
      export XCURSOR_SIZE="24" # Set the cursor size
    '';
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    _JAVA_AWT_WM_NONEREPARENTING = "1";
    # SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
    DISABLE_QT5_COMPAT = "0";
    GDK_BACKEND = "wayland";
    ANKI_WAYLAND = "1";
    DIRENV_LOG_FORMAT = "";
    WLR_DRM_NO_ATOMIC = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_QPA_PLATFORM = "xcb";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    MOZ_ENABLE_WAYLAND = "1";
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    AQ_DRM_DEVICES = "/dev/dri/card0:/dev/dri/card1";
    XDG_SESSION_TYPE = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    # GTK_THEME = "Gruvbox-Green-Dark";
    XCURSOR_THEME = "default"; # Use the default Hyprland cursor theme
    XCURSOR_SIZE = "24"; # Set the cursor size
  };
}
