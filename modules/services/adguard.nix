{pkgs, ...}: {
  config = {
    services.adguardhome = {
      enable = true;
      mutableSettings = false;
      host = "0.0.0.0";
      port = 3000;

      settings = {
        dns = {
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
    networking.firewall.allowedTCPPorts = [3000];
    networking.firewall.allowedUDPPorts = [3000];
  };
}
