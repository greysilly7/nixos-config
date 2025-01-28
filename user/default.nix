{
  pkgs,
  theme,
  ...
}: rec {
  packages = let
    inherit (pkgs) callPackage;
  in {
    zsh = callPackage ./wrapped/zsh {};
    hypr = callPackage ./wrapped/hypr {inherit theme;};
    waybar = callPackage ./wrapped/waybar {inherit theme;};
    mako = callPackage ./wrapped/mako {inherit theme;};
    anyrun = callPackage ./wrapped/anyrun {inherit theme;};
  };

  shell = pkgs.mkShell {
    name = "greysilly7-devshell";
    buildInputs = builtins.attrValues packages;
  };

  module = {
    config = {
      environment.systemPackages = builtins.attrValues packages;
      programs.hyprland = {
        enable = true;
        withUWSM = true;
      };
      programs.direnv = {
        enable = true;
        enableFishIntergration = true;
      };
      services.flatpak.enable = true;

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
    };
    imports = [
      ./packages.nix
      ./git
      ./gtk
      ./gaming
      ./spicetify
      ./kitty
      ./fish
    ];
  };
}
