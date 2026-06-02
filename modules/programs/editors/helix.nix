{ den, ... }:
{
  den.aspects.editors = {
    _.helix = den.lib.perUser {
      homeManager =
        { pkgs, ... }:
        {
          home.packages = [
            pkgs.helix
          ];
        };

      persistUser =
        { hmConfig, ... }:
        {
          directories = [
            {
              directory = "${hmConfig.home.homeDirectory}/.config/helix";
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
