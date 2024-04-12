{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options = {
    bluetooth = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Bluetooth.";
    };
  };

  config = {
    hardware.bluetooth.enable = true;
    services.blueman.enable = true;
  };
}
