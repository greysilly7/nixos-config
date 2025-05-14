{
  pkgs,
  theme,
}:
pkgs.writeText "style.css" ''
  * {
        border: none;
        border-radius: 0px;
        padding: 0;
        margin: 0;
        font-family: "JetBrains Mono Nerd Font";
        font-weight: bold;
        opacity: 1;
        font-size: 18px;
      }

      window#waybar {
        background: #${theme.base01};
        border-top: 1px solid #${theme.base02};
      }

      tooltip {
        background: #${theme.base01};
        border: 1px solid #${theme.base02};
      }
      tooltip label {
        margin: 5px;
        color: #${theme.base03};
      }

      #workspaces {
        padding-left: 15px;
      }
      #workspaces button {
        color: #${theme.base06};
        padding-left:  5px;
        padding-right: 5px;
        margin-right: 10px;
      }
      #workspaces button.empty {
        color: #${theme.base03};
      }
      #workspaces button.active {
        color: #${theme.base0B};
      }

      #clock {
        color: #${theme.base03};
      }

      #tray {
        margin-left: 10px;
        color: #${theme.base03};
      }
      #tray menu {
        background: #${theme.base01};
        border: 1px solid #${theme.base02};
        padding: 8px;
      }
      #tray menuitem {
        padding: 1px;
      }

      #pulseaudio, #network, #cpu, #memory, #disk, #battery, #language, #custom-notification, #custom-lock {
        padding-left: 5px;
        padding-right: 5px;
        margin-right: 10px;
        color: #${theme.base03};
      }

      #pulseaudio, #language {
        margin-left: 15px;
      }

      #custom-notification {
        margin-left: 15px;
        padding-right: 2px;
        margin-right: 5px;
      }

      #custom-launcher {
        font-size: 20px;
        color: #${theme.base03};
        font-weight: bold;
        margin-left: 15px;
        padding-right: 10px;
      }
''
