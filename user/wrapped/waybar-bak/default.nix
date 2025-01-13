{
  pkgs,
  theme,
  ...
}: let
  waybarConfig = pkgs.writeText "waybar-config.json" (builtins.toJSON {
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
    modules-center = [
      "clock"
    ];
    modules-right = [
      "cpu"
      "memory"
      "disk"
      "pulseaudio"
      "network"
      "battery"
    ];
    clock = {
      calendar = {
        format = {today = "<span color='#${theme.base0B}'><b>{}</b></span>";};
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
      format = "<span foreground='#${theme.base0B}'> </span> {usage}%";
      format-alt = "<span foreground='#${theme.base0B}'> </span> {avg_frequency} GHz";
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    memory = {
      format = "<span foreground='#${theme.base0C}'>󰟜 </span>{}%";
      format-alt = "<span foreground='#${theme.base0C}'>󰟜 </span>{used} GiB"; # 
      interval = 2;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    disk = {
      # path = "/";
      format = "<span foreground='#${theme.base09}'>󰋊 </span>{percentage_used}%";
      interval = 60;
      on-click-right = "hyprctl dispatch exec '[float; center; size 950 650] kitty --override font_size=14 --title float_kitty btop'";
    };
    network = {
      format-wifi = "<span foreground='#${theme.base0E}'> </span> {signalStrength}%";
      format-ethernet = "<span foreground='#${theme.base0E}'>󰀂 </span>";
      tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
      format-linked = "{ifname} (No IP)";
      format-disconnected = "<span foreground='#${theme.base0E}'>󰖪 </span>";
    };
    tray = {
      icon-size = 20;
      spacing = 8;
    };
    pulseaudio = {
      format = "{icon} {volume}%";
      format-muted = "<span foreground='#${theme.base0D}'> </span> {volume}%";
      format-icons = {
        default = ["<span foreground='#${theme.base0D}'> </span>"];
      };
      scroll-step = 2;
      on-click = "pamixer -t";
    };
    battery = {
      format = "<span foreground='#${theme.base0A}'>{icon}</span> {capacity}%";
      format-icons = [" " " " " " " " " "];
      format-charging = "<span foreground='#${theme.base0A}'> </span>{capacity}%";
      format-full = "<span foreground='#${theme.base0A}'> </span>{capacity}%";
      format-warning = "<span foreground='#${theme.base0A}'> </span>{capacity}%";
      interval = 5;
      states = {
        warning = 20;
      };
      format-time = "{H}h{M}m";
      tooltip = true;
      tooltip-format = "{time}";
    };
    "custom/launcher" = {
      format = "";
      on-click = "rofi -show drun";
      on-click-right = "wallpaper-picker";
      tooltip = "false";
    };
  });

  css = pkgs.writeText "styles.css" ''
    * {
       border: none;
       border-radius: 0px;
       padding: 0;
       margin: 0;
       font-family: JetBrainsMono Nerd Font;
       font-weight: bold;
       opacity: 1;
       font-size: 18px;
     }

     window#waybar {
       background: #${theme.base01};
       border-top: 1px solid #${theme.base03};
     }

     tooltip {
       background: #${theme.base01};
       border: 1px solid #${theme.base03};
     }
     tooltip label {
       margin: 5px;
       color: #${theme.base05};
     }

     #workspaces {
       padding-left: 15px;
     }
     #workspaces button {
       color: #${theme.base0A};
       padding-left:  5px;
       padding-right: 5px;
       margin-right: 10px;
     }
     #workspaces button.empty {
       color: #${theme.base05};
     }
     #workspaces button.active {
       color: #${theme.base09};
     }

     #clock {
       color: #${theme.base05};
     }

     #tray {
       margin-left: 10px;
       color: #${theme.base05};
     }
     #tray menu {
       background: #${theme.base01};
       border: 1px solid #${theme.base03};
       padding: 8px;
     }
     #tray menuitem {
       padding: 1px;
     }

     #pulseaudio, #network, #cpu, #memory, #disk, #battery, #custom-notification {
       padding-left: 5px;
       padding-right: 5px;
       margin-right: 10px;
       color: #${theme.base05};
     }

     #pulseaudio {
       margin-left: 15px;
     }

     #custom-notification {
       margin-left: 15px;
       padding-right: 2px;
       margin-right: 5px;
     }

     #custom-launcher {
       font-size: 20px;
       color: #${theme.base05};
       font-weight: bold;
       margin-left: 15px;
       padding-right: 10px;
     }
  '';
in
  pkgs.symlinkJoin {
    name = "waybar-wrapped";
    paths = [pkgs.waybar];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/waybar --add-flags "-c ${waybarConfig} -s ${css}"
    '';
  }
