{
  lib,
  stdenv,
  fetchurl,
  makeWrapper,
  # Darwin
  undmg,
  # Linux
  autoPatchelfHook ? null,
  alsa-lib ? null,
  cups ? null,
  libdrm ? null,
  mesa ? null,
  nss ? null,
  libX11 ? null,
  libXScrnSaver ? null,
  libXcomposite ? null,
  libXdamage ? null,
  libXext ? null,
  libXfixes ? null,
  libXrandr ? null,
  libxcb ? null,
  libxkbcommon ? null,
  pango ? null,
  cairo ? null,
  atk ? null,
  at-spi2-atk ? null,
  at-spi2-core ? null,
  gtk3 ? null,
  glib ? null,
  systemd ? null,
}:

let
  pname = "equibop";
  version = "3.2.1";

  srcs = {
    aarch64-darwin = fetchurl {
      url = "https://github.com/Equicord/Equibop/releases/download/v${version}/Equibop-${version}-universal.dmg";
      hash = "sha256-J7SWkMg96yTclfbhmNjcNQ3mY0KPqLO9wHe+YYvqc5w=";
    };
    x86_64-darwin = fetchurl {
      url = "https://github.com/Equicord/Equibop/releases/download/v${version}/Equibop-${version}-universal.dmg";
      hash = lib.fakeHash;
    };
    x86_64-linux = fetchurl {
      url = "https://github.com/Equicord/Equibop/releases/download/v${version}/equibop-${version}.tar.gz";
      hash = lib.fakeHash;
    };
    aarch64-linux = fetchurl {
      url = "https://github.com/Equicord/Equibop/releases/download/v${version}/equibop-${version}-arm64.tar.gz";
      hash = lib.fakeHash;
    };
  };

  src =
    srcs.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");
in
stdenv.mkDerivation {
  inherit pname version src;

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ undmg ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ autoPatchelfHook ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    cups
    libdrm
    mesa
    nss
    libX11
    libXScrnSaver
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libxkbcommon
    pango
    cairo
    atk
    at-spi2-atk
    at-spi2-core
    gtk3
    glib
    systemd
  ];

  sourceRoot = if stdenv.hostPlatform.isDarwin then "." else ".";

  installPhase = ''
    runHook preInstall

    ${
      if stdenv.hostPlatform.isDarwin then
        ''
          mkdir -p $out/Applications
          cp -r *.app $out/Applications/

          mkdir -p $out/bin
          makeWrapper $out/Applications/Equibop.app/Contents/MacOS/Equibop $out/bin/equibop
        ''
      else
        ''
          mkdir -p $out/opt/Equibop
          cp -r * $out/opt/Equibop/

          mkdir -p $out/bin
          makeWrapper $out/opt/Equibop/equibop $out/bin/equibop \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

          # Install desktop file and icons if they exist in the tarball
          if [ -f equibop.desktop ]; then
            mkdir -p $out/share/applications
            cp equibop.desktop $out/share/applications/
          fi
          if [ -d icons ]; then
            mkdir -p $out/share/icons
            cp -r icons/* $out/share/icons/
          fi
        ''
    }

    runHook postInstall
  '';

  meta = with lib; {
    description = "Custom Discord App aiming to give you better performance and improve linux support";
    homepage = "https://github.com/Equicord/Equibop";
    license = licenses.gpl3Only;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "equibop";
  };
}
