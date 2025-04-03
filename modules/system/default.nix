{...}: {
  imports = [
    ./bootloader.nix
    ./fonts.nix
    ./networking.nix
    ./nix-settings.nix
    ./secrets.nix
    ./audio.nix
  ];
}
