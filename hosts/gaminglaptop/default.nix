{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./disks
    ../../modules/base-hyprland.nix
  ];
  facter.reportPath = ./factor.json;
  boot = {
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.systemd-boot.enable = false;
  };

  services = {
    asusd = {
      enable = true;
      enableUserService = true;
    };
    supergfxd.enable = true;
  };
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = [pkgs.rocmPackages.clr.icd pkgs.amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.laptop.enable = true;
}
