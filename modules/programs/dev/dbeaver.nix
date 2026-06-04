{ den, ... }:
{
  den.aspects.dev._.dbeaver = {
    includes = [
      den.aspects.dev._.dbeaver._.enable
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
