# Add your reusable NixOS modules to this directory, on their own file (https://nixos.wiki/wiki/Module).
# These should be stuff you would like to share with others, not your personal configurations.
{
  # List your module files here
  # my-module = import ./my-module.nix;
  kde = import ./desktop/kde.nix;
  gaming = import ./desktop/gaming/default.nix;
  steam = import ./desktop/gaming/steam.nix;

  battery = import ./hardware/battery.nix;
  bluetooth = import ./hardware/bluetooth.nix;
  intel = import ./hardware/intel.nix;
  lanzaboote = import ./hardware/lanzaboote.nix;
  pipewire = import ./hardware/pipewire.nix;

  git = import ./shell/git.nix;
  gnupg = import ./shell/gnupg.nix;
}
