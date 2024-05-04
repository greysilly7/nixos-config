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
    ./secureboot.nix
    ./networking.nix

    ../../modules/desktop/kde.nix
    ../../modules/desktop/gaming
    ../../modules/desktop/gaming/steam.nix

    ../../modules/hardware/intel.nix
    ../../modules/hardware/pipewire.nix
    ../../modules/hardware/power.nix
    ../../modules/hardware/bluetooth.nix

    ../../modules/services/zram.nix
    ../../modules/services/ssh.nix
  ];

  networking.hostName = "greypersonal";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
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
