{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      lutris
      (prismlauncher.override {withWaylandGLFW = true;})
    ];

    # Steam controller support
    hardware.steam-hardware.enable = true;
    # Joycon and Pro Controller support
    services.joycond.enable = true;
  };
}
