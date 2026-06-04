{ den, ... }:
{
  den.aspects.spotify = {
    includes = [
      den.aspects.spotify._.enable
    ];

    _.enable = _: {
      homeManager =
        {
          pkgs,
          lib,
          ...
        }:
        {
          home.packages = [
            pkgs.spotify
          ] ++ lib.optionals pkgs.stdenv.hostPlatform.isLinux [
            pkgs.spotify-tray
          ];

          services.playerctld = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
            enable = true;
          };

          xdg = lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
            mimeApps = {
              defaultApplications = lib.mkBefore (
                let
                  application = "spotify.desktop";
                  mimeTypes = [
                    "x-scheme-handler/spotify"
                  ];
                in
                lib.genAttrs mimeTypes (_mimetype: application)
              );
            };
          };
        };

      persistUser =
        { hmConfig, ... }:
        {
          directories = [
            {
              directory = "${hmConfig.xdg.configHome}/spotify";
              how = "symlink";
              mode = "0755";
              createLinkTarget = true;
            }
            {
              directory = "${hmConfig.xdg.cacheHome}/spotify";
              how = "symlink";
              mode = "0700";
              createLinkTarget = true;
            }
          ];
        };

      persistUserTmp =
        { hmConfig, ... }:
        {
          "${hmConfig.xdg.cacheHome}" = { }; # "~/.cache"
          "${hmConfig.xdg.configHome}" = { }; # "~/.config"
        };
    };
  };
}
