{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.shell.gnupg.enable = lib.mkEnableOption "Enable Gnupg";

  config = lib.mkIf config.shell.gnupg.enable {
    programs.gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
  };
}
