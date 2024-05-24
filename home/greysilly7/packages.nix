{pkgs, ...}: {
  home.packages = with pkgs; [
    fastfetch
    firefox
    vscode

    zip
    unzip
    p7zip

    iperf3
    dnsutils
    nmap

    file
    which

    node2nix

    gnupg
    sops
    nixd

    pciutils
    usbutils

    gparted # partition manager
    ffmpeg
    imv # image viewer
    libnotify
    mpv # video player
    ncdu # disk space
    openssl
    pamixer # pulseaudio command line mixer
    pavucontrol # pulseaudio volume controle (GUI)
    playerctl # controller for media players
    poweralertd
    qalculate-gtk # calculator
    unzip
    wget
    xdg-utils
    xxd
  ];
}
