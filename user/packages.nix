{
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;

  # Define the desired version of dorion
  dorionVersion = "6.4.1"; # Replace with the desired version

  # Override the dorion package with the specified version
  dorion = pkgs.dorion.overrideAttrs (oldAttrs: {
    version = dorionVersion;
    src = builtins.fetchurl {
      url = "https://github.com/SpikeHD/Dorion/releases/download/v${dorionVersion}/Dorion_${dorionVersion}_amd64.deb";
      sha256 = "sha256:1v69pd77zy4y7q1par4asb1ri92vhyvpisflj1gy8igs6pg640kw";
    };
    buildInputs = [
      pkgs.openssl
      pkgs.webkitgtk_4_1
      pkgs.gst_all_1.gst-plugins-bad
      pkgs.gst_all_1.gst-plugins-base
      pkgs.gst_all_1.gst-plugins-good
      pkgs.glib-networking
    ];
  });
in {
  environment.systemPackages =
    attrValues {
      inherit
        (pkgs)
	gcc
        kitty
        gnupg
        udiskie
        cosmic-files
        cliphist
        grim
        libnotify
        gimp
        git
        ripgrep
        zoxide
        fzf
        eza
        bat
        gping
        dogdns
        cpufetch
        microfetch
        tealdeer
        nmap
        grex
        jq
        rsync
        unzip
        zip
        dnsutils
        which
        vscode
        libreoffice
        nixd
        alejandra
        dbeaver-bin
        sbctl
        btop
        devenv
        ;
    }
    ++ [
      dorion
      pkgs.jetbrains.rust-rover
      inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    ];
}
