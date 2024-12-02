{
  pkgs,
  config,
  lib,
  ...
}: {
  networking = {
    nameservers = lib.mkForce ["127.0.0.1" "::1"];
    dhcpcd.extraConfig = "nohook resolv.conf";
    networkmanager = {
      enable = true;
      unmanaged = ["docker0"];
      dns = lib.mkForce "none";
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

  # encrypted dns
  services.dnscrypt-proxy2 = {
    enable = true;
    settings = {
      require_dnssec = true;

      sources = {
        public-resolvers = {
          urls = [
            "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
            "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
          ];
          cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 72;
        };
        odoh-servers = {
          urls = ["https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/relays.md" "https://download.dnscrypt.info/resolvers-list/v3/relays.md"];
          cache_file = "/var/lib/dnscrypt-proxy2/relays.md";
          minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
          refresh_delay = 72;
        };
      };
    };
  };

  services.tailscale.enable = true;

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
    script = ''
      # Wait for tailscaled to settle
      sleep 2

      # Check if we are already authenticated to tailscale
      status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
      if [ $status = "Running" ]; then
        exit 0
      fi

      # Otherwise authenticate with tailscale
      ${pkgs.tailscale}/bin/tailscale up -authkey file://${config.sops.secrets.ts_laptop_key.path} --accept-routes
    '';
  };

  # slows down boot time
  systemd.services.NetworkManager-wait-online.enable = false;

  services.openssh.enable = true;
}
