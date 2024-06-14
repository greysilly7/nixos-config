{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./impermanence.nix
  ];
  home.stateVersion = "24.05";
}
