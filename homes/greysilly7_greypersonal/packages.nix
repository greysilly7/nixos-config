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
    #inputs.nvix.packages.${system}.default
    neovim

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

    # Chat Clients
    vesktop
    discord-canary

    # Office Tools
    libreoffice

    # Miscellaneous Tools
    fastfetch
    wget
    xdg-utils
    xorg.xhost
    termius
    inputs.dbeaver-last.legacyPackages.${system}.pkgs.dbeaver-bin
    ntfs3g
  ];
}
