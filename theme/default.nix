rec {
  base00 = "1e1e2e"; # base
  base01 = "181825"; # mantle
  base02 = "313244"; # surface0
  base03 = "45475a"; # surface1
  base04 = "585b70"; # surface2
  base05 = "cdd6f4"; # text
  base06 = "f5e0dc"; # rosewater
  base07 = "b4befe"; # lavender
  base08 = "f38ba8"; # red
  base09 = "fab387"; # peaWch
  base0A = "f9e2af"; # yellow
  base0B = "a6e3a1"; # green
  base0C = "94e2d5"; # teal
  base0D = "89b4fa"; # blue
  base0E = "cba6f7"; # mauve
  base0F = "f2cdcd"; # flamingo
  base10 = "181825"; # mantle - darker background
  base11 = "11111b"; # crust - darkest background
  base12 = "eba0ac"; # maroon - bright red
  base13 = "f5e0dc"; # rosewater - bright yellow
  base14 = "a6e3a1"; # green - bright green
  base15 = "89dceb"; # sky - bright cyan
  base16 = "74c7ec"; # sapphire - bright blue
  base17 = "f5c2e7"; # pink - bright purple

  regular = {
    red = base08;
    peach = base09;
    yellow = base0A;
    green = base0B;
    teal = base0C;
    blue = base0D;
    mauve = base0E;
    flamingo = base0F;
  };

  # Bright colors
  bright = {
    red = base12; # maroon - bright red
    yellow = base13; # rosewater - bright yellow
    green = base14; # green - bright green
    cyan = base15; # sky - bright cyan
    blue = base16; # sapphire - bright blue
    purple = base17; # pink - bright purple
  };

  wallpaper = "${../wallpapers/wallpaper.png}";
}
