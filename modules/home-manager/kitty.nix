{
  inputs,
  outputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  options.kitty.enable = lib.mkEnableOption "Enable kitty";

  config = lib.mkIf config.kitty.enable {
    programs.kitty = {
      enable = true;
      shellIntegration.enableBashIntegration = true;
      extraConfig = ''
        # Enable transparency
        background_opacity 0.8

        # Set font and size
        font_family Fira Code
        font_size 12.0

        # Enable ligatures
        symbol_map U + E100-U + E16F FiraCodeSymbols

        # Set colorscheme
        color0 #282a36
        color1 #ff5c57
        color2 #5af78e
        color3 #f3f99d
        color4 #57c7ff
        color5 #ff6ac1
        color6 #9aedfe
        color7 #f1f1f0
        color8 #686868
        color9 #ff5c57
        color10 #5af78e
        color11 #f3f99d
        color12 #57c7ff
        color13 #ff6ac1
        color14 #9aedfe
        color15 #eff0eb

        # Set cursor color
        cursor #97979b

        # Enable copy to clipboard
        map ctrl + shift + c copy_to_clipboard
        map ctrl + shift + v paste_from_clipboard
      '';
    };
  };
}
