{
  pkgs,
  theme,
  ...
}: rec {
  packages = let
    inherit (pkgs) callPackage;
  in {
    cli =
      {
        zsh = callPackage ./zsh {};
      }
      // (import ./misc-scripts {inherit pkgs;});
    desktop = {
      hyperland = callPackage ./hyprland {inherit theme;};
      hyprlock = callPackage ./hyprlock {inherit theme;};
      hyprpaper = callPackage ./hyprpaper {inherit theme;};
      waybar = callPackage ./waybar {inherit theme;};
      rofi = callPackage ./rofi {inherit theme;};
      mako = callPackage ./mako {inherit theme;};
    };
  };

  shell = pkgs.mkShell {
    name = "greysilly7-devshell";
    buildInputs = builtins.attrValues packages.cli;
  };

  module = {
    config = {
      environment.systemPackages = builtins.concatLists (map (x: builtins.attrValues x) (builtins.attrValues packages));
    };
    imports = [
      ./packages.nix
      ./git
      ./gtk
      ./gaming
    ];
  };
}
