{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    ./disks
  ];

  boot = {
    initrd.systemd = {
      enable = true;
      tpm2.enable = true;
    };
    blacklistedKernelModules = ["k10temp"];
    extraModulePackages = [config.boot.kernelPackages.zenpower];
    kernelModules = ["zenpower"];
    kernelParams = ["amd_pstate=passive"];
    lanzaboote = {
      enable = lib.mkForce true;
    };
    loader = {
      systemd-boot = {
        enable = lib.mkForce false;
      };
    };
  };
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.tailscale0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.laptop.enable = true;

  facter.reportPath = ./facter.json;

  services.supergfxd.enable = true;
  services.asusd = {
    enable = true;
    enableUserService = true;
  };

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = [pkgs.rocmPackages.clr.icd pkgs.amdvlk];
    extraPackages32 = [pkgs.driversi686Linux.amdvlk];
  };
  services.xserver.videoDrivers = ["amdgpu"];
}
