{
  pkgs,
  theme,
  ...
}: let
  inherit (builtins) toString isBool;
  inherit (pkgs.lib) boolToString escape generators;

  toGtk3Ini = generators.toINI {
    mkKeyValue = key: value: let
      value' =
        if isBool value
        then boolToString value
        else toString value;
    in "${escape ["="] key}=${value'}";
  };

  catppuccin-gtk = pkgs.catppuccin-gtk.overrideAttrs {
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "gtk";
      rev = "v1.0.3";
      fetchSubmodules = true;
      hash = "sha256-q5/VcFsm3vNEw55zq/vcM11eo456SYE5TQA3g2VQjGc=";
    };

    postUnpack = "";
  };
in {
  homix = let
    css = import ./colors.nix {inherit theme;};
    gtkINI = {
      gtk-application-prefer-dark-theme = 1;
      gtk-font-name = "Lexend 11";
      gtk-icon-theme-name = "Papirus";
      gtk-theme-name = "catppuccin-mocha-mauve-compact";
      gtk-xft-antialias = 1;
      gtk-xft-hinting = 1;
      gtk-xft-hintstyle = "hintslight";
      gtk-xft-rgba = "rgb";
    };
  in {
    ".config/gtk-3.0/gtk.css".text = css;
    ".config/gtk-4.0/gtk.css".text = css;
    ".config/gtk-3.0/settings.ini".text = toGtk3Ini {
      Settings = gtkINI;
    };
    ".config/gtk-4.0/settings.ini".text = toGtk3Ini {
      Settings =
        gtkINI
        // {
          gtk-application-prefer-dark-theme = 1;
        };
    };
  };

  environment = {
    systemPackages = [
      catppuccin-gtk
    ];
    variables = {
      GTK_THEME = "catppuccin-mocha-mauve-compact";
    };
  };
}
