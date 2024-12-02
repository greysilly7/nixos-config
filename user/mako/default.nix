{
  pkgs,
  theme,
  ...
}:
pkgs.symlinkJoin {
  name = "mako-wrapped";
  paths = [pkgs.mako];
  buildInputs = [pkgs.makeWrapper];
  postBuild = ''
    wrapProgram $out/bin/mako --add-flags "\
    --font 'Lexend 11' \
    --border-radius 8 \
    --padding 8 \
    --border-size 5 \
    --background-color '#${theme.base00}' \
    --border-color '#${theme.base0D}' \
    --text-color '#${theme.base05}' \
    --progress-color '#${theme.base02}' \
    --default-timeout 4000"
  '';
}
