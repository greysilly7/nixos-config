{ den, self, ... }:
{
  den.aspects.Scotts-MacBook-Pro = {
    includes = [
      den.aspects.darwin-base
      den.aspects.nix-config
      den.aspects.system-type._.basic
      den.aspects.terminal
      den.aspects.browser
      den.aspects.antigravity
      den.aspects.messaging._.discord
      den.aspects.cli._.nh
    ];
    darwin = {pkgs, ...}:
      {
        security.pam.services.sudo_local.touchIdAuth = true;
        system.stateVersion = 6;
        system.primaryUser = "scottgould";
        sops.defaultSopsFile = self + "/secrets/scottgould/secrets.yaml";


        programs.vim = {
          enable = true;
          enableSensible = true;
        };

        homebrew = {
          onActivation ={
            cleanup = "zap";
            upgrade = true;
            autoUpdate = true;
          };
          enable = true;
          brews = [];
          casks = [
            "tailscale-app"
            "betterdisplay"
            # "kitty"
            "spotify"
            "dbeaver-community"
            "antigravity"
            "legcord"
            "librewolf"
          ];
        };
      };
  };
}
