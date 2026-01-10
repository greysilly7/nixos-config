{
  config,
  pkgs,
  greysilly7-xyz,
  ...
}:
{
  services.nginx = {
    enable = true;
    package = pkgs.angie;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    sslCiphers = "AES256+EECDH:AES256+EDH:!aNULL";
    additionalModules = [ pkgs.nginxModules.moreheaders ];

    appendHttpConfig = ''
      # HSTS
      map $scheme $hsts_header {
        https   "max-age=31536000; includeSubdomains; preload";
      }
      add_header Strict-Transport-Security $hsts_header always;

      # Security headers
      add_header Referrer-Policy "origin-when-cross-origin" always;
      add_header X-Frame-Options "DENY" always;
      add_header X-Content-Type-Options "nosniff" always;

      # Cookies
      proxy_cookie_path / "/; secure; HttpOnly; SameSite=strict";
    '';

    commonHttpConfig = "access_log syslog:server=unix:/dev/log;";
    sslDhparam = config.security.dhparams.params.nginx.path;
    enableQuicBPF = true;
    experimentalZstdSettings = true;

    virtualHosts = {
      "greysilly7.xyz" = {
        forceSSL = true;
        enableACME = true;

        locations."/" = {
          root = greysilly7-xyz;
        };

        locations."/.well-known/spacebar" = {
          extraConfig = ''
            default_type application/json;
            more_set_headers 'Access-Control-Allow-Origin: *';
            more_set_headers 'Access-Control-Allow-Methods: *';
          '';
          return = "200 '${
            builtins.toJSON {
              api = config.services.spacebarchat-server.settings.api.endpointPublic;
            }
          }'";
        };
        locations."/.well-known/spacebarchat/client" = {
          extraConfig = ''
            default_type application/json;
            more_set_headers 'Access-Control-Allow-Origin: *';
            more_set_headers 'Access-Control-Allow-Methods: *';
          '';
          return = "200 '${
            builtins.toJSON {
              api = config.services.spacebarchat-server.settings.api.endpointPublic;
              gateway = config.services.spacebarchat-server.settings.gateway.endpointPublic;
              cdn = config.services.spacebarchat-server.settings.cdn.endpointPublic;
            }
          }'";
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
    ];
    allowedUDPPorts = [ 443 ];
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "greysilly7@greysilly7.xyz";
  };

  security.dhparams = {
    enable = true;
    params.nginx = { };
  };
}
