{ pkgs, ... }:
{
  # hardware.battery.enable = true;
  module.hardware.bluetooth.enable = true;
  module.hardware.intel.enable = true;
  module.hardware.lanzaboote.enable = true;
  module.hardware.pipewire.enable = true;

  module.desktop.kde.enable = true;
  module.desktop.gaming.enable = true;
  module.desktop.gaming.steam.enable = true;
  module.desktop.random-apps.enable = true;

  module.shell.gnupg.enable = true;
  module.shell.git.enable = true;
  module.shell.vim.enable = true;
}
