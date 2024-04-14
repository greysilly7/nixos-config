{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.module.shell.vim.enable = lib.mkEnableOption "Enable Gnupg";

  config = lib.mkIf config.module.shell.vim.enable {
    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
