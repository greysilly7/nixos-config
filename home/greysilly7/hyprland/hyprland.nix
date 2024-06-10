{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # swww
    hyprpaper
    inputs.hypr-contrib.packages.${system}.grimblast
    hyprpicker
    grim
    slurp
    wl-clip-persist
    wf-recorder
    glib
    wayland
    hyprpaper
    direnv
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = ["xdg-desktop-autostart.target"];
  wayland.windowManager.hyprland = {
    enable = true;
    xwayland = {
      enable = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
}
