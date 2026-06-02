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
      };
  };
}
