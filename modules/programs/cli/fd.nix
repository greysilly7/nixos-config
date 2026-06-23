_: {
  den.aspects.cli._.fd = _: {
    homeManager =
      { lib, ... }:
      {
        programs.fd = {
          enable = lib.mkDefault true;
        };
      };
  };
}
