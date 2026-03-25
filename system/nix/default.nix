{ lib, pkgs, ... }:
{
  imports = [
    ./extra-substituters.nix
  ];
  nix = {
    package = pkgs.lixPackageSets.stable.lix;
    channel.enable = false;
    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "@wheel"
        "root"
      ];
      log-lines = 25;
      max-free = lib.mkDefault (3000 * 1024 * 1024);
      min-free = lib.mkDefault (512 * 1024 * 1024);
      builders-use-substitutes = true;
      connect-timeout = 5;
      fallback = true;
    };
  };
  nixpkgs.config.allowUnfree = true;
}
