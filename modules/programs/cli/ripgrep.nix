_: {
  den.aspects.cli._.ripgrep = _: {
    homeManager =
      { lib, ... }:
      {
        programs.ripgrep = {
          enable = lib.mkDefault true;
        };
      };
  };
}
