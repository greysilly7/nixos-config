{
  pkgs,
  theme,
}: rec {
  packages = let
    inherit (pkgs) callPackage;
  in {
    zsh = callPackage ./wrapped/zsh {};
    hypr = callPackage ./wrapped/hypr {inherit theme;};
    waybar = callPackage ./wrapped/waybar {inherit theme;};
    mako = callPackage ./wrapped/mako {inherit theme;};
    anyrun = callPackage ./wrapped/anyrun {inherit theme;};
    misc-scripts = callPackage ./misc-scripts {};
  };

  shell = pkgs.mkShell {
    name = "greysilly7-devshell";
    buildInputs = builtins.attrValues packages;
  };

  module = {
    config = {
      environment.systemPackages = builtins.attrValues packages;
      programs.hyprland.enable = true;
      programs.direnv.enable = true;
      services.flatpak.enable = true;

      programs.nix-ld.enable = true;
      programs.nix-ld.libraries = with pkgs; [
        xorg.libX11
        xorg.libXcursor
        xorg.libxcb
        xorg.libXi
        libxkbcommon
        libGL
        wayland
      ];
    };
    imports = [
      ./packages.nix
      ./git
      ./gtk
      ./gaming
      ./spicetify
      ./kitty
    ];
  };
}
