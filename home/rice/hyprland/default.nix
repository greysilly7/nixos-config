{...}: {
  imports = [
    ./hyprland.nix
    ./config.nix
    ./variables.nix
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
    # inputs.hyprland.homeManagerModules.default
  ];
}
