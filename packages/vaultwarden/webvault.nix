{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  python3,
  dart-sass,
  vaultwarden,
}:

buildNpmPackage rec {
  pname = "vaultwarden-webvault";
  version = "2026.6.4+0";

  src = fetchFromGitHub {
    owner = "vaultwarden";
    repo = "vw_web_builds";
    tag = "v${version}";
    hash = "sha256-Uz0wPdhTVy2yOlKWAy5phr+30NmFaIPQQh5bsiWCDLA=";
  };

  postPatch = ''
    substituteInPlace package-lock.json \
      --replace-fail '"@napi-rs/cli": "3.5.1"' '"@napi-rs/cli": "3.2.0"'
  '';

  npmDepsFetcherVersion = 2;
  npmDepsHash = "sha256-ZztqThe0kwq4vy0Gt5j8apgYNphsbL2rymbOW2MDKcg=";

  nativeBuildInputs = [
    python3
    dart-sass
  ];

  makeCacheWritable = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    npm_config_build_from_source = "true";
  };

  preBuild = ''
    echo "export const compilerCommand = ['dart-sass'];" > node_modules/sass-embedded/dist/lib/src/compiler-path.js
  '';

  npmRebuildFlags = [
    "--ignore-scripts"
  ];

  npmBuildScript = "dist:oss:selfhost";

  npmBuildFlags = [
    "--workspace"
    "apps/web"
  ];

  npmFlags = [ "--legacy-peer-deps" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/vaultwarden
    mv apps/web/build $out/share/vaultwarden/vault
    runHook postInstall
  '';

  meta = {
    description = "Integrates the web vault into vaultwarden";
    homepage = "https://github.com/vaultwarden/vw_web_builds";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3Plus;
    inherit (vaultwarden.meta) maintainers;
  };
}
