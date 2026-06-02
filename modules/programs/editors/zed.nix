{ den, ... }:
{
  den.aspects.editors._.zed = {
    includes = [
      den.aspects.editors._.zed._.enable
    ];

    _.enable =
      _:
      {
        nixos =
          { pkgs, ... }:
          {
            environment.systemPackages = [ pkgs.zed-editor ];
          };
        darwin =
          { pkgs, ... }:
          {
            environment.systemPackages = [ pkgs.zed-editor ];
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
  };
}
