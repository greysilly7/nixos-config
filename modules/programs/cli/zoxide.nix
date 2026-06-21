_:
{
  den.aspects.cli._.zoxide = _: {
    homeManager =
      { lib, ... }:
      {
        programs.zoxide = {
          enable = lib.mkDefault true;
          enableBashIntegration = lib.mkDefault true;
          enableZshIntegration = lib.mkDefault true;
        };
      };
  };
}
