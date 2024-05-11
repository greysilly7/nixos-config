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
    ../../modules/common.nix
    # ./secureboot.nix
    ./sops.nix

    ../../modules/hardware/pipewire.nix
    ../../modules/hardware/power.nix

    ../../modules/services/zram.nix
    ../../modules/services/ssh.nix
    # ../../modules/services/nginx.nix
    ../../modules/services/podman.nix
    # ../../modules/services/cloudflared.nix
  ];

  networking.hostName = "greyserver";
  networking.networkmanager.enable = true;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    cpu.amd.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  environment.systemPackages = with pkgs; [inputs.alejandra.defaultPackage.${system}];

  # Set your time zone.
  time.timeZone = "America/Detroit";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.stateVersion = "24.05";
}
