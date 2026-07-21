_: {
  den.aspects.dev._.nodejs = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.nodejs ];
      };
  };
}
