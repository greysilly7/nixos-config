_: {
  den.aspects.aerospace = {
    darwin = _: {
      services.jankyborders = {
        enable = true;
        active_color = "gradient(top_left=0xfff5bde6,bottom_right=0xffc6a0f6)";
        inactive_color = "0xff494d64";
        width = 4.0;
      };

      services.aerospace = {
        enable = true;
        settings = {
          # Notify Sketchybar of workspace€ changes
          exec-on-workspace-change = [
            "bash"
            "-c"
            "sketchybar --trigger aerospace_workspace_change FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE"
          ];

          # Default root container layout
          default-root-container-layout = "tiles";

          # Gaps around windows
          gaps = {
            outer.left = 14;
            outer.bottom = 4;
            outer.top = 16; # 16 (visual gap below native menu bar)
            outer.right = 14;
            inner.horizontal = 14;
            inner.vertical = 14;
          };

          # Sensible modifier binds (Option/Alt)
          mode.main.binding = {
            # Focus windows
            "alt-h" = "focus left";
            "alt-j" = "focus down";
            "alt-k" = "focus up";
            "alt-l" = "focus right";

            # Move windows
            "alt-shift-h" = "move left";
            "alt-shift-j" = "move down";
            "alt-shift-k" = "move up";
            "alt-shift-l" = "move right";

            # Workspace bindings
            "alt-1" = "workspace 1";
            "alt-2" = "workspace 2";
            "alt-3" = "workspace 3";
            "alt-4" = "workspace 4";
            "alt-5" = "workspace 5";

            "alt-shift-1" = "move-node-to-workspace 1";
            "alt-shift-2" = "move-node-to-workspace 2";
            "alt-shift-3" = "move-node-to-workspace 3";
            "alt-shift-4" = "move-node-to-workspace 4";
            "alt-shift-5" = "move-node-to-workspace 5";

            # Layout controls
            "alt-f" = "layout floating tiling";
            "alt-v" = "layout tiles horizontal vertical";
            "alt-e" = "layout tiles accordion";

            # Reload
            "alt-shift-r" = "reload-config";
          };

          on-window-detected = [
            {
              "if".app-id = "org.nixos.librewolf";
              run = "move-node-to-workspace 1";
            }
            {
              "if".app-id = "com.google.antigravity";
              run = "move-node-to-workspace 2";
            }
            {
              "if".app-id = "org.equicord.equibop";
              run = "move-node-to-workspace 3";
            }
            {
              "if".app-id = "com.apple.systempreferences";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.ActivityMonitor";
              run = "layout floating";
            }
            {
              "if".app-id = "com.apple.finder";
              run = "layout floating";
            }
            {
              "if".app-id = "com.1password.1password";
              run = "layout floating";
            }
            {
              "if".app-name-regex-substring = "(?i)bettershot";
              run = "layout floating";
            }
          ];
        };
      };
    };
  };
}
