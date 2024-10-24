{lib, ...}: {
  networking = {
    # Tell NetworkManager to not manage DNS
    # nameservers = lib.mkForce ["127.0.0.1" "::1"];
    networkmanager = {
      enable = true;
      unmanaged = ["docker0" "rndis0"];
      # dns = lib.mkForce "none";
      wifi = {
        macAddress = "random";
        powersave = true;
      };
    };
    firewall = {
      allowPing = false;
      enable = true;
      logReversePathDrops = true;
    };
  };

  services.dnscrypt-proxy2 = {
    enable = false;
    settings = {
      ipv4_servers = true;
      ipv6_servers = true;
      require_dnssec = true;
      require_nofilter = true;
      require_nolog = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # Use the Cloudflare DNS server
      server_names = [];
    };
  };

  systemd.services.dnscrypt-proxy2.serviceConfig = {
    StateDirectory = "dnscrypt-proxy";
  };

  systemd.services.NetworkManager-wait-online.enable = false;
}
