{ den, ... }:
{
  den.aspects.terminal = {
    includes = [
      den.aspects.terminal._.kitty
    ];

    # https://mynixos.com/home-manager/options/programs.kitty
    _.kitty = _: {
      homeManager =
        {
          lib,
          ...
        }:
        {
          programs.kitty = {
            enable = lib.mkDefault true;

            themeFile = "Catppuccin-Macchiato";

            font = {
              name = lib.mkForce "Hack Nerd Font";
              size = lib.mkForce 14.0;
            };

            settings = {
              background_opacity = lib.mkForce "0.85";
              background_blur = lib.mkForce 30;
              hide_window_decorations = lib.mkForce "titlebar-only";
              window_padding_width = lib.mkForce 10;
              confirm_os_window_close = lib.mkForce 0;
            };

            shellIntegration = {
              enableZshIntegration = lib.mkDefault true;
              enableBashIntegration = lib.mkDefault true;
            };
            enableGitIntegration = lib.mkDefault true;
          };

          # Custom aliases
          home.shellAliases = {
            ssh = lib.mkDefault "kitty +kitten ssh";
          };

          xdg = {
            terminal-exec = {
              enable = true;
              settings = {
                default = lib.mkBefore [
                  "kitty.desktop"
                ];
              };
            };
            mimeApps = {
              defaultApplications = lib.mkBefore (
                let
                  application = "kitty-open.desktop";
                  mimeTypes = [
                    "x-scheme-handler/kitty"
                    "x-scheme-handler/ssh"
                  ];
                in
                lib.genAttrs mimeTypes (_mimetype: application)
              );
              associations.added =
                let
                  application = "kitty-open.desktop";
                  mimeTypes = [
                    "application/x-sh"
                    "application/x-shellscript"
                    "inode/directory"
                    "image/*"
                    "text/*"
                  ];
                in
                lib.genAttrs mimeTypes (_mimetype: application);
            };
          };
        };

      persistUserIgnore =
        { hmConfig, ... }:
        {
          directories = [ "${hmConfig.xdg.cacheHome}/kitty" ];
        };
    };
  };
}
