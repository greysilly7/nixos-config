{
  lib,
  buildGoModule,
  fetchFromGitHub,
  callPackage,
  pkg-config,
  vips,
  jellyfin-ffmpeg,
  makeWrapper,
}:

let
  frontend = callPackage ./frontend.nix { };
in
buildGoModule (finalAttrs: {
  pname = "silo-server";
  version = "0-unstable-2026-08-13";

  src = fetchFromGitHub {
    owner = "Silo-Server";
    repo = "silo-server";
    rev = "ee9356aab341611277bd063a4a9da6b03264bac4";
    hash = "sha256-aa9JMHRIUDv2S7+VGssJdhPNoLZxsTHt2VTA8SdHo4s=";
  };

  vendorHash = "sha256-Jo6Qm4B4d0xO5escR8bhPknwRbJX1s4Fc1JZQXotLXE=";

  subPackages = [ "cmd/silo" ];

  env.CGO_ENABLED = "1";

  nativeBuildInputs = [
    pkg-config
    makeWrapper
  ];

  buildInputs = [ vips ];

  preBuild = ''
    rm -rf web/dist
    cp -r ${frontend} web/dist
  '';

  postInstall = ''
    wrapProgram $out/bin/silo \
      --prefix PATH : ${lib.makeBinPath [ jellyfin-ffmpeg ]}
  '';

  doCheck = false;

  meta = {
    description = "Self-hosted, Jellyfin-compatible media streaming server with a Go backend and React web UI";
    homepage = "https://github.com/Silo-Server/silo-server";
    license = lib.licenses.agpl3Plus;
    mainProgram = "silo";
  };
})
