{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  networking.wireless.enable = true;
  networking.wireless.networks = {
    GouldFamily = {
      psk = "93fc479e5f51d50bd94542d95c3d5e4fab39ee77239946cdbc0c0158d8976d73";
    };
  };
}
