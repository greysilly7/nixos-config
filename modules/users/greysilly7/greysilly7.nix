_: {
  den.aspects.greysilly7 = {
    nixos = _: {
      sops.secrets = {
        greysilly7_password.neededForUsers = true;
      };
    };
    user =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        hashedPasswordFile = config.sops.secrets.greysilly7_password.path;
        extraGroups = [ "wheel" ];
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
        ];
      };
  };
}
