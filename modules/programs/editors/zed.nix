{ den, ... }:
{
  den.aspects.editors = {
    _.zed = den.lib.perUser {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.zed-editor
          ];
        };

      persistUser =
        { hmConfig, ... }:
        {
          directories = [
            {
              directory = "${hmConfig.home.homeDirectory}/.config/zed";
              how = "symlink";
              mode = "0700";
              createLinkTarget = true;
            }
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
