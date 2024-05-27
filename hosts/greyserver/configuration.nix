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

    # Common and Nix Home Manager configurations
    ../../modules/common.nix
    ../../modules/nh.nix

    # Bootloader and SOPS configurations
    ../../modules/hardware/bootloader.nix
    ../../modules/sops.nix

    # System service configurations
    ../../modules/services/system/zram.nix
    ../../modules/services/system/ssh.nix
    ../../modules/services/nginx.nix
    # ../../modules/services/podman.nix
    ../../modules/services/cloudflared.nix
    ../../modules/services/vaultwarden.nix
    ../../modules/services/postgresql.nix
    # ../../modules/services/spacebar.nix
    ../../modules/services/adguard.nix
  ];

  # Network configurations
  networking.hostName = "greyserver"; # Set the hostname
  networking.networkmanager.enable = true; # Enable NetworkManager

  # Bootloader configurations
  boot.loader.systemd-boot.enable = true; # Enable systemd-boot
  boot.loader.efi.canTouchEfiVariables = true; # Allow bootloader to modify EFI variables

  # Hardware configurations
  hardware = {
    cpu.amd.updateMicrocode = true; # Enable AMD microcode updates
    enableRedistributableFirmware = true; # Enable redistributable firmware
  };

  # System state version
  system.stateVersion = "24.05"; # Set the system state version
}
