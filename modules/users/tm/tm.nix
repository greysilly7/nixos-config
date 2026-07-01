_: {
  den.aspects.tm = {
    user =
      { pkgs, lib, ... }:
      lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        isNormalUser = true;
        description = "Time Machine Backup User";
      };
  };
}
