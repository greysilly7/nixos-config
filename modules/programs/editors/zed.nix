_: {
  den.aspects.editors._.zed = _: {
    nixos =
      { pkgs, ... }:
      {
        environment.systemPackages = [ pkgs.zed-editor ];
      };
    homeManager =
      { pkgs, ... }:
      {
        home.packages = [ pkgs.zed-editor ];
      };

    persistUser =
      { hmConfig, ... }:
      {
        directories = [
          "${hmConfig.home.homeDirectory}/.config/zed"
        ];
      };

    persistUserTmp =
      { hmConfig, ... }:
      {
        "${hmConfig.xdg.configHome}" = { };
      };
  };
}
