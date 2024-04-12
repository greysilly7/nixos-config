{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    kde = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable KDE.";
    };
  };

  config = {
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
