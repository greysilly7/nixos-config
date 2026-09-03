{ inputs, pkgs, ... }:
let
  tidaLunaPkg = inputs.tidaLuna.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  flake-file.inputs.tidaLuna.url = "github:Inrixia/TidaLuna";

  den.aspects.music._.tidal = _: {
    homeManager = _: {
      home.packages = [
        (pkgs.stdenv.mkDerivation {
          name = "tidal-mac";
          inherit (tidaLunaPkg) src;
          nativeBuildInputs = [ pkgs.undmg ];
          installPhase = ''
            mkdir -p $out/bin
            cp -r *.app $out/TIDAL.app
            ln -s $out/TIDAL.app/Contents/MacOS/TIDAL $out/bin/tidal
          '';
        })
      ];
    };
  };
}
