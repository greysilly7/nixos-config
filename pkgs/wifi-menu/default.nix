{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "wifi-menu";
  text = builtins.readFile ./wifi-menu.sh;
}