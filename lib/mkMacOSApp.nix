{ lib, stdenv, undmg }:

{ name, version, src, appName ? name, appDir ? "${appName}.app/Contents/MacOS", binaryName ? appName
, extraInstall ? ""
, meta ? { }
, ...
}@args:

stdenv.mkDerivation (args // {
  inherit name version src;

  nativeBuildInputs = [ undmg ] ++ (args.nativeBuildInputs or []);

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out
    cp -r *.app $out/${appName}.app
    ln -s $out/${appDir}/${binaryName} $out/bin/${name}

    ${extraInstall}

    runHook postInstall
  '';

  meta = ({
    platforms = [ "aarch64-darwin" "x86_64-darwin" ];
  } // meta);
})
