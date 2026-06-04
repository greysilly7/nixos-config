{ den, ... }:
{
  den.aspects.obsidian = {
    includes = [
      den.aspects.obsidian._.enable
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
