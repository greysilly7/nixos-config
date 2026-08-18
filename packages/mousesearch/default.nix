{
  lib,
  fetchFromGitHub,
  python3,
  makeWrapper,
  stdenvNoCC,
  callPackage,
}:
let
  bencodepy = callPackage ../bencodepy { };
  pythonEnv = python3.withPackages (
    ps: with ps; [
      apscheduler
      bencodepy
      httpx
      hypercorn
      python-dotenv
      quart
      rapidfuzz
      socksio
      qbittorrent-api
    ]
  );
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "mousesearch";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "sevenlayercookie";
    repo = "MouseSearch";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JnuvkTbk41mZxYK3AXM+3Rnsq2t8uvZ1MqzQgclItEI=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/mousesearch
    cp -r app.py hashing.py version.txt static templates clients hardcover $out/share/mousesearch/

    makeWrapper ${pythonEnv}/bin/hypercorn $out/bin/mousesearch \
      --run "cd $out/share/mousesearch" \
      --add-flags "--bind \''${ADDRESS:-0.0.0.0}:\''${PORT:-5000}" \
      --add-flags "--workers 1 --worker-class asyncio" \
      --add-flags "--access-logfile \''${ACCESS_LOGFILE:--}" \
      --add-flags "--error-logfile - --log-level info" \
      --add-flags "app:app"

    runHook postInstall
  '';

  meta = {
    description = "Self-hosted search UI for MyAnonamouse with modular torrent-client integration";
    homepage = "https://github.com/sevenlayercookie/MouseSearch";
    license = lib.licenses.unfree; # upstream ships no LICENSE file
    mainProgram = "mousesearch";
    platforms = lib.platforms.linux;
  };
})
