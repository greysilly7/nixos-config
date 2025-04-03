{
  pkgs,
  theme,
}: let
  mod = "Super";
  # credits: fufexan
  # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
  workspaces = builtins.concatLists (builtins.genList (
      x: let
        ws = let
          c = (x + 1) / 10;
        in
          builtins.toString (x + 1 - (c * 10));
      in [
        "${mod}, ${ws}, workspace, ${toString (x + 1)}"
        "${mod} SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
      ]
    )
    10);
in {
  plugin = "${pkgs.hyprlandPlugins.hy3}/lib/libhy3.so";

  env = [
    "QT_WAYLAND_DISABLE_WINDOWDECORATION,1"
  ];

  exec-once = [
    "uwsm app -- udiskie"
    "uwsm app -- wl-clip-persist --clipboard both"
    "uwsm app -- wl-paste --type text --watch cliphist store"
    "uwsm app -- wl-paste --type image --watch cliphist store"

    "uwsm app -- nm-applet"
    "uwsm app -- poweralertd"

    "uwsm app -- waybar"
    "uwsm app -- mako "

    "uwsm app -- hyprpaper "
    "uwsm app -- hyprsunset -t 4000"
    # "systemctl --user start hyprpolkitagent &"
    "uwsm app -- hyprlock"
    "uwsm app -- hypridle"
  ];

  monitor = ", preferred, auto, 1";

  input = {
    kb_layout = "us";
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
    layout = "master";
    gaps_in = 5;
    gaps_out = 5;
    border_size = 1;

    "col.active_border" = "rgb(${theme.base0B})";
    "col.inactive_border" = "0x00000000";

    allow_tearing = true;
    resize_on_border = true;
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
    vrr = 1;
  };

  dwindle = {
    pseudotile = true;
    preserve_split = true;
  };

  master = {
    new_status = "master";
    special_scale_factor = 1;
  };

  xwayland.force_zero_scaling = true;

  debug.disable_logs = false;

  decoration = {
    rounding = 0;
    shadow.enabled = false;
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
  };

  bindl = [
    # media controls
    ", XF86AudioPlay, exec, playerctl play-pause"
    ", XF86AudioPrev, exec, playerctl previous"
    ", XF86AudioNext, exec, playerctl next"

    # volume
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
  ];
  bindr = [
    # launcher
    "${mod}, Space, exec, rofi -show drun -show-icons -run-command \"uwsm app -- {cmd}\""
    ", XF86Search, exec, rofi -show drun -show-icons -run-command \"uwsm app -- {cmd}\""
  ];

  bindle = [
    # volume
    ", XF86AudioRaiseVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume -l '1.0' @DEFAULT_AUDIO_SINK@ 6%-"

    # backlight
    ", keyboard:74, exec, brillo -q -A 5"
    ", keyboard:73, exec, brillo -q -U 5"
  ];

  bind =
    [
      "${mod}, minus, killactive"
      "${mod}, F, fullscreen,"
      "${mod}, G, togglegroup,"
      "${mod} SHIFT, N, changegroupactive, f"
      "${mod} SHIFT, P, changegroupactive, b"
      "${mod}, R, togglesplit,"
      "${mod}, T, togglefloating,"
      "${mod}, P, pseudo,"
      "${mod} ALT, ,resizeactive,"

      "${mod}, Return, exec, kitty"
      "${mod} SHIFT, Return, exec, [fullscreen] uwsm app -- kitty"
      "${mod} SHIFT, L, exec, loginctl lock-session"

      "${mod}, h, movefocus, l"
      "${mod}, l, movefocus, r"
      "${mod}, k, movefocus, u"
      "${mod}, j, movefocus, d"

      "${mod}, PRINT, exec, uwsm app -- hyprshot -m window"
      ", PRINT, exec, uwsm app --hyprshot -m output"
      "SHIFT, PRINT, exec, uwsm app -- hyprshot -m region"

      "${mod}, bracketleft, workspace, m-1"
      "${mod}, bracketright, workspace, m+1"

      "${mod} SHIFT, bracketleft, focusmonitor, l"
      "${mod} SHIFT, bracketright, focusmonitor, r"
    ]
    ++ workspaces;

  layerrule = [
    "blur, rofi"
    " ignorealpha 0.6, rofi"
  ];
  windowrulev2 = [
    "workspace 2, class:(firefox|librewolf|brave)"
    "workspace 4 silent, class:(signal|vesktop)"
    "suppressevent maximize, class:.*"
    #"scrolltouchpad 0.1, class:^(zen|firefox|brave|chromium-browser|chrome-.*)$"
    "nofocus,class:^$,title:^$,xwayland:1,floating:1,fullscreen:0,pinned:0"
  ];
}
