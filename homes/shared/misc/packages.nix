{pkgs, ...}: {
  home.packages = with pkgs; [
    # Compression Tools
    p7zip
    unzip
    zip

    # Network Tools
    dnsutils
    iperf3
    nmap

    # System Tools
    file
    pciutils
    usbutils
    which

    # Security Tools
    gnupg
    openssl
    sops

    # Media Tools
    ffmpeg
  ];
}
