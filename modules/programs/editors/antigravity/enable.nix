_: {
  den.aspects.editors._.antigravity._.enable = _: {
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

        # If Antigravity uses specific sensitive files outside the main config,
        # or you need strict permissions, list them here:
        # files = [
        #   {
        #     file = "${hmConfig.xdg.configHome}/Antigravity/SomeSensitiveFile";
        #     mode = "0600";
        #   }
        # ];
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
          # Example: if Antigravity creates a Cache folder you don't want to save
          "${hmConfig.xdg.configHome}/Antigravity/Cache"
        ];
        files = [ ];
      };
  };
}
