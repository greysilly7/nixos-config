{ den, ... }:
{
  den.schema.host.includes = [ den.aspects.networking ];

  den.aspects.networking = {
    nixos =
      { lib, ... }:
      {
        networking = {
          useNetworkd = lib.mkDefault true;
          networkmanager.enable = lib.mkForce false;
          wireless.iwd.enable = lib.mkDefault true;
          firewall.enable = lib.mkDefault true;
        };

        systemd.network.enable = lib.mkDefault true;

        boot.kernel.sysctl = {
          # Prevent IP spoofing attacks (reverse path filtering)
          "net.ipv4.conf.all.rp_filter" = 1;
          "net.ipv4.conf.default.rp_filter" = 1;

          # Ignore incoming ICMP redirects (prevents MITM routing attacks)
          "net.ipv4.conf.all.accept_redirects" = 0;
          "net.ipv4.conf.default.accept_redirects" = 0;
          "net.ipv6.conf.all.accept_redirects" = 0;
          "net.ipv6.conf.default.accept_redirects" = 0;

          # Ignore ICMP broadcasts to prevent DDoS Smurf attacks
          "net.ipv4.icmp_echo_ignore_broadcasts" = 1;
        };
      };

    persist = {
      directories = [
        "/etc/systemd/network"
        "/var/lib/iwd"
      ];
    };
  };
}
