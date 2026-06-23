_: {
  den.aspects.dev._.nixfmt = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nixfmt-rfc-style ];
      };
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nixfmt-rfc-style ];
      };
  };
}
