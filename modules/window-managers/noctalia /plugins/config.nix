_:
{
  den.aspects.noctalia._.plugins._.config =
    _:
    {
      homeManager =
        { lib, pkgs, ... }:
        lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
          programs.noctalia-shell = {
            plugins.version = lib.mkDefault 2;
            settings.plugins = {
              autoUpdate = lib.mkDefault false;
              notifyUpdates = lib.mkDefault false;
            };
          };
        };
    };
}
