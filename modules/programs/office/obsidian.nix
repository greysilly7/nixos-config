{ den, ... }:
{
  den.aspects.office._.obsidian = {
    includes = [
      den.aspects.office._.obsidian._.enable
    ];

    _.enable = _: {
      darwin =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.obsidian ];
        };
      nixos =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.obsidian ];
        };
    };
  };
}
