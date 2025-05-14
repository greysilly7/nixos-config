{ pkgs, ... }:
let
  script = ./wifi-menu.sh;
in
pkgs.stdenv.mkDerivation {
  pname = "wifi-menu";
  version = "1.0";

  src = null; # No source to fetch, using local script

  buildInputs = [ pkgs.bash ];

  installPhase = ''
    mkdir -p $out/bin
    cp ${script} $out/bin/wifi-menu
    chmod +x $out/bin/wifi-menu
  '';

  meta = with pkgs.lib; {
    description = "A simple script for managing Wi-Fi connections";
    license = licenses.mit;
    maintainers = with maintainers; [ yourName ];
  };
}