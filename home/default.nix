{inputs, ...}: {
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
    ./packages.nix
    ./impermanence.nix
    ./misc
    ./rice
    ./scripts
  ];
  home.stateVersion = "24.05";
}
