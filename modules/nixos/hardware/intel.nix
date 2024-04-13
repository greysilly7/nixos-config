{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.hardware.intel.enable = lib.mkEnableOption "Enable Intel Support";

  config = lib.mkIf config.intel {
    services.xserver.videoDrivers = [ "intel" ];

    environment.variables.LIBVA_DRIVER_NAME = "iHD";

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        onevpl-intel-gpu
        intel-compute-runtime
        intel-ocl
      ];
    };
  };
}
