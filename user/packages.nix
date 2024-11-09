{
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;

  # Define the desired version of dorion
  dorionVersion = "6.2.0"; # Replace with the desired version

  # Override the dorion package with the specified version
  dorion = pkgs.dorion.overrideAttrs (oldAttrs: {
    version = dorionVersion;
    src = builtins.fetchurl {
      url = "https://github.com/SpikeHD/Dorion/releases/download/v${dorionVersion}/Dorion_${dorionVersion}_amd64.deb";
      sha256 = "sha256:0hgzynwvimx3xfhq7xd2s5dzn87mdky1ylvpb1ns8hf0krbswd3r";
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
        firefox
        floorp
        kitty
        swww
        wl-clipboard
        wl-clip-persist
        hyprpicker
        brightnessctl
        # wf-recorder
        
        hyprpolkitagent
        hyprshot
        gnupg
        udiskie
        cosmic-files
        dolphin
        cliphist
        grim
        networkmanagerapplet
        poweralertd
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
        ffmpeg-full
        catimg
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
        devenv
        gnome-keyring
        ;
    }
    ++ [
      inputs.hypr-contrib.packages.${pkgs.system}.grimblast
      dorion
      inputs.hyprpanel.packages.${pkgs.system}.default
      inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    ];
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    xorg.libX11
    xorg.libXcursor
    xorg.libxcb
    xorg.libXi
    libxkbcommon
    libGL
    libxkbcommon
    wayland
  ];
  programs.direnv.enable = true;
}
