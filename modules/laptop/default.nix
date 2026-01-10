{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  MHz = x: x * 1000;

  cfg = config.hardware.laptop;
in
{
  options = {
    hardware.laptop.enable = mkEnableOption "Enable laptop specific configuration";
  };

  config = mkIf cfg.enable {
    powerManagement.enable = true;
    services = {
      auto-auto-cpufreq.enable = true;
    };
    # https://github.com/NixOS/nixpkgs/issues/114222
    systemd.user.services.telephony_client.enable = false;

    # https://github.com/NixOS/nixpkgs/issues/211345#issuecomment-1397825573
    systemd.tmpfiles.rules = map (e: "w /sys/bus/${e}/power/control - - - - auto") [
      "pci/devices/0000:00:01.0" # Renoir PCIe Dummy Host Bridge
      "pci/devices/0000:00:02.0" # Renoir PCIe Dummy Host Bridge
      "pci/devices/0000:00:14.0" # FCH SMBus Controller
      "pci/devices/0000:00:14.3" # FCH LPC bridge
      "pci/devices/0000:04:00.0" # FCH SATA Controller [AHCI mode]
      "pci/devices/0000:04:00.1/ata1" # FCH SATA Controller, port 1
      "pci/devices/0000:04:00.1/ata2" # FCH SATA Controller, port 2
      "usb/devices/1-3" # USB camera
    ];
  };
}
