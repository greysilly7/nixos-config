{ den, ... }:
{
  # TODO: Configure bash
  # https://mynixos.com/home-manager/options/programs.bash
  den.aspects.shell._.bash = den.lib.perUser {
    homeManager =
      { lib, pkgs, ... }:
      {
        home.packages = [
          pkgs.nixd
        ];
      };
  };
}
