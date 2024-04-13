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
    gaming = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gaming.";
    };
  };

  config = lib.mkIf config.gaming {
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
