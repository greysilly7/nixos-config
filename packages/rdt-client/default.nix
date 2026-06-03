{
  lib,
  stdenv,
  fetchzip,
  makeWrapper,
  dotnet-runtime_8,
}:

stdenv.mkDerivation rec {
  pname = "rdt-client";
  version = "2.0.136";

  src = fetchzip {
    url = "https://github.com/rogerfar/rdt-client/releases/download/v${version}/RealDebridClient.zip";
    sha256 = "1nm90wji78jv6bn75zzh22xsjwx694hmc72prz78dnmnrryr4kha";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/share/rdt-client
    cp -r * $out/share/rdt-client/

    mkdir -p $out/bin
    makeWrapper ${dotnet-runtime_8}/bin/dotnet $out/bin/rdt-client \
      --add-flags "$out/share/rdt-client/RdtClient.Web.dll" \
      --set DOTNET_ROOT "${dotnet-runtime_8}"
  '';

  meta = with lib; {
    description = "Real-Debrid Client";
    homepage = "https://github.com/rogerfar/rdt-client";
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
