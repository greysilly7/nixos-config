{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  config = {
    hardware.bluetooth.enable = true;
  };
}
