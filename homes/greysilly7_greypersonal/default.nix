{inputs, ...}: {
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeManagerModules.catppuccin
    ./packages.nix
    # ./impermanence.nix
    ../shared/misc
    # ./rice
    ../shared/scripts
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home.stateVersion = "24.05";
}
