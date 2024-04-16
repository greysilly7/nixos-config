# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules your own flake exports (from modules/nixos):
    # outputs.nixosModules.example

    # Or modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    ./users.nix
    ./firewall.nix
    ./i18.nix
    ./nixpkgconf.nix
    ./pkgs.nix

    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  boot.initrd.luks.devices."luks-66160d5a-eacb-472a-a782-401e1e126ed2".device = "/dev/disk/by-uuid/66160d5a-eacb-472a-a782-401e1e126ed2";
  boot.kernelPackages = pkgs.linuxKernel.packages.linux_zen;

  # Network Manager
  networking.networkmanager.enable = true;

  # Hostname
  networking.hostName = "greypersonal";

  hardware = {
    cpu.intel.updateMicrocode = true;
    enableRedistributableFirmware = true;
  };

  services.fwupd.enable = true;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
