{
  pkgs,
  theme,
  ...
}: let
  rofi-configs = pkgs.symlinkJoin {
    name = "rofi-configs";
    paths = [
      (pkgs.writeTextDir "/etc/catppuccin-mocha.rasi" (builtins.readFile ./catppuccin-mocha.rasi))
      (pkgs.writeTextDir "/etc/rofi.rasi" (builtins.readFile ./config.rasi))
    ];
  };
in
  pkgs.symlinkJoin {
    name = "rofi-wrapped";
    paths = [
      pkgs.rofi-wayland
    ];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/rofi --add-flags "-config ${rofi-configs}/etc/rofi.rasi"
    '';
  }
