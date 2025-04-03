{theme, ...}: {
  homix = {
    ".config/kitty/kitty.conf".text = ''
      # vim:ft=kitty

      ## name:     {{scheme-system}} {{scheme-name}}
      ## author:   {{scheme-author}}
      ## license:  MIT
      ## upstream: https://github.com/tinted-theming/tinted-kitty
      ## blurb:    {{scheme-description}}

      # Scheme name: {{scheme-system}} {{scheme-name}}
      # Scheme author: {{scheme-author}}
      # Template author: Tinted Theming (https://github.com/tinted-theming/tinted-kitty)

      # The basic colors
      background #${theme.base00}
      foreground #${theme.base05}
      selection_background #${theme.base05}
      selection_foreground #${theme.base00}

      # Cursor colors
      cursor #${theme.base05}
      cursor_text_color #${theme.base00}

      # URL underline color when hovering with mouse
      url_color #${theme.base04}

      # Kitty window border colors
      active_border_color #${theme.base03}
      inactive_border_color #${theme.base01}

      # OS Window titlebar colors
      wayland_titlebar_color #${theme.base00}
      macos_titlebar_color #${theme.base00}

      # Tab bar colors
      active_tab_background #${theme.base00}
      active_tab_foreground #${theme.base05}
      inactive_tab_background #${theme.base01}
      inactive_tab_foreground #${theme.base04}
      tab_bar_background #${theme.base01}

      # The 16 terminal colors
      # normal
      color0 #${theme.base00}
      color1 #${theme.base08}
      color2 #${theme.base0B}
      color3 #${theme.base0A}
      color4 #${theme.base0D}
      color5 #${theme.base0E}
      color6 #${theme.base0C}
      color7 #${theme.base05}

      # bright
      color8 #${theme.base02}
      color9 #${theme.base12}
      color10 #${theme.base14}
      color11 #${theme.base13}
      color12 #${theme.base16}
      color13 #${theme.base17}
      color14 #${theme.base15}
      color15 #${theme.base07}

      # extended base16 colors
      color16 #${theme.base09}
      color17 #${theme.base0F}
      color18 #${theme.base01}
      color19 #${theme.base02}
      color20 #${theme.base04}
      color21 #${theme.base06}
    '';
  };
}
