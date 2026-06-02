{
  den.aspects.noctalia._.colour-schemes = {
    homeManager =
      {
        config,
        pkgs,
        lib,
        ...
      }:
      lib.mkIf pkgs.stdenv.hostPlatform.isLinux {
        home.file = {
          "${config.xdg.configHome}/noctalia/colorschemes/Rosey AMOLED/Rosey AMOLED.json" = {
            source = ./. + "/_Rosey AMOLED.json";
            force = true;
          };
        };
      };
  };
}
