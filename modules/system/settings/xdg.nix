{ den, ... }:
{
  # Include xdg config by default in all hosts and hm-users
  den.schema.host.includes = [ den.aspects.xdg._.sys ];
  den.schema.hm-user.includes = [ den.aspects.xdg._.user ];

  den.aspects.xdg = {
    _.sys = _: {
      # The nixos class automatically isolates these paths to your Linux machines
      nixos.environment.pathsToLink = [
        "/share/xdg-desktop-portal"
        "/share/applications"
      ];
    };

    _.user = _: {
      homeManager =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        let
          inherit (pkgs.stdenv.hostPlatform) isLinux;
        in
        {
          xdg = {
            # Base XDG config (~/.config, ~/.local/share) is great for macOS too
            enable = lib.mkDefault true;

            # --- Linux Desktop Specifics ---
            mimeApps.enable = lib.mkIf isLinux (lib.mkDefault true);
            autostart.enable = lib.mkIf isLinux (lib.mkDefault true);

            userDirs = lib.mkIf isLinux {
              enable = lib.mkDefault config.xdg.enable;
              createDirectories = lib.mkDefault true;
              setSessionVariables = lib.mkDefault true;

              documents = lib.mkDefault "${config.home.homeDirectory}/Documents";
              desktop = lib.mkDefault "${config.xdg.userDirs.documents}/Desktop";
              download = lib.mkDefault "${config.xdg.userDirs.documents}/Downloads";
              pictures = lib.mkDefault "${config.xdg.userDirs.documents}/Pictures";
              videos = lib.mkDefault "${config.xdg.userDirs.documents}/Videos";
              music = lib.mkDefault "${config.xdg.userDirs.documents}/Music";
              templates = lib.mkDefault "${config.xdg.userDirs.documents}/Templates";
              publicShare = lib.mkDefault null;
            };

            dataFile."mimeapps.list" = lib.mkIf isLinux (
              lib.mkDefault {
                inherit (config.xdg.configFile."mimeapps.list") source;
                force = true;
              }
            );

            portal = lib.mkIf isLinux {
              enable = lib.mkDefault config.xdg.enable;
              extraPortals = lib.mkDefault [
                pkgs.xdg-desktop-portal-gnome
                pkgs.xdg-desktop-portal-gtk
              ];
              config.common.default = lib.mkDefault [
                "gnome"
                "gtk"
              ];
            };
          };

          home = {
            # Programs use XDG dirs if supported (Works safely on macOS)
            preferXdgDirectories = lib.mkDefault config.xdg.enable;
            # Checks $HOME for unwanted files and directories.
            packages = [ pkgs.xdg-ninja ];
          };
        };

      persistUser =
        {
          hmConfig,
          lib,
          pkgs,
          ...
        }:
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          directories =
            lib.map
              (path: {
                directory = path;
                how = "symlink";
                createLinkTarget = true;
              })
              [
                hmConfig.xdg.userDirs.documents
                hmConfig.xdg.userDirs.desktop
                hmConfig.xdg.userDirs.download
                hmConfig.xdg.userDirs.pictures
                hmConfig.xdg.userDirs.videos
                hmConfig.xdg.userDirs.music
                hmConfig.xdg.userDirs.templates
              ];

          files = [
            {
              file = "${hmConfig.xdg.dataHome}/recently-used.xbel";
              mode = "0600";
            }
          ];
        };

      persistUserTmp =
        {
          hmConfig,
          lib,
          pkgs,
          ...
        }:
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          ".local" = { }; # "~/.local"
          "${hmConfig.xdg.dataHome}" = { }; # "~/.local/share"
        };
    };
  };
}
