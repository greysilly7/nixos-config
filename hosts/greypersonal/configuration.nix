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
    ../../modules/hardware/secureboot.nix
    ./i18n.nix
    ./tailscale.nix
    ../../modules/sops.nix

    ../../modules/common.nix

    ../../modules/desktop/kde.nix
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

  # WE want NYX Cache
  chaotic.nyx.cache.enable = true;

  # Fomatting
  environment.systemPackages = with pkgs; [inputs.alejandra.defaultPackage.${system}];

  system.stateVersion = "24.05";
}
