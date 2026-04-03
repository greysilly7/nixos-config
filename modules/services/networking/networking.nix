{ den, ... }:
{
  den.ctx.host.includes = [ den.aspects.networking ];

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
      };

    persist = {
      directories = [
        "/etc/systemd/network"
        "/var/lib/iwd"
      ];
    };
  };
}
