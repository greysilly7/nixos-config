{...}: {
  config = {
    services.tailscale = {
      enable = true;

      extraUpFlags = [
        "--ssh"
      ];
    };

    # Tell the firewall to implicitly trust packets routed over Tailscale:
    networking.firewall.trustedInterfaces = ["tailscale0"];
  };
}
