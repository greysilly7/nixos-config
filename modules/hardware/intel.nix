{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    services.xserver.videoDrivers = ["intel"];

    boot.initrd.kernelModules = ["i915"];

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [
        libva
        intel-vaapi-driver
        libvdpau-va-gl
        intel-media-driver
      ];
    };
  };
}
