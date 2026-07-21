_: {
  den.aspects.editors._.vscodium = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vscodium ];
      };
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.vscodium ];
      };
  };
}
