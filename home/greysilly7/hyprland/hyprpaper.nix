{...}: {
  home.file.".config/hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/wallpapers/wallpaper.png

    #enable splash text rendering over the wallpaper
    splash = true

    # Makes battery life worse
    ipc = off
  '';
}
