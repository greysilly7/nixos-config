{
  inputs,
  den,
  lib,
  ...
}: {
  # Include xdg config by default in all hosts and hm-users
  den.ctx.host.includes = [den.aspects.xdg._.sys];
  den.ctx.hm-user.includes = [den.aspects.xdg._.user];

  den.aspects.xdg = {
    _.sys = den.lib.perHost {
      # Ensure portal definitions and DE provided configurations get linked
      nixos.environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    };

    _.user = den.lib.perUser {
      homeManager = {
        config,
        pkgs,
        lib,
        ...
      }: {
        xdg = {
          enable = lib.mkDefault true;
          mimeApps.enable = lib.mkDefault true;
          autostart.enable = lib.mkDefault true;

          userDirs = let
            docs = config.xdg.userDirs.documents;
          in {
            enable = lib.mkDefault config.xdg.enable;
            createDirectories = lib.mkDefault true;
            setSessionVariables = lib.mkDefault true;
            # Directories
            documents = lib.mkDefault "${config.home.homeDirectory}/Documents";
            desktop = lib.mkDefault "${docs}/Desktop";
            download = lib.mkDefault "${docs}/Downloads";
            pictures = lib.mkDefault "${docs}/Pictures";
            videos = lib.mkDefault "${docs}/Videos";
            music = lib.mkDefault "${docs}/Music";
            templates = lib.mkDefault "${docs}/Templates";
            publicShare = lib.mkDefault null;
          };

          dataFile."mimeapps.list" = lib.mkDefault {
            source = "${config.xdg.configFile."mimeapps.list".source}";
            force = true;
          };

          portal = {
            enable = lib.mkDefault config.xdg.enable;
            extraPortals = lib.mkDefault [
              pkgs.xdg-desktop-portal-gnome
              pkgs.xdg-desktop-portal-gtk
            ];
            config.common.default = lib.mkDefault ["gnome" "gtk"];
          };
        };

        home = {
          # Programs use XDG dirs if supported
          preferXdgDirectories = lib.mkDefault config.xdg.enable;
          # Checks $HOME for unwanted files and directories.
          packages = [pkgs.xdg-ninja];
        };
      };

      persistUser = {
        hmConfig,
        lib,
        ...
      }: {
        directories =
          lib.map (path: {
            directory = path;
            how = "symlink";
            createLinkTarget = true;
          }) [
            "${hmConfig.xdg.userDirs.documents}"
            "${hmConfig.xdg.userDirs.desktop}"
            "${hmConfig.xdg.userDirs.download}"
            "${hmConfig.xdg.userDirs.pictures}"
            "${hmConfig.xdg.userDirs.videos}"
            "${hmConfig.xdg.userDirs.music}"
            "${hmConfig.xdg.userDirs.templates}"
          ];

        files = [
          {
            file = "${hmConfig.xdg.dataHome}/recently-used.xbel";
            mode = "0600";
          }
        ];
      };

      persistUserTmp = {hmConfig, ...}: {
        ".local" = {}; # "~/.local"
        "${hmConfig.xdg.dataHome}" = {}; # "~/.local/share"
      };
    };
  };
}
