{
  chaotic,
  pkgs,
  ...
}: {
  imports = [./steam.nix];

  environment.systemPackages = with pkgs; [
    lutris
    (prismlauncher.override {withWaylandGLFW = true;})
  ];

  # Gamemode
  programs.gamemode.enable = true;

  # Steam ontroller support
  hardware.steam-hardware.enable = true;
  # Xbox controller
  hardware.xpadneo.enable = true;
  # Joycon and Pro Controller support
  services.joycond.enable = true;
}
