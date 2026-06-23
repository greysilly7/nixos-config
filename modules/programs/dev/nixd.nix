_: {
  den.aspects.dev._.nixd = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nixd ];
      };
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nixd ];
      };
  };
}
