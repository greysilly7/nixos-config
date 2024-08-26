{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # Browsers
    firefox

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
    openssl

    # Disk Management Tools
    gparted
    ncdu

    # Media Tools
    ffmpeg

    # Miscellaneous Tools
    wget
    xdg-utils
    xorg.xhost
    termius
    fastfetch
    qalculate-gtk
    python3
  ];
}
