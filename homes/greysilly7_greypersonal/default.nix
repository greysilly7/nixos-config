{inputs, ...}: {
  imports = [
    # inputs.impermanence.nixosModules.home-manager.impermanence
    inputs.nvchad4nix.homeManagerModule
    ./packages.nix
    ../shared/misc
    ../shared/scripts
  ];
  home.stateVersion = "24.05";
}
