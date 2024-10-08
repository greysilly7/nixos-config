{
  config,
  inputs,
  pkgs,
  ...
}: {
  config = {
    services.nginx = {
      enable = true;
      package = pkgs.angieQuic.override {openssl = pkgs.libressl;};

      recommendedTlsSettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      recommendedProxySettings = true;
      recommendedZstdSettings = true;
      # Enable QUiC support
      enableQuicBPF = true;

      # Set Max Body Size to 100M
      clientMaxBodySize = "100M";

      # Enable the status page
      statusPage = true;

      # Only allow PFS-enabled ciphers with AES256
      sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";

      appendHttpConfig = ''
        # Add HSTS header with preloading to HTTPS requests.
        # Adding this header to HTTP requests is discouraged
        map $scheme $hsts_header {
            https   "max-age=31536000; includeSubdomains; preload";
        }
        add_header Strict-Transport-Security $hsts_header;

        # Enable CSP for your services.
        #add_header Content-Security-Policy "script-src 'self'; object-src 'none'; base-uri 'none';" always;

        # Minimize information leaked to other domains
        add_header 'Referrer-Policy' 'origin-when-cross-origin';

        # Disable embedding as a frame
        add_header X-Frame-Options DENY;

        # Prevent injection of code in other mime types (XSS Attacks)
        add_header X-Content-Type-Options nosniff;

        # This might create errors
        proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
      '';

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
      /*
      virtualHosts."adgaurdhome.greysilly7.xyz" = {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        http3 = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
          basicAuthFile = config.sops.secrets.adguardhomewebpass.path;
        };
        locations."/dns-query" = {
          proxyPass = "http://127.0.0.1:853/dns-query";
        };
      };
      */
    };
    security.acme = {
      acceptTerms = true;
      defaults.email = "greysilly7@gmail.com";
    };

    # Open Firewall for HTTP and HTTPS
    networking.firewall.allowedTCPPorts = [80 443];
    networking.firewall.allowedUDPPorts = [443];
  };
}
