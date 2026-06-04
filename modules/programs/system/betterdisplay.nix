{ den, ... }:
{
  den.aspects.betterdisplay = {
    includes = [
      den.aspects.betterdisplay._.enable
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
