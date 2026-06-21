{ den, self, ... }:
{
  den.aspects.Scotts-MacBook-Pro = {
    includes = [
      den.aspects.darwin-base
      den.aspects.system-type._.basic
      den.aspects.aerospace
      den.aspects.sketchybar
      den.aspects.stylix
    ];
    provides = rec {
      to-users = _: {
        includes = [
          den.aspects.system-type._.basic
          den.aspects.sketchybar
          den.aspects.editors._.antigravity
          den.aspects.editors._.zed
          den.aspects.music._.tidal
          den.aspects.messaging._.discord._.equibop
          den.aspects.music._.spotify
          den.aspects.system._.betterdisplay
          den.aspects.dev._.dbeaver
          den.aspects.dev._.nodejs
          den.aspects.dev._.opencode
          den.aspects.dev._.antigravity-cli
          den.aspects.office._.obsidian
          den.aspects.browser._.librewolf
          den.aspects.stylix
          den.aspects.terminal._.kitty
        ];
      };
      scottgould = u: (to-users u).includes;
    };
    darwin =
      { pkgs, ... }:
      {
        security.pam.services.sudo_local.touchIdAuth = true;
        system.defaults.NSGlobalDomain.AppleInterfaceStyle = "Dark";
        system.stateVersion = 6;
        sops.defaultSopsFile = self + "/secrets/scottgould/secrets.yaml";

        system.defaults = {
          dock = {
            autohide = true;
            mru-spaces = false;
          };
          NSGlobalDomain = {
            AppleShowAllExtensions = true;
            InitialKeyRepeat = 15;
            KeyRepeat = 2;
          };
          finder = {
            AppleShowAllExtensions = true;
            FXPreferredViewStyle = "clmv";
            QuitMenuItem = true;
            ShowPathbar = true;
            ShowStatusBar = true;
          };
        };

        stylix = {
          base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
          override = { };
        };

        homebrew = {
          onActivation = {
            cleanup = "uninstall";
            upgrade = true;
            autoUpdate = true;
          };
          enable = true;
          brews = [ ];
          casks = [
            "tailscale-app"
            # "kitty"
            "steam"
            "iloader"
            "stremioservice"
            "lm-studio"
            "flameshot"
          ];
        };
      };
  };
}
