{lib, ...}: {
  home.persistence."/persist/home/greysilly7" = {
    allowOther = true;
    # directories = [".ssh" ".mozilla" ".config/hypr" ".config/kitty" ".cache/nix" ".cache/mozilla"];
    directories =
      [
        "Downloads"
        "nixos-config"
        "Pictures"
      ]
      ++ lib.forEach ["audacios" "bat" "Code" "dconf" "discord" "enviorment.d" "fish" "fontconfig" "git" "hypr" "kitty" "pulse" "swaylock" "Vencord" "waybar" "wofi"] (
        x: ".config/${x}"
      )
      ++ lib.forEach ["nix" "mozilla"] (
        x: ".cache/${x}"
      )
      ++ lib.forEach ["PrismLauncher" "keyrings"] (x: ".local/share/${x}")
      ++ [".ssh" ".keepass" ".mozilla" ".vscode"];
    files = [".bash_history"];
  };
}
