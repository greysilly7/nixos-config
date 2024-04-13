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
    gnupg = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable GnuPG.";
    };
  };

  config = lib.mkIf config.options.gnupg {
    programs.gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
  };
}
