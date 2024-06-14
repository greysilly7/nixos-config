{pkgs, ...}: {
  config = {
    services.adguardhome = {
      enable = false;
      mutableSettings = false;

      settings = {
        http = {
          address = "127.0.0.1:3000";
        };

        dns = {
          port = 5353;
          ratelimit = 60;
          upstream_dns = [
            "1.0.0.1"
            "1.1.1.1"
          ];
          bootstrap_dns = [
            "1.1.1.1"
            "1.0.0.1"
          ];
          enable_dnssec = true;
        };
        filters = [
          {
            name = "AdGuard DNS filter";
            url = "https://adguardteam.github.io/AdGuardSDNSFilter/Filters/filter.txt";
            enabled = true;
          }
          {
            name = "AdAway Default Blocklist";
            url = "https://adaway.org/hosts.txt";
            enabled = true;
          }
          {
            name = "OISD (Big)";
            url = "https://big.oisd.nl";
            enabled = true;
          }
        ];
        tls = {
          enabled = true;
          server_name = "adgaurdhome.greysilly7.xyz";
          port_https = 0;
          allow_unencrypted_doh = true;
        };
      };
    };
    networking.firewall.allowedTCPPorts = [3000 853 5353];
    networking.firewall.allowedUDPPorts = [3000 853 5353];
  };
}
