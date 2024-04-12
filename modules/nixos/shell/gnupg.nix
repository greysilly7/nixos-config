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

  config = {
    programs.gnupg.agent = {
      enable = true;
      # enableSSHSupport = true;
    };
  };
}
