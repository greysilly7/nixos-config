{...}: {
  config = {
    services.tabby = {
      enable = true;
    };

    # Open Firewall for HTTP and HTTPS
    networking.firewall.allowedTCPPorts = [11029];
    networking.firewall.allowedUDPPorts = [11029];
  };
}
