{pkgs, ...}: let
  wallpaper = ../../astronaut.jpg;
  config = pkgs.writeText "hyprpaper.conf" ''
    preload = ${wallpaper}
    wallpaper = , ${wallpaper}
  '';
in
  pkgs.symlinkJoin {
    name = "mako-wrapped";
    paths = [pkgs.hyprpaper];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/hyprpaper --add-flags "--config ${config}"
    '';
  }
