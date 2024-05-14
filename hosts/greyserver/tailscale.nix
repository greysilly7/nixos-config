{config, ...}: {
  config = {
    services.tailscale = {
      enable = true;
      authKey = config.sops.secrets.tailscale_srv_key.path;

      extraUpFlags = [
        "--ssh"
        "--accept-dns=false"
      ];
    };

    # Tell the firewall to implicitly trust packets routed over Tailscale:
    networking.firewall.trustedInterfaces = ["tailscale0"];
  };
}
