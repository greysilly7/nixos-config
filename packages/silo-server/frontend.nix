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
  version = "0-unstable-2026-08-13";

  src = fetchFromGitHub {
    owner = "Silo-Server";
    repo = "silo-server";
    rev = "ee9356aab341611277bd063a4a9da6b03264bac4";
    hash = "sha256-aa9JMHRIUDv2S7+VGssJdhPNoLZxsTHt2VTA8SdHo4s=";
  };

  sourceRoot = "${finalAttrs.src.name}/web";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src sourceRoot;
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
