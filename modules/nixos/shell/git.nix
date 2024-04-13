{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.module.shell.git.enable = lib.mkEnableOption "Enable Git";

  config = lib.mkIf config.module.shell.git.enable { environment.systemPackages = [ pkgs.git ]; };
}
