{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.hardware.bluetooth.enable = lib.mkEnableOption "Enable Bluetooth";


  config = lib.mkIf config.bluetooth {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
