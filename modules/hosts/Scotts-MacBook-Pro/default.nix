{ den, self, ... }:
{
  den.aspects.Scotts-MacBook-Pro = {
    includes = [
      den.aspects.darwin-base
      den.aspects.system-type._.basic
    ];
    provides.to-users = _: {
      includes = [
        den.aspects.system-type._.basic
        den.aspects.editors._.antigravity
        den.aspects.editors._.zed
        den.aspects.music._.tidal
        den.aspects.messaging._.discord._.equibop
        den.aspects.music._.spotify
        den.aspects.system._.betterdisplay
        den.aspects.dev._.dbeaver
        den.aspects.office._.obsidian
        den.aspects.browser._.librewolf
      ];
    };

    provides.scottgould = _: [
      den.aspects.system-type._.basic
      den.aspects.editors._.antigravity
      den.aspects.editors._.zed
      den.aspects.music._.tidal
      den.aspects.messaging._.discord._.equibop
      den.aspects.music._.spotify
      den.aspects.system._.betterdisplay
      den.aspects.dev._.dbeaver
      den.aspects.office._.obsidian
      den.aspects.browser._.librewolf
    ];
    darwin = _: {
      security.pam.services.sudo_local.touchIdAuth = true;
      system.stateVersion = 6;
      sops.defaultSopsFile = self + "/secrets/scottgould/secrets.yaml";

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
          "kodi"
        ];
      };
    };
  };
}
