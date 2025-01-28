{
  flake,
  pkgs,
  config,
  ...
}: {
  sops.secrets.grey_pass.neededForUsers = true;
  users = {
    mutableUsers = false;
    users = {
      root.password = "temp";
      greysilly7 = {
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "systemd-journal"
          "audio"
          "video"
          "input"
          "lp"
          "networkmanager"
          "power"
          "nix"
          "adbusers"
          "libvirtd"
          "wireshark"
        ];
        homix = true;
        # shell = flake.packages.${pkgs.system}.zsh;
        shell = pkgs.bash;
        hashedPasswordFile = config.sops.secrets.grey_pass.path;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMAUXpvCORVoy/X8nGp2dgrgpa50sAPv5IeQeTzjb5KR greysilly7@gmail.com"
        ];
      };
    };
  };

  security = {
    sudo = {
      enable = true;
      extraRules = [
        {
          commands =
            builtins.map (command: {
              command = "/run/current-system/sw/bin/${command}";
              options = ["NOPASSWD"];
            })
            ["poweroff" "reboot" "nixos-rebuild" "nix-env" "bandwhich" "systemctl"];
          groups = ["wheel"];
        }
      ];
    };

    pam = {
      services = {
        login = {
          enableGnomeKeyring = true;
        };
        sudo.fprintAuth = true;
        swaylock.fprintAuth = true;
        hyprlock = {};
      };

      loginLimits = [
        {
          domain = "@wheel";
          item = "nofile";
          type = "soft";
          value = "524288";
        }
        {
          domain = "@wheel";
          item = "nofile";
          type = "hard";
          value = "1048576";
        }
      ];
    };
  };
}
