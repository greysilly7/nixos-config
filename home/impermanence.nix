{lib, ...}: {
  home.persistence."/persist/home/greysilly7" = {
    allowOther = true;
    directories =
      [
        "download"
        "music"
        "dev"
        "docs"
        "pics"
        "vids"
        "other"
      ]
      ++ lib.forEach ["syncthing" "Caprine" "VencordDesktop" "obs-studio" "Signal" "niri" "BraveSoftware" "nicotine" "ags"] (
        x: ".config/${x}"
      )
      ++ lib.forEach ["tealdeer" "keepassxc" "nix" "starship" "nix-index" "mozilla" "go-build" "BraveSoftware"] (
        x: ".cache/${x}"
      )
      ++ lib.forEach ["direnv" "TelegramDesktop" "PrismLauncher" "keyrings" "nicotine"] (x: ".local/share/${x}")
      ++ [".ssh" ".keepass" ".mozilla" ".thunderbird"];
  };
}
