{ pkgs, ... }:
{
  # TODO: Setup Secureboot
  # module.hardware.lanzaboote.enable = true;

  module.desktop.random-apps.enable = true;

  module.shell.gnupg.enable = true;
  module.shell.git.enable = true;
  module.shell.vim.enable = true;

  module.server.iremia.enable = true;
}
