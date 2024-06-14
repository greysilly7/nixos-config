{
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.hyprland.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = lib.mkForce true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
  };
}
