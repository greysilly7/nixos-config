{
  config,
  lib,
  pkgs,
  inputs,
  chaotic,
  sops,
  ...
}: {
  # Import hardware configurations
  imports = [
    # Local hardware configurations
    ./hardware-configuration.nix
    ./tailscale.nix
    ./i18n.nix

    # Common and Nix Home Manager configurations
    ../../modules/common.nix
    ../../modules/nh.nix

    # Desktop and gaming configurations
    ../../modules/desktop
    ../../modules/desktop/gaming
    ../../modules/desktop/gaming/steam.nix

    # Hardware configurations
    ../../modules/hardware/bootloader.nix
    ../../modules/hardware/intel.nix
    ../../modules/hardware/pipewire.nix
    ../../modules/hardware/power.nix
    ../../modules/hardware/bluetooth.nix

    # SOPS configurations
    ../../modules/sops.nix

    # System service configurations
    ../../modules/services/system/zram.nix
    ../../modules/services/system/ssh.nix
    ../../modules/services/system/printing.nix
    ../../modules/services/system/encrypted_dns.nix
  ];

  # Kernel configurations
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen; # Use the Zen kernel

  # Network configurations
  networking.hostName = "greypersonal"; # Set the hostname
  networking.networkmanager.enable = true; # Enable NetworkManager
  environment.systemPackages = with pkgs; [
    networkmanagerapplet # Add NetworkManager applet to system packages
  ];

  # Bootloader configurations
  boot.loader.systemd-boot.enable = true; # Enable systemd-boot
  boot.loader.efi.canTouchEfiVariables = true; # Allow bootloader to modify EFI variables

  # Hardware configurations
  hardware = {
    cpu.intel.updateMicrocode = true; # Enable Intel microcode updates
    enableRedistributableFirmware = true; # Enable redistributable firmware
  };

  # Cache configurations
  chaotic.nyx.cache.enable = true; # Enable NYX cache

  # System state version
  system.stateVersion = "24.05"; # Set the system state version
}
