{pkgs, ...}: {
  home.packages = with pkgs; [
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

    # Media Tools
    ffmpeg

    # Miscellaneous Tools
    wget
    fastfetch
  ];
}
