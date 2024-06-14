# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = ["xhci_pci" "vmd" "ahci" "nvme"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-intel"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/318e2a6c-8670-444d-bc45-b47c5daa250d";
    fsType = "ext4";
    options = [
      "defaults"
      "noatime"
    ];
  };

  boot.initrd.luks.devices."luks-a5c9c229-75d2-46e8-b51f-5e8ededcd170".device = "/dev/disk/by-uuid/a5c9c229-75d2-46e8-b51f-5e8ededcd170";

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F22C-32E9";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}