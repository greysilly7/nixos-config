{
  pkgs,
  theme,
  ...
}: let
  rofiTheme = pkgs.writeText "theme.rasi" ''
    * {
        bg-col:  #1e1e2e;
        bg-col-light: #1e1e2e;
        border-col: #1e1e2e;
        selected-col: #1e1e2e;
        blue: #89b4fa;
        fg-col: #cdd6f4;
        fg-col2: #f38ba8;
        grey: #6c7086;

        width: 600;
        font: "JetBrainsMono Nerd Font 14";
    }

    element-text, element-icon , mode-switcher {
        background-color: inherit;
        text-color:       inherit;
    }

    window {
        height: 360px;
        border: 3px;
        border-color: @border-col;
        background-color: @bg-col;
    }

    mainbox {
        background-color: @bg-col;
    }

    inputbar {
        children: [prompt,entry];
        background-color: @bg-col;
        border-radius: 5px;
        padding: 2px;
    }

    prompt {
        background-color: @blue;
        padding: 6px;
        text-color: @bg-col;
        border-radius: 3px;
        margin: 20px 0px 0px 20px;
    }

    textbox-prompt-colon {
        expand: false;
        str: ":";
    }

    entry {
        padding: 6px;
        margin: 20px 0px 0px 10px;
        text-color: @fg-col;
        background-color: @bg-col;
    }

    listview {
        border: 0px 0px 0px;
        padding: 6px 0px 0px;
        margin: 10px 0px 0px 20px;
        columns: 2;
        lines: 5;
        background-color: @bg-col;
    }

    element {
        padding: 5px;
        background-color: @bg-col;
        text-color: @fg-col  ;
    }

    element-icon {
        size: 25px;
    }

    element selected {
        background-color:  @selected-col ;
        text-color: @fg-col2  ;
    }

    mode-switcher {
        spacing: 0;
      }

    button {
        padding: 10px;
        background-color: @bg-col-light;
        text-color: @grey;
        vertical-align: 0.5;
        horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @blue;
    }

    message {
        background-color: @bg-col-light;
        margin: 2px;
        padding: 2px;
        border-radius: 5px;
    }

    textbox {
        padding: 6px;
        margin: 20px 0px 0px 20px;
        text-color: @blue;
        background-color: @bg-col-light;
    }
  '';
  rofiConfig = pkgs.writeText "config.rasi" ''
    configuration {
      modi: "run,drun,window";
      lines: 5;
      cycle: false;
      font: "JetBrainsMono NF Bold 15";
      show-icons: true;
      icon-theme: "Papirus-dark";
      terminal: "kitty";
      drun-display-format: "{icon} {name}";
      location: 0;
      disable-history: true;
      hide-scrollbar: true;
      display-drun: " Apps ";
      display-run: " Run ";
      display-window: " Window ";
      /* display-Network: " Network"; */
      sidebar-mode: true;
      sorting-method: "fzf";
    }

    @theme "theme"

    element-text, element-icon , mode-switcher {
      background-color: inherit;
      text-color: inherit;
    }

    window {
      height: 480px;
      width: 400px;
      border: 3px;
      border-color: @border-col;
      background-color: @bg-col;
    }

    mainbox {
      background-color: @bg-col;
    }

    inputbar {
      children: [prompt,entry];
      background-color: @bg-col-light;
      border-radius: 5px;
      padding: 0px;
    }

    prompt {
      background-color: @green;
      padding: 4px;
      text-color: @bg-col-light;
      border-radius: 3px;
      margin: 10px 0px 10px 10px;
    }

    textbox-prompt-colon {
      expand: false;
      str: ":";
    }

    entry {
      padding: 6px;
      margin: 10px 10px 10px 5px;
      text-color: @fg-col;
      background-color: @bg-col;
      border-radius: 3px;
    }

    listview {
      border: 0px 0px 0px;
      padding: 6px 0px 0px;
      margin: 10px 0px 0px 6px;
      columns: 1;
      background-color: @bg-col;
      cycle: true;
    }

    element {
      padding: 8px;
      margin: 0px 10px 4px 4px;
      background-color: @bg-col;
      text-color: @fg-col;
    }

    element-icon {
      size: 28px;
    }

    element selected {
      background-color: @selected-col;
      text-color: @fg-col2;
      border-radius: 3px;
    }

    mode-switcher {
      spacing: 0;
    }

    button {
      padding: 10px;
      background-color: @bg-col-light;
      text-color: @grey;
      vertical-align: 0.5;
      horizontal-align: 0.5;
    }

    button selected {
      background-color: @bg-col;
      text-color: @green;
    }
  '';
in
  pkgs.symlinkJoin {
    name = "rofi-wrapped";
    paths = [pkgs.rofi-wayland];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/rofi --add-flags "--config ${rofiConfig} --theme ${rofiTheme}";
    '';
  }
