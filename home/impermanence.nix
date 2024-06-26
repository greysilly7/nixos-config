{lib, ...}: {
  home.persistence."/persist/home/greysilly7" = {
    allowOther = true;
    directories =
      [
        "Downloads"
        "nixos-config"
        "Pictures"
      ]
      ++ lib.forEach ["audacios" "bat" "Code" "dconf" "discord" "enviorment.d" "fish" "fontconfig" "git" "hypr" "kitty" "pulse" "swaylock" "Vencord" "waybar" "wofi" "sops" "nvim" "TabNine"] (
        x: ".config/${x}"
      )
      ++ lib.forEach ["nix" "mozilla"] (
        x: ".cache/${x}"
      )
      ++ lib.forEach ["PrismLauncher" "keyrings" "Steam"] (x: ".local/share/${x}")
      ++ [".ssh" ".keepass" ".mozilla" ".vscode"];
    files = [".bash_history"];
  };
}
