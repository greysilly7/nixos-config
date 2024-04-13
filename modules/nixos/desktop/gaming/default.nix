{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.module.desktop.gaming.enable = lib.mkEnableOption "Enable Gaming Configs and Packages";

  config = lib.mkIf config.module.desktop.gaming.enable {
    environment.systemPackages = with pkgs; [
      # cockatrice
      lutris
      # melonDS
      (prismlauncher.override { withWaylandGLFW = true; })
      # r2modman
      # ryujinx
      # scarab
    ];

    # Steam controller support
    hardware.steam-hardware.enable = true;
    # Joycon and Pro Controller support
    services.joycond.enable = true;
  };
}
