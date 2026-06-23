_: {
  den.aspects.editors._.neovim = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.neovim ];
      };
    darwin =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.neovim ];
      };
  };
}
