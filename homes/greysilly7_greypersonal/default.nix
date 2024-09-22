{inputs, ...}: {
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.catppuccin.homeManagerModules.catppuccin
    inputs.nvchad4nix.homeManagerModule
    ./packages.nix
    ../shared/misc
    ../shared/scripts
  ];

  catppuccin = {
    enable = true;
    flavor = "mocha";
  };

  home.stateVersion = "24.05";
}
