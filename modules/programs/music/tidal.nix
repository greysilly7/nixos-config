{ den, inputs, ... }:
{
  flake-file.inputs.tidaLuna.url = "github:Inrixia/TidaLuna";

  den.aspects.tidal = {
    includes = [
      den.aspects.tidal._.enable
    ];

    _.enable = _: {
      homeManager =
        {
          pkgs,
          ...
        }:
        {
          home.packages = [
            (pkgs.runCommand "tidal-mac" { } ''
              mkdir -p $out/Applications
              cp -r ${
                inputs.tidaLuna.packages.${pkgs.stdenv.hostPlatform.system}.default
              }/Applications/TIDAL.app $out/Applications/
              chmod -R +w $out/Applications/TIDAL.app
              /usr/bin/codesign --force --deep -s - $out/Applications/TIDAL.app
            '')
          ];
        };
    };
  };
}
