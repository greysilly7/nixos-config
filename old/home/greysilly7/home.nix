{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./neovim.nix
    ./git.nix
    ./fish.nix
    ./bash.nix
    ./kitty.nix
    ./discord.nix
    ./bat.nix
    ./gtk.nix
    ./hyprland
    ./swaylock.nix
    ./waybar
    ./wofi.nix
    ./audacious/audacious.nix
    ./packages.nix
    ./scripts/scripts.nix
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
