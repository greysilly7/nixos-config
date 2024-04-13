{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.module.shell.gnupg.enable = lib.mkEnableOption "Enable Gnupg";

  config = lib.mkIf config.module.shell.gnupg.enable {
    programs.gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
  };
}
