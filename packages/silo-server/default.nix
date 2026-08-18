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

  vendorHash = "sha256-Lzqzs35cq7+KDCz/E6zfM7SQtvpZvSRdSACunjFhpH4=";

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

  # Upstream's default ffmpeg path is the Debian jellyfin-ffmpeg7 package
  # location, which doesn't exist under Nix. Point the built-in default at
  # this package's own jellyfin-ffmpeg so a fresh server_settings row (no
  # admin override saved yet) resolves to a real binary instead of failing
  # every scan/transcode with fork/exec ENOENT.
  postPatch = ''
    for f in internal/config/db_loader.go internal/config/config.go internal/config/admin_settings.go; do
      substituteInPlace "$f" \
        --replace-fail '/usr/lib/jellyfin-ffmpeg/ffmpeg' '${jellyfin-ffmpeg}/bin/ffmpeg'
    done
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
