{
  pkgs,
  theme,
  ...
}: let
  hyprlockConfig = pkgs.writeText "hyprlock.conf" ''
    # BACKGROUND
    background {
      monitor =
      path = ${../../astronaut.jpg}
      blur_passes = 1
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }

    # GENERAL
    general {
      hide_cursor = true
      no_fade_in = false
      grace = 0
      disable_loading_bar = false
    }

    # Time
    label {
      monitor =
      text = cmd[update:1000] echo "$(date +"%k:%M")"
      color = rgba(${theme.base05}, .9)
      font_size = 111
      font_family = JetBrainsMono NF Bold
      position = 0, 270
      halign = center
      valign = center
    }

    # Day
    label {
      monitor =
      text = cmd[update:1000] echo "- $(date +"%A, %B %d") -"
      color = rgba(${theme.base05}, .9)
      font_size = 20
      font_family = CaskaydiaCove Nerd Font
      position = 0, 160
      halign = center
      valign = center
    }
  '';
in
  pkgs.symlinkJoin {
    name = "hyprlock-wrapped";
    paths = [pkgs.hyprlock];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/hyprlock --add-flags "-c ${hyprlockConfig}"
    '';
  }
