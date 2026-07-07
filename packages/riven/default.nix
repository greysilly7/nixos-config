{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  fuse3,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "riven";
  version = "unstable-2026-06-19";

  src = fetchFromGitHub {
    owner = "olivertgwalton";
    repo = "riven-rs";
    rev = "be8a47c528786414318dfa4f99091830c4ef74d0";
    hash = "sha256-MQiMjbAgYSefZ5cJ7bPkG1CGMl26GkD0MXb7U8SZvQ4==";
  };

  cargoHash = "sha256-iLNMxZeMcTuF+cd5Vp6fBSzufHAJD7+1WkROobab3+0=";

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'rust-version = "1.96"' 'rust-version = "1.95"'
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse3
    openssl
  ];

  SQLX_OFFLINE = "true";

  meta = with lib; {
    description = "Rust implementation of the Riven Media tool";
    homepage = "https://github.com/olivertgwalton/riven-rs";
    license = licenses.mit;
    mainProgram = "riven";
  };
}
