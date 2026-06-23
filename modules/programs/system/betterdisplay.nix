_: {
  den.aspects.system._.betterdisplay = _: {
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.betterdisplay ];
      };
  };
}
