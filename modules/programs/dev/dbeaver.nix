_:
{
  den.aspects.dev._.dbeaver = _: {
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.dbeaver-bin ];
      };
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.dbeaver-bin ];
      };
  };
}
