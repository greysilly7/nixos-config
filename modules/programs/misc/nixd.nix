{ den, ... }:
{
  den.aspects.misc._.nixd = den.lib.perUser {
    homeManager =
      {
        pkgs,
        lib,
        ...
      }:
      {
        home.packages = [
          pkgs.nixd
        ];
      };
  };
}
