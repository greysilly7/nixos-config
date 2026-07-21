_: {
  den.aspects.editors._.vscodium = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vscodium ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.vscodium ];
      };
  };
}
