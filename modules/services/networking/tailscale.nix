_: {
  den.aspects.tailscale = {
    nixos =
      { config, ... }:
      {
        services.tailscale.enable = true;
        services.tailscale.authKeyFile = config.sops.secrets.tailscale_authkey.path;
        sops.secrets.tailscale_authkey = { };
      };
  };
}
