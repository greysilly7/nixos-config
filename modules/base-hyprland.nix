{
  pkgs,
  flake,
  ...
}: {
  imports = [
    ./base.nix
    ./system/wayland.nix
  ];

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.systemPackages =
    builtins.attrValues flake.packages."${pkgs.system}"
    ++ [
      pkgs.yazi
    ];
}
