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
    ./tailscale.nix

    ../../modules/common.nix
    ../../modules/nh.nix

    ../../modules/hardware/bootloader.nix
    ../../modules/sops.nix

    ../../modules/services/zram.nix
    ../../modules/services/ssh.nix
    ../../modules/services/nginx.nix
    ../../modules/services/podman.nix
    ../../modules/services/cloudflared.nix
    ../../modules/services/vaultwarden.nix
    ../../modules/services/postgresql.nix
    # ../../modules/services/spacebar.nix
    ../../modules/services/adguard.nix
  ];

  networking.hostName = "greyserver";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  system.stateVersion = "24.05";
}
