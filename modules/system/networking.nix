{
  config,
  lib,
  pkgs,
  ...
}: {
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        macAddress = "random";
        powersave = true;
      };
    };
    firewall = {
      enable = true;
      allowPing = false;
      logReversePathDrops = true;
    };
  };

  # Tailscale
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };

  # Tailscale Auto-Connect Service
  systemd.services.tailscale-autoconnect = {
    description = "Automatic connection to Tailscale";

    # Ensure tailscale is running before trying to connect
    after = ["network-pre.target" "tailscale.service"];
    wants = ["network-pre.target" "tailscale.service"];
    wantedBy = ["graphical.target"];

    # Set this service as a oneshot job
    serviceConfig.Type = "oneshot";

    # Run this shell script
    script = ''
      # Wait for tailscaled to settle
      sleep 2

      # Check if we are already authenticated to tailscale
      status="$(${lib.getExe pkgs.tailscale} status -json | ${lib.getExe pkgs.jq} -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi

      # Otherwise authenticate with tailscale
      ${lib.getExe pkgs.tailscale} up -authkey file://${config.sops.secrets.ts_key.path} --accept-routes --exit-node=
    '';
  };

  systemd.services = {
    NetworkManager-wait-online.enable = false;
    wait-online.enable = false;
    systemd-networkd.stopIfChanged = false;
    systemd-resolved.stopIfChanged = false;
  };

  services.openssh.enable = true;
}
