{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.module.hardware.bluetooth.enable = lib.mkEnableOption "Enable Bluetooth";

  config = lib.mkIf config.module.hardware.bluetooth.enable {
    hardware.bluetooth.enable = true;
    # services.blueman.enable = true;
  };
}
