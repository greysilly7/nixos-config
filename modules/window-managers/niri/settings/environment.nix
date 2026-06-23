{
  inputs,
  ...
}:
{
  den.aspects.niri._.settings._.environment = _: {
    homeManager =
      { pkgs, lib, ... }:
      lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        programs.niri.settings.environment = inputs.self.lib.applyDefaults {
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          QT_QPA_PLATFORMTHEME = "qt5ct";
          QT_QPA_PLATFORM = "wayland";
          GDK_BACKEND = "wayland,x11,*";
          XDG_CURRENT_DESKTOP = "niri";
          XDG_SESSION_TYPE = "wayland";
          XDG_SESSION_DESKTOP = "niri";
          NIXOS_OZONE_WL = "1";
        };
      };
  };
}
