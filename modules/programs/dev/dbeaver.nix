{ den, ... }:
{
  den.aspects.dbeaver = {
    includes = [
      den.aspects.dbeaver._.enable
    ];

    _.enable = _: {
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
  };
}
