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
buildGoModule (_finalAttrs: {
  pname = "silo-server";
  version = "0-unstable-2026-08-23";

  # Combines two upstream PRs not yet merged to main, which independently
  # touch overlapping playback/transcode-node code: PR 634 (HDR-to-SDR
  # tonemap) and PR 686 (H.264 High10 playback fix). Merged by hand on a
  # fork branch with the resulting semantic conflicts (not just textual
  # ones) resolved and the full test suite passing.
  src = fetchFromGitHub {
    owner = "greysilly7";
    repo = "silo-server";
    rev = "042f7606b5bcd7cf643fb45c359ab0a72cc631b2";
    hash = "sha256-BPXAHsHmDAV1kr8j6tQDqfsl7GjjQd0riOV9/oRy3Qs=";
  };

  vendorHash = "sha256-3YInbuPkkvl/49fKJm8iDr0oZnpiUxOK8HaBRefLnbs=";

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
