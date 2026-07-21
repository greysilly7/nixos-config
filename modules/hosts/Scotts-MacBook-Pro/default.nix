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
          den.aspects.editors._.vscodium
          den.aspects.messaging._.discord._.equibop
          den.aspects.system._.betterdisplay
          den.aspects.dev._.dbeaver
          den.aspects.dev._.opencode
          den.aspects.dev._.nixd
          den.aspects.dev._.nixfmt
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
        system.stateVersion = 6;
        sops.defaultSopsFile = self + "/secrets/scottgould/secrets.yaml";

        system.defaults = {
          dock = {
            autohide = true;
            mru-spaces = false;
          };
          NSGlobalDomain = {
            AppleInterfaceStyle = "Dark";
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
            upgrade = false;
            autoUpdate = false;
          };
          enable = true;
          brews = [
            "ruby"
            "helix"
          ];
          casks = [
            "tailscale-app"
            "iloader"
            "lm-studio"
            "prismlauncher"
          ];
        };
      };
  };
}
