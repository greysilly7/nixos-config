{ den, ... }:
{
  den.aspects.dev._.nodejs = {
    includes = [
      den.aspects.dev._.nodejs._.enable
    ];

    _.enable = _: {
      darwin =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.nodejs ];
        };
      nixos =
        { pkgs, ... }:
        {
          environment.systemPackages = [ pkgs.nodejs ];
        };
      homeManager =
        { pkgs, ... }:
        {
          home.packages = [ pkgs.nodejs ];
        };
    };
  };
}
