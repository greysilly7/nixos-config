{ den, inouts, ... }: {
  flake-file.inputs.tidaLuna.url = "github:Inrixia/TidaLuna";
  
  den.aspects.tidal = {
    includes = [
      den.aspects.tidal._.enable
    ];

    _.enable =
      _: {
        homeManager = {
          pkgs,
          lib,
          ...
        }: {
          home.packages = [
            inputs.tidaLuna.packages.${stdenv.hostPlatform.system}.default
          ];
        };
      };
  };
}