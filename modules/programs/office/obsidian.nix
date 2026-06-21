_:
{
  den.aspects.office._.obsidian = _: {
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
}
