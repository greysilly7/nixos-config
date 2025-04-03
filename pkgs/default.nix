{pkgs, ...}: let
  theme = import ../theme.nix;
  inherit (pkgs) callPackage;
in {
  hypr = callPackage ./wrapped/hypr {inherit theme;};
  waybar = callPackage ./wrapped/waybar {inherit theme;};
  mako = callPackage ./wrapped/mako {inherit theme;};
  rofi = callPackage ./wrapped/rofi {inherit theme;};
}
