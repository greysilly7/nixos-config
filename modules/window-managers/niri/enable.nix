# Niri window manager
# https://github.com/niri-wm/niri
{
  inputs,
  ...
}:
{
  den.aspects.niri._.enable = _: {
    nixos =
      {
        pkgs,
        lib,
        ...
      }:
      {
        imports = [ inputs.niri.nixosModules.niri ];

        programs.niri = {
          enable = lib.mkDefault true;
          package = lib.mkDefault pkgs.niri;
        };
        systemd.user.services.niri-flake-polkit.enable = lib.mkDefault false;
      };
  };
}
