{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Browsers
    firefox

    # Code Editors
    vscode
    zed-editor
    # inputs.nvix.packages.${system}.default

    # Compression Tools
    zip
    unzip
    p7zip

    # Network Tools
    iperf3
    dnsutils
    nmap

    # System Tools
    file
    which
    pciutils
    usbutils
    brightnessctl
    libnotify
    dconf

    # Node.js Tools
    node2nix

    # Security Tools
    gnupg
    sops
    nixd
    openssl

    # Disk Management Tools
    gparted # partition manager
    ncdu # disk space

    # Media Tools
    ffmpeg
    imv # image viewer
    mpv # video player
    playerctl # controller for media players

    # Audio Tools
    pamixer # pulseaudio command line mixer
    pavucontrol # pulseaudio volume control (GUI)

    # Miscellaneous Tools
    packwiz
    fastfetch
    qalculate-gtk # calculator
    wget
    xdg-utils
    cinnamon.nemo
    xorg.xhost
    termius
    vesktop
    moonlight-qt
    inputs.dbeaver-last.legacyPackages.${system}.pkgs.dbeaver-bin
    devbox
    discord-canary
    python3
  ];
}
