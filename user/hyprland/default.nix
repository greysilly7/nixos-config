{
  pkgs,
  lib,
  theme,
  ...
}: let
  hpyrPlugins = [pkgs.hyprlandPlugins.borders-plus-plus pkgs.hyprlandPlugins.hyprbars];
  toHyprconf = {
    attrs,
    indentLevel ? 0,
    importantPrefixes ? ["$"],
  }: let
    inherit
      (lib)
      all
      concatMapStringsSep
      concatStrings
      concatStringsSep
      filterAttrs
      foldl
      generators
      hasPrefix
      isAttrs
      isList
      mapAttrsToList
      replicate
      ;

    initialIndent = concatStrings (replicate indentLevel "  ");

    toHyprconf' = indent: attrs: let
      sections =
        filterAttrs (n: v: isAttrs v || (isList v && all isAttrs v)) attrs;

      mkSection = n: attrs:
        if lib.isList attrs
        then (concatMapStringsSep "\n" (a: mkSection n a) attrs)
        else ''
          ${indent}${n} {
          ${toHyprconf' "  ${indent}" attrs}${indent}}
        '';

      mkFields = generators.toKeyValue {
        listsAsDuplicateKeys = true;
        inherit indent;
      };

      allFields =
        filterAttrs (n: v: !(isAttrs v || (isList v && all isAttrs v)))
        attrs;

      isImportantField = n: _:
        foldl (acc: prev:
          if hasPrefix prev n
          then true
          else acc)
        false
        importantPrefixes;

      importantFields = filterAttrs isImportantField allFields;

      fields =
        builtins.removeAttrs allFields
        (mapAttrsToList (n: _: n) importantFields);
    in
      mkFields importantFields
      + concatStringsSep "\n" (mapAttrsToList mkSection sections)
      + mkFields fields;
  in
    toHyprconf' initialIndent attrs;

  pluginsToHyprconf = plugins:
    toHyprconf {
      attrs = {
        plugin = let
          mkEntry = entry:
            if lib.types.package.check entry
            then "${entry}/lib/lib${entry.pname}.so"
            else entry;
        in
          map mkEntry hpyrPlugins;
      };
    };

  hyprlandConfigAttrs = {
    autostart = {
      exec-once = [
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
        "nm-applet &"
        "poweralertd &"
        "wl-clip-persist --clipboard both &"
        "wl-paste --type text --watch cliphist store &"
        "wl-paste --type image --watch cliphist store &"
        # "waybar &"
        "udiskie &"
        "hyprpanel &"
        "mako &"
        "hyprpaper &"
        "systemctl --user start hyprpolkitagent &"
        "hyprlock"
      ];
    };

    monitor = "eDP-1, 1920x1080@60, 0x0, 1";

    input = {
      kb_layout = "us,fr";
      kb_options = "grp:alt_caps_toggle";
      numlock_by_default = true;
      follow_mouse = 0;
      float_switch_override_focus = 0;
      mouse_refocus = 0;
      sensitivity = 0;
      touchpad = {
        natural_scroll = true;
      };
    };

    general = {
      "$mainMod" = "SUPER";
      layout = "dwindle";
      gaps_in = 5;
      gaps_out = 10;
      border_size = 2;
      "col.active_border" = "rgb(${theme.base0B})";
      "col.inactive_border" = "0x00000000";
      border_part_of_window = false;
      no_border_on_floating = false;
    };

    misc = {
      disable_autoreload = true;
      disable_hyprland_logo = true;
      always_follow_on_dnd = true;
      layers_hog_keyboard_focus = true;
      animate_manual_resizes = false;
      enable_swallow = true;
      focus_on_activate = true;
      new_window_takes_over_fullscreen = 2;
      middle_click_paste = false;
      vfr = true;
    };

    dwindle = {
      force_split = 0;
      special_scale_factor = 1.0;
      split_width_multiplier = 1.0;
      use_active_for_splits = true;
      pseudotile = "yes";
      preserve_split = "yes";
    };

    master = {
      new_status = "master";
      special_scale_factor = 1;
    };

    decoration = {
      rounding = 0;
      blur = {
        enabled = false;
        size = 2;
        passes = 2;
        brightness = 1;
        contrast = 1.400;
        ignore_opacity = true;
        noise = 0;
        new_optimizations = true;
        xray = true;
      };
      drop_shadow = false;
      shadow_ignore_window = true;
      shadow_offset = "0 2";
      shadow_range = 20;
      shadow_render_power = 3;
      "col.shadow" = "rgba(${theme.base00}55)";
    };

    bind = [
      # "$mainMod, F1, exec, show-keybinds"
      "$mainMod, Return, exec, kitty"
      "ALT, Return, exec, [float; center; size 950 650] kitty"
      "$mainMod SHIFT, Return, exec, [fullscreen] kitty"
      "$mainMod, B, exec, hyprctl dispatch exec '[workspace 1 silent] floorp'"
      "$mainMod, Q, killactive,"
      "$mainMod, F, fullscreen, 0"
      "$mainMod SHIFT, F, fullscreen, 1"
      "$mainMod, Space, exec, toggle_float"
      "$mainMod, D, exec, rofi -show drun || pkill rofi"
      "$mainMod SHIFT, D, exec, Dorion --enable-features=UseOzonePlatform --ozone-platform=wayland"
      "$mainMod SHIFT, S, exec, hyprctl dispatch exec '[workspace 5 silent] SoundWireServer'"
      "$mainMod, Escape, exec, hyprlock"
      "$mainMod SHIFT, Escape, exec, power-menu"
      "$mainMod, P, pseudo,"
      "$mainMod, X, togglesplit,"
      "$mainMod, T, exec, toggle_oppacity"
      "$mainMod, E, exec, cosmic-files"
      "$mainMod, C ,exec, hyprpicker -a"
      "$mainMod, W,exec, wallpaper-picker"
      # "$mainMod SHIFT, W, exec, vm-start"
      "$mainMod, PRINT, exec, hyprshot -m window"
      ", PRINT, exec, hyprshot -m output"
      "$shiftMod, PRINT, exec, hyprshot -m region"
      "$mainMod, left, movefocus, l"
      "$mainMod, right, movefocus, r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"
      "$mainMod, h, movefocus, l"
      "$mainMod, j, movefocus, d"
      "$mainMod, k, movefocus, u"
      "$mainMod, l, movefocus, r"
      "$mainMod, 1, workspace, 1"
      "$mainMod, 2, workspace, 2"
      "$mainMod, 3, workspace, 3"
      "$mainMod, 4, workspace, 4"
      "$mainMod, 5, workspace, 5"
      "$mainMod, 6, workspace, 6"
      "$mainMod, 7, workspace, 7"
      "$mainMod, 8, workspace, 8"
      "$mainMod, 9, workspace, 9"
      "$mainMod, 0, workspace, 10"
      "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
      "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
      "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
      "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
      "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
      "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
      "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
      "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
      "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
      "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
      "$mainMod CTRL, c, movetoworkspace, empty"
      "$mainMod SHIFT, left, movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"
      "$mainMod SHIFT, up, movewindow, u"
      "$mainMod SHIFT, down, movewindow, d"
      "$mainMod SHIFT, h, movewindow, l"
      "$mainMod SHIFT, j, movewindow, d"
      "$mainMod SHIFT, k, movewindow, u"
      "$mainMod SHIFT, l, movewindow, r"
      "$mainMod CTRL, left, resizeactive, -80 0"
      "$mainMod CTRL, right, resizeactive, 80 0"
      "$mainMod CTRL, up, resizeactive, 0 -80"
      "$mainMod CTRL, down, resizeactive, 0 80"
      "$mainMod CTRL, h, resizeactive, -80 0"
      "$mainMod CTRL, j, resizeactive, 0 80"
      "$mainMod CTRL, k, resizeactive, 0 -80"
      "$mainMod CTRL, l, resizeactive, 80 0"
      "$mainMod ALT, left, moveactive,  -80 0"
      "$mainMod ALT, right, moveactive, 80 0"
      "$mainMod ALT, up, moveactive, 0 -80"
      "$mainMod ALT, down, moveactive, 0 80"
      "$mainMod ALT, h, moveactive,  -80 0"
      "$mainMod ALT, j, moveactive, 0 80"
      "$mainMod ALT, k, moveactive, 0 -80"
      # "$mainMod ALT, l, moveactive, 80 0"
      # ",XF86AudioPlay,exec, playerctl play-pause"
      # ",XF86AudioNext,exec, playerctl next"
      # ",XF86AudioPrev,exec, playerctl previous"
      # ",XF86AudioStop,exec, playerctl stop"
      ",XF86MonBrightnessUP,exec, brightness up"
      ",XF86MonBrightnessDown,exec, brightness down"
      "$mainMod, mouse_down, workspace, e-1"
      "$mainMod, mouse_up, workspace, e+1"
      "$mainMod, V, exec, cliphist list | rofi -dmenu -theme-str 'window {width: 50%;}' | cliphist decode | wl-copy"
    ];

    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    windowrule = [
      "float,Viewnior"
      "center,Viewnior"
      "size 1200 800,Viewnior"
      "float,imv"
      "center,imv"
      "size 1200 725,imv"
      "float,mpv"
      "center,mpv"
      "tile,Aseprite"
      "size 1200 725,mpv"
      "float,audacious"
      "pin,rofi"
      "tile, neovide"
      "idleinhibit focus,mpv"
      "float,udiskie"
      "float,title:^(Transmission)$"
      "float,title:^(Volume Control)$"
      "float,title:^(Firefox — Sharing Indicator)$"
      "move 0 0,title:^(Firefox — Sharing Indicator)$"
      "size 700 450,title:^(Volume Control)$"
      "move 40 55%,title:^(Volume Control)$"
    ];

    windowrulev2 = [
      "float, title:^(Picture-in-Picture)$"
      "opacity 1.0 override 1.0 override, title:^(Picture-in-Picture)$"
      "pin, title:^(Picture-in-Picture)$"
      "opacity 1.0 override 1.0 override, title:^(.*imv.*)$"
      "opacity 1.0 override 1.0 override, title:^(.*mpv.*)$"
      "opacity 1.0 override 1.0 override, class:(Aseprite)"
      "opacity 1.0 override 1.0 override, class:(Unity)"
      "opacity 1.0 override 1.0 override, class:(floorp)"
      "opacity 1.0 override 1.0 override, class:(evince)"
      "workspace 1, class:^(floorp)$"
      "workspace 3, class:^(evince)$"
      "workspace 4, class:^(Gimp-2.10)$"
      "workspace 4, class:^(Aseprite)$"
      "workspace 5, class:^(Audacious)$"
      "workspace 5, class:^(Spotify)$"
      "workspace 8, class:^(com.obsproject.Studio)$"
      "workspace 10, class:^(discord)$"
      "workspace 10, class:^(WebCord)$"
      "idleinhibit focus, class:^(mpv)$"
      "idleinhibit fullscreen, class:^(firefox)$"
      "float,class:^(zenity)$"
      "center,class:^(zenity)$"
      "size 850 500,class:^(zenity)$"
      "float,class:^(org.gnome.FileRoller)$"
      "center,class:^(org.gnome.FileRoller)$"
      "size 850 500,class:^(org.gnome.FileRoller)$"
      "size 850 500,title:^(File Upload)$"
      "float,class:^(pavucontrol)$"
      "float,class:^(SoundWireServer)$"
      "float,class:^(.sameboy-wrapped)$"
      "float,class:^(file_progress)$"
      "float,class:^(confirm)$"
      "float,class:^(dialog)$"
      "float,class:^(download)$"
      "float,class:^(notification)$"
      "float,class:^(error)$"
      "float,class:^(confirmreset)$"
      "float,title:^(Open File)$"
      "float,title:^(File Upload)$"
      "float,title:^(branchdialog)$"
      "float,title:^(Confirm to replace files)$"
      "float,title:^(File Operation Progress)$"
      "opacity 0.0 override,class:^(xwaylandvideobridge)$"
      "noanim,class:^(xwaylandvideobridge)$"
      "noinitialfocus,class:^(xwaylandvideobridge)$"
      "maxsize 1 1,class:^(xwaylandvideobridge)$"
      "noblur,class:^(xwaylandvideobridge)$"
    ];

    plugin = {
      hyprbars = {
        bar_height = 20;

        hyprbars-button = [
          {
            color = "rgb(ff4040)";
            size = 10;
            icon = "󰖭";
            action = "hyprctl dispatch killactive";
          }
          {
            color = "rgb(eeee11)";
            size = 10;
            icon = "";
            action = "hyprctl dispatch fullscreen 1";
          }
        ];
      };
    };
  };

  hyprlandConfig = pkgs.writeText "hyprland.conf" (
    toHyprconf {attrs = hyprlandConfigAttrs;}
    + pluginsToHyprconf hpyrPlugins
  );
in
  pkgs.symlinkJoin {
    name = "hyprland-wrapped";
    paths = [pkgs.hyprland];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/Hyprland --add-flags "-c ${hyprlandConfig}"
    '';
  }
