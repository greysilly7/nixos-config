{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.desktop.kde.enable = lib.mkEnableOption "Enable Intel Support";


  config = lib.mkIf config.kde {
    services.xserver.enable = true;

    services.xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      wayland.compositor = "kwin";
    };

    services.desktopManager.plasma6.enable = true;

    environment.plasma6.excludePackages = [
      pkgs.kdePackages.elisa # Default KDE video player, use VLC instead
    ];

    programs.partition-manager.enable = true;
    programs.kdeconnect.enable = true;
  };
}
