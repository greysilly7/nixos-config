{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./neovim.nix
    ./git.nix
    ./bash.nix
    ./kitty.nix
  ];
  # List of packages to install
  home.packages = with pkgs; [
    neofetch
    firefox
    vscode
    vesktop

    zip
    unzip
    p7zip

    iperf3
    dnsutils
    nmap

    file
    which
    gnupg
    nixd

    pciutils
    usbutils
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
