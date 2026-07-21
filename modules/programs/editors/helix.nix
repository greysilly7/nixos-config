_: {
  den.aspects.editors._.helix = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.helix ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.helix ];
      };

    persistUser =
      { hmConfig, ... }:
      {
        directories = [
          "${hmConfig.home.homeDirectory}/.config/helix"
        ];
      };

    persistUserTmp =
      { hmConfig, ... }:
      {
        "${hmConfig.xdg.configHome}" = { };
      };
  };
}
