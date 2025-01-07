{pkgs, ...}: let
  hypridleConfig = pkgs.writeText "hypridle.conf" ''
    general {
        lock_cmd = pidof hyprlock || hyprlock;       # avoid starting multiple hyprlock instances.
        before_sleep_cmd = loginctl lock-session;    # lock before suspend.
        after_sleep_cmd = hyprctl dispatch dpms on;  # to avoid having to press a key twice to turn on the display.
    }

    listener {
        timeout = 60;                                # 1min
        on-timeout = brightnessctl -s set 10;        # set monitor backlight to minimum, avoid 0 on OLED monitor.
        on-resume = brightnessctl -r;                # monitor backlight restore.
    }

    # turn off keyboard backlight, comment out this section if you don't have a keyboard backlight.
    listener {
        timeout = 60;                                          # 1min
        on-timeout = brightnessctl -sd rgb:kbd_backlight set 0; # turn off keyboard backlight.
        on-resume = brightnessctl -rd rgb:kbd_backlight;        # turn on keyboard backlight.
    }

    listener {
        timeout = 240;                               # 4min
        on-timeout = loginctl lock-session;          # lock screen when timeout has passed
    }

    listener {
        timeout = 270;                               # 4.5min
        on-timeout = hyprctl dispatch dpms off;      # screen off when timeout has passed
        on-resume = hyprctl dispatch dpms on;        # screen on when activity is detected after timeout has fired.
    }

    listener {
        timeout = 300;                               # 5min
        on-timeout = systemctl suspend;              # suspend pc
    }
  '';
in
  pkgs.symlinkJoin {
    name = "hypridle-wrapped";
    paths = [pkgs.hypridle];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/hypridle --add-flags "-c ${hypridleConfig}"
    '';
  }
