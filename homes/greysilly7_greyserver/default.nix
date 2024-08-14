{inputs, ...}: {
  imports = [
    ../shared/misc/bash.nix
    ../shared/misc/bat.nix
    ../shared/misc/fish.nix
    ../shared/misc/git.nix

    ../shared/scripts

    ./packages.nix
  ];

  home.stateVersion = "24.05";
}
