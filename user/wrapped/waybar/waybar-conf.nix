{
  pkgs,
  theme,
  ...
}: let
  settings = {
    position = "bottom";
    layer = "top";
    height = 28;
    margin-top = 0;
    margin-bottom = 0;
    margin-left = 0;
    margin-right = 0;
    modules-left = [
      "custom/launcher"
      "hyprland/workspaces"
      "tray"
    ];
    modules-center = ["clock"];
    modules-right = [
      "cpu"
      "memory"
      "disk"
      "pulseaudio"
      "network"
      "backlight"
      "battery"
      "hyprland/language"
      # "custom/notification"
    ];
    clock = {
      calendar = {
        format = {
          today = "<span color='#${theme.base05}'><b>{}</b></span>";
        };
      };
      format = "  {:%H:%M}";
      tooltip = "true";
      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      format-alt = "  {:%d/%m}";
    };
    "hyprland/workspaces" = {
      active-only = false;
      disable-scroll = true;
      format = "{icon}";
      on-click = "activate";
      format-icons = {
        "1" = "I";
        "2" = "II";
        "3" = "III";
        "4" = "IV";
        "5" = "V";
        "6" = "VI";
        "7" = "VII";
        "8" = "VIII";
        "9" = "IX";
        "10" = "X";
        sort-by-number = true;
      };
      persistent-workspaces = {
        "1" = [];
        "2" = [];
        "3" = [];
        "4" = [];
        "5" = [];
      };
    };
    cpu = {
      format = "<span foreground='#${theme.base05}'> </span> {usage}%";
      format-alt = "<span foreground='#${theme.base05}'> </span> {avg_frequency} GHz";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    memory = {
      format = "<span foreground='#${theme.base09}'>󰟜 </span>{}%";
      format-alt = "<span foreground='#${theme.base09}'>󰟜 </span>{used} GiB"; # 
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    disk = {
      # path = "/";
      format = "<span foreground='#${theme.base0A}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    network = {
      format-wifi = "<span foreground='#${theme.base08}'> </span> {signalStrength}%";
      format-ethernet = "<span foreground='#${theme.base08}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "<span foreground='#${theme.base08}'>󰖪 </span>";
    };
    backlight = {
      format = "{icon} {percent}%";
      format-icons = ["" "" "" "" "" "" "" "" ""];
    };

    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='#${theme.base07}'> </span> {volume}%";
      format-icons = {
        default = ["<span foreground='#${theme.base07}'> </span>"];
      };
      scroll-step = 2;
      on-click = "pamixer -t";
      on-click-right = "pavucontrol";
    };
    battery = {
      format = "<span foreground='#${theme.base06}'>{icon}</span> {capacity}%";
      format-icons = [
        " "
        " "
        " "
        " "
        " "
      ];
      format-charging = "<span foreground='#${theme.base06}'> </span>{capacity}%";
      format-full = "<span foreground='#${theme.base06}'> </span>{capacity}%";
      format-warning = "<span foreground='#${theme.base06}'> </span>{capacity}%";
      interval = 5;
      states = {
        warning = 20;
      };
      format-time = "{H}h{M}m";
      tooltip = true;
      tooltip-format = "{time}";
    };
    "hyprland/language" = {
      format = "<span foreground='#${theme.base06}'> </span> {}";
      format-fr = "FR";
      format-en = "US";
    };
    "custom/launcher" = {
      format = "";
      on-click = "random-wallpaper";
      on-click-right = "rofi -show drun";
      tooltip = "true";
      tooltip-format = "Random Wallpaper";
    };
    /*
    "custom/notification" = {
      tooltip = false;
      format = "{icon} ";
      format-icons = {
        notification = "<span foreground='red'><sup></sup></span>  <span foreground='#${theme.base04}'></span>";
        none = "  <span foreground='#${theme.base04}'></span>";
        dnd-notification = "<span foreground='red'><sup></sup></span>  <span foreground='#${theme.base04}'></span>";
        dnd-none = "  <span foreground='#${theme.base04}'></span>";
        inhibited-notification = "<span foreground='red'><sup></sup></span>  <span foreground='#${theme.base04}'></span>";
        inhibited-none = "  <span foreground='#${theme.base04}'></span>";
        dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>  <span foreground='#${theme.base04}'></span>";
        dnd-inhibited-none = "  <span foreground='#${theme.base04}'></span>";
      };
      return-type = "json";
      exec-if = "which swaync-client";
      exec = "swaync-client -swb";
      on-click = "swaync-client -t -sw";
      on-click-right = "swaync-client -d -sw";
      escape = true;
    };
    */
  };
in
  pkgs.writeText "waybar-config.json" (builtins.toJSON settings)
