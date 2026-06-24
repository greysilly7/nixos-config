{ den, ... }:
{
  den.aspects.tailscale = {
    nixos =
      { config, ... }:
      {
        services.tailscale = {
          enable = true;
          authKeyFile = config.sops.secrets.tailscale_authkey.path;
          extraUpFlags = [ "--ssh" ];
        };
        sops.secrets.tailscale_authkey = { };

        # Trust the Tailscale interface for all incoming traffic
        networking.firewall.trustedInterfaces = [ "tailscale0" ];
        # Allow Tailscale routing to work correctly
        networking.firewall.checkReversePath = "loose";
        # Secure OpenSSH by closing public firewall access (requires connecting via Tailscale)
        services.openssh.openFirewall = false;
      };

    _.server = {
      includes = [ den.aspects.tailscale ];
      nixos = {
        services.tailscale.extraUpFlags = [ "--advertise-tags=tag:server" ];
      };
    };
  };
}
