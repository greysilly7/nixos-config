{...}: {
  config = {
    services.tabby = {
      enable = true;
      port = 11029;
    };

    # Open Firewall for HTTP and HTTPS
    networking.firewall.allowedTCPPorts = [11029];
    networking.firewall.allowedUDPPorts = [11029];
  };
}
