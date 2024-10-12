{
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.lanzaboote.nixosModules.lanzaboote];

  environment.systemPackages = [
    # For debugging and troubleshooting Secure Boot.
    pkgs.sbctl
  ];

  boot = {
    tmp = {
      cleanOnBoot = true;
      useTmpfs = false;
    };

    # Kernel parameters and boot settings
    consoleLogLevel = lib.mkDefault 0; # Set console log level to 0
    initrd.verbose = false; # Disable verbose output for initrd
    kernelPackages = lib.mkDefault pkgs.linuxPackages_latest; # Use the latest Linux kernel packages

    bootspec.enable = lib.mkDefault true; # Enable bootspec
    loader = {
      systemd-boot.enable = lib.mkDefault true; # Enable systemd-boot
      timeout = 0; # Set boot menu timeout to 0
    };
    loader.efi.canTouchEfiVariables = true; # Allow touching EFI variables
  };

  boot.lanzaboote = {
    enable = lib.mkDefault false; # Disable lanzaboote by default
    pkiBundle = "/etc/secureboot"; # Path to PKI bundle for secure boot
  };
}
