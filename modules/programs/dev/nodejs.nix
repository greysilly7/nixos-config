_:
{
  den.aspects.dev._.nodejs = _: {
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nodejs ];
      };
  };
}
