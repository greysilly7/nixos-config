{den, ...}: {
  den.aspects.messaging._.discord._.legcord._.enable = den.lib.perUser {
    homeManager = {
      pkgs,
      lib,
      ...
    }: {
      home.packages = [
        pkgs.legcord
      ];

      # Autostart
      xdg.configFile."autostart/legcord.desktop" = lib.mkDefault {
        text = ''
          [Desktop Entry]
          NotShowIn=niri
          Categories=Network;InstantMessaging;Chat
          Exec=legcord --start-minimized
          GenericName=Internet Messenger
          Icon=legcord
          Keywords=discord;legcord;electron;chat
          Name=Legcord
          StartupWMClass=Legcord
          Type=Application
          Version=1.5
        ''; 
      };

      services.arrpc = lib.mkDefault {
        enable = true;
        systemdTarget = "graphical-session.target";
      };
    };

    persistUser = {hmConfig, ...}: {
      directories = [
        {
          directory = "${hmConfig.xdg.configHome}/legcord";
          how = "symlink";
          mode = "0700";
          createLinkTarget = true;
        }
      ];
    };

    persistUserTmp = {hmConfig, ...}: {
      "${hmConfig.xdg.configHome}" = {}; # "~/.config"
      "${hmConfig.xdg.configHome}/legcord" = {};
      "${hmConfig.xdg.configHome}/legcord/Crashpad" = {mode = "0700";};
      # "${hmConfig.xdg.configHome}/legcord/sessionData" = { mode = "0700"; };
    };
  };
}
