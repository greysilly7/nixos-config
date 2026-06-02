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
      ];
    };

    provides.scottgould = _: [
      den.aspects.system-type._.basic
      den.aspects.editors._.antigravity
      den.aspects.editors._.helix
      den.aspects.editors._.zed
    ];
    darwin =
      _:
      {
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
            "betterdisplay"
            # "kitty"
            "spotify"
            "dbeaver-community"
            "legcord"
            "librewolf"
            "steam"
            "obsidian"
            "iloader"
            "stremioservice"
          ];
        };
      };
  };
}
