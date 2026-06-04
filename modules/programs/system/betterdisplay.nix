{ den, ... }:
{
  den.aspects.system._.betterdisplay = {
    includes = [
      den.aspects.system._.betterdisplay._.enable
    ];

    _.enable = _: {
      darwin =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.betterdisplay ];
        };
    };
  };
}
