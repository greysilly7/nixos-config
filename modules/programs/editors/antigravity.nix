{ den, ... }:
{
  den.aspects.editors._.antigravity = {
    includes = [
      den.aspects.editors._.antigravity._.enable
    ];

    _.enable =
      _:
      {
        homeManager =
          { pkgs, ... }:
          {
            # Install directly from standard nixpkgs
            home.packages = [
              pkgs.antigravity
            ];
          };

        # Persist the entire Antigravity config directory
        persistUser =
          { hmConfig, ... }:
          {
            directories = [
              "${hmConfig.xdg.configHome}/Antigravity"
            ];
          };

        # Ensure the parent directories exist for your impermanence setup
        persistUserTmp =
          { hmConfig, ... }:
          {
            "${hmConfig.xdg.configHome}" = { }; # "~/.config"
            "${hmConfig.xdg.configHome}/Antigravity" = { };
          };

        # Ignore caches or transient files inside the config directory
        persistUserIgnore =
          { hmConfig, ... }:
          {
            directories = [
              "${hmConfig.xdg.configHome}/Antigravity/Cache"
            ];
            files = [ ];
          };
      };
  };
}
