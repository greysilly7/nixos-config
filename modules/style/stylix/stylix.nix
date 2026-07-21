{
  inputs,
  den,
  ...
}:
{
  den.aspects.stylix = {
    includes = [
      den.aspects.stylix._.sys
      den.aspects.stylix._.user
    ];

    _.sys = _: {
      nixos =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          imports = [ inputs.stylix.nixosModules.stylix ];
          stylix = {
            enable = lib.mkDefault true;
            homeManagerIntegration.autoImport = lib.mkDefault true;
            homeManagerIntegration.followSystem = lib.mkDefault true;
            autoEnable = lib.mkDefault false;
            polarity = "dark";
            base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/pinky.yaml";
            override = lib.mkDefault {
              base00 = "121012";
              base02 = "b5b0b5";
              base0C = "a972fc";
            };
            image = lib.mkDefault (
              pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/landscapes/yosemite.png";
                sha256 = "0zyphcvh6dxbq997h716lcr2kpilp4jid9hp2sdjphpxpf824nck";
              }
            );

            cursor = lib.mkDefault {
              name = "Vimix-cursors";
              package = pkgs.vimix-cursors;
              size = 24;
            };

            icons = lib.mkDefault {
              enable = true;
              package = pkgs.papirus-icon-theme.override {
                color = "pink";
              };
              light = "Papirus-Light";
              dark = "Papirus-Dark";
            };

            fonts = {
              serif = lib.mkDefault {
                name = "Adwaita Sans";
                package = pkgs.adwaita-fonts;
              };
              sansSerif = lib.mkDefault {
                name = "Adwaita Sans";
                package = pkgs.adwaita-fonts;
              };
              monospace = lib.mkDefault {
                name = "JetBrainsMono Nerd Font Mono";
                package = pkgs.nerd-fonts.jetbrains-mono;
              };
              emoji = lib.mkDefault {
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
              };
              sizes = lib.mkDefault {
                terminal = 11;
              };
            };

            opacity.terminal = lib.mkDefault 0.4;

            targets = {
              gtk.enable = lib.mkDefault true;
              qt.enable = lib.mkDefault true;
              gnome.enable = lib.mkDefault config.services.displayManager.gdm.enable;
              regreet.enable = lib.mkDefault config.programs.regreet.enable;
            };
          };
        };

      darwin =
        {
          pkgs,
          lib,
          ...
        }:
        {
          imports = [ inputs.stylix.darwinModules.stylix ];
          stylix = {
            enable = lib.mkDefault true;
            homeManagerIntegration.autoImport = lib.mkDefault true;
            homeManagerIntegration.followSystem = lib.mkDefault true;
            autoEnable = lib.mkDefault false;
            polarity = "dark";
            base16Scheme = lib.mkDefault "${pkgs.base16-schemes}/share/themes/pinky.yaml";
            override = lib.mkDefault {
              base00 = "121012";
              base02 = "b5b0b5";
              base0C = "a972fc";
            };
            image = lib.mkDefault (
              pkgs.fetchurl {
                url = "https://raw.githubusercontent.com/zhichaoh/catppuccin-wallpapers/main/landscapes/yosemite.png";
                sha256 = "0zyphcvh6dxbq997h716lcr2kpilp4jid9hp2sdjphpxpf824nck";
              }
            );

            fonts = {
              serif = lib.mkDefault {
                name = "Adwaita Sans";
                package = pkgs.adwaita-fonts;
              };
              sansSerif = lib.mkDefault {
                name = "Adwaita Sans";
                package = pkgs.adwaita-fonts;
              };
              monospace = lib.mkDefault {
                name = "JetBrainsMono Nerd Font Mono";
                package = pkgs.nerd-fonts.jetbrains-mono;
              };
              emoji = lib.mkDefault {
                package = pkgs.noto-fonts-color-emoji;
                name = "Noto Color Emoji";
              };
              sizes = lib.mkDefault {
                terminal = 11;
              };
            };
          };
        };
    };

    _.user = _: {
      homeManager =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        {
          stylix = {
            targets = {
              gtk = lib.mkDefault {
                enable = !pkgs.stdenv.hostPlatform.isDarwin;
                flatpakSupport.enable = !pkgs.stdenv.hostPlatform.isDarwin;
                # Force dialog buttons to use white text
                extraCss = ''
                  dialog button, .dialog-action-area > .text-button {
                    color: @theme_text_color;
                  }
                '';
              };

              kitty.enable = lib.mkDefault config.programs.kitty.enable;
              qt.enable = lib.mkDefault (!pkgs.stdenv.hostPlatform.isDarwin);
            };
          };

          dconf.settings."org/gnome/desktop/interface" = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) {
            color-scheme = lib.mkDefault "prefer-dark";
          };

          gtk.gtk4.theme = lib.mkIf (!pkgs.stdenv.hostPlatform.isDarwin) config.gtk.theme; # Changed to `null` in home-manager version `26.05`

          # Clean up dots
          xresources.path = lib.mkDefault "${config.xdg.configHome}/X11/xresources";
          home.sessionVariables = {
            XCOMPOSECACHE = lib.mkDefault "${config.xdg.cacheHome}/X11/xcompose";
          };
        };

      niri =
        {
          config,
          pkgs,
          ...
        }:
        {
          settings.spawn-at-startup = [
            { sh = "${pkgs.xrdb}/bin/xrdb -merge ${config.xresources.path}"; }
          ];
        };
    };
  };
}
