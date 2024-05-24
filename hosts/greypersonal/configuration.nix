{
  config,
  lib,
  pkgs,
  inputs,
  chaotic,
  sops,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/hardware/bootloader.nix
    ./i18n.nix
    ./tailscale.nix
    ../../modules/sops.nix

    ../../modules/common.nix
    ../../modules/nh.nix

    ../../modules/desktop
    ../../modules/desktop/gaming
    ../../modules/desktop/gaming/steam.nix

    ../../modules/hardware/intel.nix
    ../../modules/hardware/pipewire.nix
    ../../modules/hardware/power.nix
    ../../modules/hardware/bluetooth.nix

    ../../modules/services/zram.nix
    ../../modules/services/ssh.nix
    ../../modules/services/printing.nix
  ];
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  networking.hostName = "greypersonal";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  # Enable network manager
  networking.networkmanager.enable = true;
  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  # WE want NYX Cache
  chaotic.nyx.cache.enable = true;

  system.stateVersion = "24.05";
}
