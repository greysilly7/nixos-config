_: {
  den.aspects.dev._.nixfmt = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nixfmt ];
      };
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nixfmt ];
      };
  };
}
