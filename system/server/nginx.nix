{
  config,
  inputs,
  pkgs,
  ...
}: {
  config = {
    services.nginx = {
      enable = true; # Enable Nginx service
      package = pkgs.angieQuic.override {openssl = pkgs.libressl;}; # Use Angie with QUIC support and LibreSSL

      # Recommended settings for Nginx
      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;

      enableQuicBPF = true; # Enable QUIC BPF support

      clientMaxBodySize = "100M"; # Set max body size to 100M

      statusPage = true; # Enable the status page

      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL"; # Only allow PFS-enabled ciphers with AES256

      appendHttpConfig = ''
        # Add HSTS header with preloading to HTTPS requests.
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Minimize information leaked to other domains
        add_header 'Referrer-Policy' 'origin-when-cross-origin';

        # Disable embedding as a frame
        add_header X-Frame-Options DENY;

        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;

        # This might create errors
        proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      '';

      # Virtual host configuration for greysilly7.xyz
      virtualHosts."greysilly7.xyz" = {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        http3 = true;
        root = "${inputs.greysilly7-xyz}";

        locations."/.well-known/spacebar" = {
          extraConfig = ''
            more_set_headers 'Access-Control-Allow-Origin: *';
            default_type application/json;
            return 200 '{"api": "https://spacebar.greysilly7.xyz/api/v9"}';
          '';
        };
      };

      # Virtual host configuration for vaultwarden.greysilly7.xyz
      virtualHosts."vaultwarden.greysilly7.xyz" = {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        http3 = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT}";
          proxyWebsockets = true;
        };
      };
    };

    security.acme = {
      acceptTerms = true; # Accept ACME terms
      defaults.email = "greysilly7@gmail.com"; # Set email for ACME
    };

    # Open Firewall for HTTP and HTTPS
    networking.firewall.allowedTCPPorts = [80 443];
    networking.firewall.allowedUDPPorts = [443];
  };
}
