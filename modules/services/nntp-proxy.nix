{ inputs, ... }: {
  flake-file.inputs.nntp-proxy = {
    url = "github:greysilly7/nntp-proxy";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.nntp-proxy = {
    nixos = { config, pkgs, ... }: {
      sops.secrets = {
        "nntp/servers/newshosting_pw" = { };
        "nntp/servers/tweaknews_pw" = { };
        "nntp/servers/ngd_pw" = { };
        "nntp/servers/supernews_pw" = { };
        "nntp/servers/usenetfarm_pw" = { };
        "nntp/servers/viper_pw" = { };
        "nntp/servers/torbox_pw" = { };
      };

      # 2. Render the credentials-only overlay at runtime. Non-secret server
      # fields live in `services.nntp-proxy.settings.servers`; this overlay only
      # carries passwords, matched to those servers by `name`.
      sops.templates."nntp-credentials.toml".content = ''
        [[servers]]
        name = "Newshosting"
        password = "${config.sops.placeholder."nntp/servers/newshosting_pw"}"

        [[servers]]
        name = "Tweaknews"
        password = "${config.sops.placeholder."nntp/servers/tweaknews_pw"}"

        [[servers]]
        name = "NewsGroupDirect"
        password = "${config.sops.placeholder."nntp/servers/ngd_pw"}"

        [[servers]]
        name = "Supernews"
        password = "${config.sops.placeholder."nntp/servers/supernews_pw"}"

        [[servers]]
        name = "UsenetFarm"
        password = "${config.sops.placeholder."nntp/servers/usenetfarm_pw"}"

        [[servers]]
        name = "Viper"
        password = "${config.sops.placeholder."nntp/servers/viper_pw"}"

        [[servers]]
        name = "Torbox"
        password = "${config.sops.placeholder."nntp/servers/torbox_pw"}"
      '';

      # The upstream module runs nntp-proxy as a systemd DynamicUser, so the
      # rendered overlay (root:root 0400 by default) is unreadable to it.
      # Hand it to a stable shared group the unit joins. The group name must
      # NOT match the unit name or DynamicUser allocation fails with
      # "User or group with specified name already exists".
      sops.templates."nntp-credentials.toml" = {
        group = "nntp-proxy-secrets";
        mode = "0440";
        restartUnits = [ "nntp-proxy.service" ];
      };

      users.groups.nntp-proxy-secrets = { };

      systemd.services.nntp-proxy.serviceConfig.SupplementaryGroups = [ "nntp-proxy-secrets" ];

      imports = [ inputs.nntp-proxy.nixosModules.default ];

      services.nntp-proxy = {
        enable = true;
        openFirewall = false;

        # Pass the rendered sops template to your module
        credentialsFile = config.sops.templates."nntp-credentials.toml".path;

        settings = {
          proxy = {
            host = "127.0.0.1";
            port = 8119;
            threads = 0;
            validate_yenc = false;
          };

          # Non-secret backend definitions. Passwords are merged at runtime from
          # the credentials overlay (see sops.templates above), matched by name.
          servers = [
            {
              name = "Newshosting";
              host = "news.newshosting.com";
              port = 563;
              username = "6ind3c3y";
              max_connections = 100;
              tier = 0;
              stat_missing = 1;
              use_tls = true;
              tls_verify_cert = true;
            }
            {
              name = "Tweaknews";
              host = "newshosting.tweaknews.eu";
              port = 563;
              username = "cnzzykughklk";
              max_connections = 40;
              tier = 1;
              stat_missing = 1;
              use_tls = true;
              tls_verify_cert = true;
            }
            {
              name = "NewsGroupDirect";
              host = "news.newsgroupdirect.com";
              port = 563;
              username = "ehg741689847";
              max_connections = 100;
              tier = 2;
              stat_missing = 1;
              use_tls = true;
              tls_verify_cert = true;
            }
            {
              name = "Supernews";
              host = "super.newsgroupdirect.com";
              port = 563;
              username = "ehg741689847@newsgroupdirect.com";
              max_connections = 30;
              tier = 3;
              stat_missing = 1;
              use_tls = true;
              tls_verify_cert = true;
            }
            {
              name = "UsenetFarm";
              host = "farm.newsgroupdirect.com";
              port = 563;
              username = "ehg741689847";
              max_connections = 40;
              tier = 4;
              stat_missing = 1;
              use_tls = true;
              tls_verify_cert = true;
            }
            {
              name = "Viper";
              host = "viper.newsgroupdirect.com";
              port = 563;
              username = "ehg741689847";
              max_connections = 1;
              tier = 4;
              stat_missing = 1;
              use_tls = true;
              tls_verify_cert = true;
            }
            {
              name = "Torbox";
              host = "news.torbox.app";
              port = 563;
              username = "d2a19a91-520c-404f-a167-9392aec89e6e";
              max_connections = 10;
              tier = 5;
              stat_missing = 1;
              use_tls = true;
              tls_verify_cert = true;
            }
          ];

          routing = {
            mode = "hybrid";
            backend_selection = "least-loaded";
            adaptive_precheck = true;
          };

          memory = {
            socket_recv_buffer_size = 16777216;
            socket_send_buffer_size = 16777216;
            buffer_pool_size = 1048576;
            buffer_pool_count = 325;
            capture_pool_size = 1048576;
            capture_pool_count = 16;
          };

          cache = {
            article_cache_capacity = "1gb";
            article_cache_ttl_secs = 3600;
            store_article_bodies = true;

            disk = {
              capacity = "10gb";
              compression = "lz4";
              shards = 4;
            };
          };
          web_panel = {
            enabled = true;
            host = "127.0.0.1";
            port = 8080;
          };
        };
      };

      networking.firewall.allowedTCPPorts = [ 563 80 443 ];

      # Edge proxy for this host is Caddy (the ingress-gateway globals and the
      # wildcard vhost live in modules/hosts/ultra-channel-7747/default.nix).
      # Caddy owns :80/:443, and via the caddy-l4 plugin it also terminates
      # NNTPS on :563 and forwards plaintext to the local nntp-proxy listener.
      services.caddy = {
        enable = true;

        # caddy-l4 (layer4 TCP/UDP) is not in the stock Caddy build, so we build
        # a Caddy with the plugin vendored in. Hash is the src-with-plugins
        # fixed-output hash for caddy-l4 v0.1.2 on Caddy 2.11.4; regenerate
        # (set to lib.fakeHash, rebuild, copy the "got:" value) if either bumps.
        package = pkgs.caddy.withPlugins {
          plugins = [ "github.com/mholt/caddy-l4@v0.1.2" ];
          hash = "sha256-C+ksbA6ucY3GUsYHSUhkYoh1gTP8SIAJv0MLjhX8BQM=";
        };

        # Layer4 NNTPS terminator. `tls` (no args) uses Caddy's automatically
        # managed cert for news.greysilly7.xyz — issued via HTTP-01 because
        # Caddy now owns :80 — matched by SNI.
        globalConfig = ''
          layer4 {
            :563 {
              route {
                tls
                proxy 127.0.0.1:8119
              }
            }
          }
        '';

        # Web panel vhost (replaces the old nginx dummy host). `= /` -> /client,
        # everything else proxied to the panel. Automatic HTTPS + ACME.
        virtualHosts."news.greysilly7.xyz".extraConfig = ''
          @root path /
          redir @root /client 302
          reverse_proxy 127.0.0.1:8080
        '';
      };
    };
  };
}
