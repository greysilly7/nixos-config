{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./neovim.nix
    ./git.nix
    ./fish.nix
    ./bash.nix
    ./kitty.nix
    ./bat.nix
    ./gtk.nix
    ./hyperland
    ./swaylock.nix
    ./waybar
    ./wofi.nix
    ./audacious/audacious.nix
    ./packages.nix
    ./scripts/scripts.nix
  ];

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-curses;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
