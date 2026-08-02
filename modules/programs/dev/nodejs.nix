_: {
  den.aspects.dev._.nodejs = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.nodejs
          pkgs.bun
        ];
      };
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [
          pkgs.nodejs
          pkgs.bun
        ];
      };
  };
}
