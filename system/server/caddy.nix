{
  config,
  inputs,
  pkgs,
  ...
}: let
  rootSBDomain = "spacebar.greysilly7.xyz";
in {
  services.caddy = {
    enable = true; # Enable Caddy service

    # Caddyfile configuration
    configFile = pkgs.writeText "Caddyfile" ''
      {
        email greysilly7@gmail.com
        acme_ca https://acme-v02.api.letsencrypt.org/directory
      }

      # Global options
      {
        # Recommended TLS settings
        tls {
          protocols tls1.2 tls1.3
          ciphers TLS_AES_128_GCM_SHA256 TLS_AES_256_GCM_SHA384 TLS_CHACHA20_POLY1305_SHA256
        }

        trusted_proxies cloudflare {
          interval 12h
          timeout 15s
        }

      # Virtual host configuration for greysilly7.xyz
      greysilly7.xyz {
        root * ${inputs.greysilly7-xyz}
        encode zstd gzip
        file_server

        @spacebar {
          path /.well-known/spacebar
        }
        handle @spacebar {
          header Access-Control-Allow-Origin "*"
          header Content-Type application/json
          respond `{
            "api": "https://api.${rootSBDomain}/api/v9"
          }`
        }

        header {
          Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
          Referrer-Policy "origin-when-cross-origin"
          X-Frame-Options "DENY"
          X-Content-Type-Options "nosniff"
        }

        log {
          output file /var/log/caddy/greysilly7.xyz.log
        }

        @options {
          method OPTIONS
        }
        handle @options {
          header Access-Control-Allow-Origin "*"
          header Access-Control-Allow-Methods "*"
          header Access-Control-Allow-Headers "*"
          header Access-Control-Max-Age "1728000"
          header Content-Type "text/plain; charset=utf-8"
          header Content-Length "0"
          respond "" 204
        }
      }

      # Virtual host configuration for vaultwarden.greysilly7.xyz
      vaultwarden.greysilly7.xyz {
        reverse_proxy http://127.0.0.1:${toString config.services.vaultwarden.config.ROCKET_PORT} {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }

        header {
          Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
        }

        log {
          output file /var/log/caddy/vaultwarden.greysilly7.xyz.log
        }

        @options {
          method OPTIONS
        }
        handle @options {
          header Access-Control-Allow-Origin "*"
          header Access-Control-Allow-Methods "*"
          header Access-Control-Allow-Headers "*"
          header Access-Control-Max-Age "1728000"
          header Content-Type "text/plain; charset=utf-8"
          header Content-Length "0"
          respond "" 204
        }
      }

      # Virtual host configuration for spacebar.greysilly7.xyz
      spacebar.greysilly7.xyz {
        reverse_proxy http://127.0.0.1:3001 {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }

        reverse_proxy /media http://127.0.0.1:8000

        header {
          Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
        }

        log {
          output file /var/log/caddy/spacebar.greysilly7.xyz.log
        }

        @options {
          method OPTIONS
        }
        handle @options {
          header Access-Control-Allow-Origin "*"
          header Access-Control-Allow-Methods "*"
          header Access-Control-Allow-Headers "*"
          header Access-Control-Max-Age "1728000"
          header Content-Type "text/plain; charset=utf-8"
          header Content-Length "0"
          respond "" 204
        }
      }

      # Virtual host configuration for api.spacebar.greysilly7.xyz
      api.spacebar.greysilly7.xyz {
        reverse_proxy http://127.0.0.1:3001 {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }

        header {
          Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
        }

        log {
          output file /var/log/caddy/api.spacebar.greysilly7.xyz.log
        }

        @options {
          method OPTIONS
        }
        handle @options {
          header Access-Control-Allow-Origin "*"
          header Access-Control-Allow-Methods "*"
          header Access-Control-Allow-Headers "*"
          header Access-Control-Max-Age "1728000"
          header Content-Type "text/plain; charset=utf-8"
          header Content-Length "0"
          respond "" 204
        }
      }

      # Virtual host configuration for cdn.spacebar.greysilly7.xyz
      cdn.spacebar.greysilly7.xyz {
        reverse_proxy http://127.0.0.1:3003 {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }

        header {
          Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
        }

        log {
          output file /var/log/caddy/cdn.spacebar.greysilly7.xyz.log
        }

        @options {
          method OPTIONS
        }
        handle @options {
          header Access-Control-Allow-Origin "*"
          header Access-Control-Allow-Methods "*"
          header Access-Control-Allow-Headers "*"
          header Access-Control-Max-Age "1728000"
          header Content-Type "text/plain; charset=utf-8"
          header Content-Length "0"
          respond "" 204
        }
      }

      # Virtual host configuration for gateway.spacebar.greysilly7.xyz
      gateway.spacebar.greysilly7.xyz {
        reverse_proxy http://127.0.0.1:3002 {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }

        header {
          Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
        }

        log {
          output file /var/log/caddy/gateway.spacebar.greysilly7.xyz.log
        }

        @options {
          method OPTIONS
        }
        handle @options {
          header Access-Control-Allow-Origin "*"
          header Access-Control-Allow-Methods "*"
          header Access-Control-Allow-Headers "*"
          header Access-Control-Max-Age "1728000"
          header Content-Type "text/plain; charset=utf-8"
          header Content-Length "0"
          respond "" 204
        }
      }

      # Virtual host configuration for jankclient.greysilly7.xyz
      jankclient.greysilly7.xyz {
        reverse_proxy http://127.0.0.1:8080 {
          header_up Host {host}
          header_up X-Real-IP {remote}
          header_up X-Forwarded-For {remote}
          header_up X-Forwarded-Proto {scheme}
        }

        header {
          Strict-Transport-Security "max-age=31536000; includeSubdomains; preload"
        }

        log {
          output file /var/log/caddy/jankclient.greysilly7.xyz.log
        }

        @options {
          method OPTIONS
        }
        handle @options {
          header Access-Control-Allow-Origin "*"
          header Access-Control-Allow-Methods "*"
          header Access-Control-Allow-Headers "*"
          header Access-Control-Max-Age "1728000"
          header Content-Type "text/plain; charset=utf-8"
          header Content-Length "0"
          respond "" 204
        }
      }
    '';
  };

  # Open Firewall for HTTP and HTTPS
  networking.firewall.allowedTCPPorts = [80 443];
  networking.firewall.allowedUDPPorts = [443];
}
