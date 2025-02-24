{
  pkgs,
  inputs,
  lib,
  ...
}: let
  inherit (builtins) attrValues;
  /*

  extra-path = with pkgs; [
    dotnetCorePackages.sdk_9_0

    dotnetPackages.Nuget

    mono

    msbuild

    # Add any extra binaries you want accessible to Rider here
  ];

  extra-lib = [
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

  */
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
        unityhub
        sops
        rquickshare
        fastfetch
        gitoxide
        ;
    }
    ++ [
      pkgs.jetbrains.rust-rover
      pkgs.jetbrains.idea-community-bin
      # ider
      inputs.firefox.packages.${pkgs.system}.firefox-nightly-bin
    ];

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  services.udev.packages = [
    pkgs.android-udev-rules
  ];

  /*

  homix = {
    ".local/share/applications/jetbrains-rider.desktop".text = ''
      [Desktop Entry]
      Name=jetbrains-rider
      Comment=
      Exec="${lib.getExe rider}"
      Icon=rider
      Type=Application
      NoDisplay=true
    '';
  };

  */
}
