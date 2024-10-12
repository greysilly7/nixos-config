{
  inputs,
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./disko.nix
  ];

  home-manager.users.greysilly7 = {
    imports = [
      ../../homes/greysilly7_greypersonal
    ];
  };

  sops.age = {
    sshKeyPaths = [
      "/persist/etc/ssh/ssh_host_ed25519_key"
    ];
    keyFile = "/persist/var/lib/sops-nix/key.txt";
  };

  # KDE Configuration
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
  services.displayManager.sddm.wayland.enable = true;

  # Power and Firmware Services
  services.power-profiles-daemon.enable = false;
  services.fwupd.enable = true; # Enable fwupd service

  # CPU Frequency Management
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # Bluetooth Configuration
  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluez5-experimental;
  };

  # Tailscale Auto-Connect Service
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # Ensure tailscale is running before trying to connect
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["multi-user.target"];

    # Set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # Run this shell script
    script = with pkgs; ''
      # Wait for tailscaled to settle
      sleep 2

      # Check if we are already authenticated to tailscale
      status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi

      # Otherwise authenticate with tailscale
      ${tailscale}/bin/tailscale up -authkey file://${config.sops.secrets.ts_laptop_key.path}
    '';
  };
}
