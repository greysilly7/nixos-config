{pkgs, ...}: {
  config = {
    services.adguardhome = {
      enable = true;
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
          dhcp.enabled = false;
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
      };
    };
    networking.firewall.allowedTCPPorts = [3000 5353];
    networking.firewall.allowedUDPPorts = [3000 5353];
  };
}
