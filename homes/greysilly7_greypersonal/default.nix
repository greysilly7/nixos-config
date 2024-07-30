{inputs, ...}: {
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeManagerModules.catppuccin
    ./packages.nix
    # ./impermanence.nix
    ./misc
    # ./rice
    ./scripts
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home.stateVersion = "24.05";
}
