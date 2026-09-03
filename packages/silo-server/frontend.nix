{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs_22,
  pnpm_10,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "silo-server-frontend";
  version = "0-unstable-2026-08-23";

  # Kept in lockstep with packages/silo-server/default.nix's src: both must
  # point at the same commit, or the built web UI drifts from the backend API
  # (e.g. missing settings the backend already understands).
  src = fetchFromGitHub {
    owner = "greysilly7";
    repo = "silo-server";
    rev = "042f7606b5bcd7cf643fb45c359ab0a72cc631b2";
    hash = "sha256-BPXAHsHmDAV1kr8j6tQDqfsl7GjjQd0riOV9/oRy3Qs=";
  };

  sourceRoot = "${finalAttrs.src.name}/web";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      sourceRoot
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-Jo6Qm4B4d0xO5escR8bhPknwRbJX1s4Fc1JZQXotLXE=";
  };

  nativeBuildInputs = [
    nodejs_22
    pnpm_10
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild
    pnpm run build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    cp -r dist $out
    runHook postInstall
  '';

  meta = {
    description = "Built React web UI assets for Silo, embedded into the silo-server Go binary";
    homepage = "https://github.com/Silo-Server/silo-server";
    license = lib.licenses.agpl3Plus;
  };
})
