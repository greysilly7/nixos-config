{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.shell.git.enable = lib.mkEnableOption "Enable Git";

  config = lib.mkIf config.shell.git.enable { environment.systemPackages = [ pkgs.git ]; };
}
