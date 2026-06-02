{ den, ... }:
{
  den.aspects.editors._.helix = {
    includes = [
      den.aspects.editors._.helix._.enable
    ];

    _.enable =
      _:
      {
        nixos =
          { pkgs, ... }:
          {
            environment.systemPackages = [ pkgs.helix ];
          };
        darwin =
          { pkgs, ... }:
          {
            environment.systemPackages = [ pkgs.helix ];
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
  };
}
