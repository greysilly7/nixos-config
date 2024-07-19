{
  pkgs,
  ...
}: {
  imports = [./steam.nix];

  environment.systemPackages = with pkgs; [
    lutris
    heroic
    (prismlauncher.override {withWaylandGLFW = true;})
  ];

  # Gamemode
  programs.gamemode.enable = true;

  # Steam Controller support
  hardware.steam-hardware.enable = true;
  # Xbox controller
  hardware.xpadneo.enable = true;
}
