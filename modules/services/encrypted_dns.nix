{pkgs, ...}: {
  config = {
    # Tell network manager to not manage DNS
    networking = {
      nameservers = ["127.0.0.1" "::1"];
      networkmanager.dns = "none";
    };

    services.dnscrypt-proxy2 = {
      enable = true;
      ipv6_servers = true;
      require_dnssec = true;

      sources.public-resolvers = {
        urls = [
          "https://raw.githubusercontent.com/DNSCrypt/dnscrypt-resolvers/master/v3/public-resolvers.md"
          "https://download.dnscrypt.info/resolvers-list/v3/public-resolvers.md"
        ];
        cache_file = "/var/lib/dnscrypt-proxy2/public-resolvers.md";
        minisign_key = "RWQf6LRCGA9i53mlYecO4IzT51TGPpvWucNSCh1CBM0QTaLn73Y7GFO3";
      };

      # Use the Cloudflare DNS server
      server_names = ["cloudflare" "cloudflare-ipv6"];
    };

    systemd.services.dnscrypt-proxy2.serviceConfig = {
      StateDirectory = "dnscrypt-proxy";
    };
  };
}
