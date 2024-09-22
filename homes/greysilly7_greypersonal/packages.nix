{
  inputs,
  pkgs,
  lib,
  ...
}: let
  extra-path = with pkgs; [
    dotnetCorePackages.sdk_6_0
    dotnetPackages.Nuget
    mono
    msbuild

    # Add any extra binaries you want accessible to Rider here
  ];

  extra-lib = with pkgs; [
    # Add any extra libraries you want accessible to Rider here
  ];

  rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
    postInstall =
      ''
        # Wrap rider with extra tools and libraries
        mv $out/bin/rider $out/bin/.rider-toolless

        makeWrapper $out/bin/.rider-toolless $out/bin/rider \
          --argv0 rider \
          --prefix PATH : "${lib.makeBinPath extra-path}" \
          --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"


        # Making Unity Rider plugin work!
        # The plugin expects the binary to be at /rider/bin/rider,
        # with bundled files at /rider/
        # It does this by going up two directories from the binary path
        # Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/
        shopt -s extglob

        ln -s $out/rider/!(bin) $out/

        shopt -u extglob
      ''
      + attrs.postInstall or "";
  });
in {
  home.packages = with pkgs; [
    # Browsers
    firefox
    chromium

    unityhub
    dotnet-sdk_8
    rider

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
    webcord
    # CAD
    # freecad
    # slic3r

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

  programs.nvchad = {
    enable = true;
    gcc = pkgs.gcc;
  };
}
