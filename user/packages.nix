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
        legcord
        sops
        fastfetch
        gitoxide
        zed-editor
        mangohud
        nexusmods-app
        obsidian
        ;
    }
    ++ [
      pkgs.jetbrains.rust-rover
      pkgs.jetbrains.idea-community-bin
      inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    ];

  services.udev.packages = [
    pkgs.android-udev-rules
  ];
}
