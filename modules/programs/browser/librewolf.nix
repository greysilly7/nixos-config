{den, ...}: {
  den.aspects.browser = {
    # The default sub-aspect included when the generic 'browser' aspect is used
    includes = [
      den.aspects.browser._.librewolf
    ];

    _.librewolf = den.lib.perUser {
      homeManager = {
        pkgs,
        lib,
        ...
      }: {
        home.packages = [
          pkgs.librewolf
        ];

        xdg = {
          mimeApps = {
            defaultApplications = lib.mkBefore (
              let
                application = "librewolf.desktop";
                mimeTypes = [
                  "application/rdf+xml"
                  "application/rss+xml"
                  "application/xhtml+xml"
                  "application/xhtml_xml"
                  "x-scheme-handler/http"
                  "x-scheme-handler/https"
                  "x-scheme-handler/about"
                  "x-scheme-handler/mailto"
                  "x-scheme-handler/unknown"
                  "x-scheme-handler/librewolf"
                ];
              in
                lib.genAttrs mimeTypes (mimetype: application)
            );
            associations.added = let
              application = "librewolf.desktop";
              mimeTypes = [
                "application/xml"
                "application/pdf"
                "text/markdown"
                "image/jpeg"
                "image/webp"
                "image/gif"
                "image/png"
                "text/html"
                "text/xml"
              ];
            in
              lib.genAttrs mimeTypes (mimetype: application);
          };
        };
      };

      persistUser = {hmConfig, ...}: {
        directories = [
          {
            # directory = "${hmConfig.xdg.home}/.librewolf";
            directory = "${hmConfig.home.homeDirectory}/.librewolf";
            how = "symlink";
            mode = "0700";
            createLinkTarget = true;
          }
        ];
      };

      persistUserTmp = {hmConfig, ...}: {
        "${hmConfig.xdg.configHome}" = {}; # "~/.config"
      };

      persistUserIgnore = {hmConfig, ...}: {
        directories = ["${hmConfig.xdg.cacheHome}/librewolf"];
      };
    };
  };
}
