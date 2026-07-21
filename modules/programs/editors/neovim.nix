_: {
  den.aspects.editors._.neovim = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.neovim ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.neovim ];
      };
  };
}
