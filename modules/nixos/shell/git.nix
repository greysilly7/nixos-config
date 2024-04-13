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
    git = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable Git.";
    };
  };

  config = lib.mkIf config.git { environment.systemPackages = [ pkgs.git ]; };
}
