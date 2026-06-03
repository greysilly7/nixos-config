_:
{
  den.aspects.messaging._.discord._.equibop._.enable =
    _:
    {
      homeManager =
        {
          pkgs,
          lib,
          ...
        }:
        {
          home.packages = [
            (pkgs.callPackage ../../../../../packages/equibop/default.nix { })
          ];

          # Autostart
          xdg.configFile."autostart/equibop.desktop" = lib.mkIf pkgs.stdenv.hostPlatform.isLinux (lib.mkDefault {
            text = ''
              [Desktop Entry]
              NotShowIn=niri
              Categories=Network;InstantMessaging;Chat
              Exec=equibop --start-minimized
              GenericName=Internet Messenger
              Icon=equibop
              Keywords=discord;equibop;electron;chat
              Name=Equibop
              StartupWMClass=Equibop
              Type=Application
              Version=1.5
            '';
          });
        };

      persistUser =
        { hmConfig, ... }:
        {
          directories = [
            {
              directory = "${hmConfig.xdg.configHome}/equibop";
              how = "symlink";
              mode = "0700";
              createLinkTarget = true;
            }
          ];
        };

      persistUserTmp =
        { hmConfig, ... }:
        {
          "${hmConfig.xdg.configHome}" = { }; # "~/.config"
          "${hmConfig.xdg.configHome}/equibop" = { };
          "${hmConfig.xdg.configHome}/equibop/Crashpad" = {
            mode = "0700";
          };
          # "${hmConfig.xdg.configHome}/equibop/sessionData" = { mode = "0700"; };
        };
    };
}
