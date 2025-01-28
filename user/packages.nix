{
  pkgs,
  inputs,
  ...
}: let
  inherit (builtins) attrValues;
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
        vesktop
        ;
    }
    ++ [
      pkgs.jetbrains.rust-rover
      inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };
}
