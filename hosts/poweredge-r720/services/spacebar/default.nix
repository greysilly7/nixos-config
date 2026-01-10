{ lib, config, ... }:

{
  imports = [
    ./imagor.nix
    ./spacebar.nix
  ];

  config = lib.mkIf config.services.nginx.enable {
    services.nginx.virtualHosts = {
      "spacebar.greysilly7.xyz" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            if ($request_method = 'OPTIONS') {
              more_set_headers 'Access-Control-Allow-Origin: *';
              more_set_headers 'Access-Control-Allow-Methods: *';
              #
              # Custom headers and headers various browsers *should* be OK with but aren't
              #
              more_set_headers 'Access-Control-Allow-Headers: *';
              #
              # Tell client that this pre-flight info is valid for 20 days
              #
              more_set_headers 'Access-Control-Max-Age: 1728000';
              more_set_headers 'Content-Type: text/plain; charset=utf-8';
              more_set_headers 'Content-Length: 0';
              return 204;
            }
          '';
        };
        locations."/media" = {
          proxyPass = "http://127.0.0.1:8000";
          extraConfig = ''
            if ($request_method = 'OPTIONS') {
              more_set_headers 'Access-Control-Allow-Origin: *';
              more_set_headers 'Access-Control-Allow-Methods: *';
              #
              # Custom headers and headers various browsers *should* be OK with but aren't
              #
              more_set_headers 'Access-Control-Allow-Headers: *';
              #
              # Tell client that this pre-flight info is valid for 20 days
              #
              more_set_headers 'Access-Control-Max-Age: 1728000';
              more_set_headers 'Content-Type: text/plain; charset=utf-8';
              more_set_headers 'Content-Length: 0';
              return 204;
            }
          '';
        };
      };

      "cdn-spacebar.greysilly7.xyz" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            if ($request_method = 'OPTIONS') {
              more_set_headers 'Access-Control-Allow-Origin: *';
              more_set_headers 'Access-Control-Allow-Methods: *';
              #
              # Custom headers and headers various browsers *should* be OK with but aren't
              #
              more_set_headers 'Access-Control-Allow-Headers: *';
              #
              # Tell client that this pre-flight info is valid for 20 days
              #
              more_set_headers 'Access-Control-Max-Age: 1728000';
              more_set_headers 'Content-Type: text/plain; charset=utf-8';
              more_set_headers 'Content-Length: 0';
              return 204;
            }
          '';
        };
      };

      "gateway-spacebar.greysilly7.xyz" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            if ($request_method = 'OPTIONS') {
              more_set_headers 'Access-Control-Allow-Origin: *';
              more_set_headers 'Access-Control-Allow-Methods: *';
              #
              # Custom headers and headers various browsers *should* be OK with but aren't
              #
              more_set_headers 'Access-Control-Allow-Headers: *';
              #
              # Tell client that this pre-flight info is valid for 20 days
              #
              more_set_headers 'Access-Control-Max-Age: 1728000';
              more_set_headers 'Content-Type: text/plain; charset=utf-8';
              more_set_headers 'Content-Length: 0';
              return 204;
            }

            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
      };

      "api-spacebar.greysilly7.xyz" = {
        forceSSL = true;
        enableACME = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            if ($request_method = 'OPTIONS') {
              more_set_headers 'Access-Control-Allow-Origin: *';
              more_set_headers 'Access-Control-Allow-Methods: *';
              #
              # Custom headers and headers various browsers *should* be OK with but aren't
              #
              more_set_headers 'Access-Control-Allow-Headers: *';
              #
              # Tell client that this pre-flight info is valid for 20 days
              #
              more_set_headers 'Access-Control-Max-Age: 1728000';
              more_set_headers 'Content-Type: text/plain; charset=utf-8';
              more_set_headers 'Content-Length: 0';
              return 204;
            }
          '';
        };
      };
    };
  };
}
