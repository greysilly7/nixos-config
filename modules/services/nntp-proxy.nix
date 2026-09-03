_: {
  den.aspects.nntp-proxy = {
    flake-file.inputs.home-manager = {
      url = "github:greysilly7/nntp-proxy";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos = { config, inputs, ... }: {
      sops.secrets = {
        "nntp/servers/newshosting_pw" = { };
        "nntp/servers/tweaknews_pw" = { };
        "nntp/servers/ngd_pw" = { };
        "nntp/servers/supernews_pw" = { };
        "nntp/servers/usenetfarm_pw" = { };
        "nntp/servers/viper_pw" = { };
        "nntp/servers/torbox_pw" = { };
      };

      # 2. Render the credentials TOML overlay at runtime
      sops.templates."nntp-credentials.toml".content = ''
        [[servers]]
        host = "news.newshosting.com"
        port = 563
        name = "Newshosting"
        max_connections = 100
        tier = 0
        username = "6ind3c3y"
        password = "${config.sops.placeholder."nntp/servers/newshosting_pw"}"
        stat_missing = 1
        use_tls = true
        tls_verify_cert = true

        [[servers]]
        host = "newshosting.tweaknews.eu"
        port = 563
        name = "Tweaknews"
        max_connections = 40
        tier = 1
        username = "cnzzykughklk"
        password = "${config.sops.placeholder."nntp/servers/tweaknews_pw"}"
        stat_missing = 1
        use_tls = true
        tls_verify_cert = true

        [[servers]]
        host = "news.newsgroupdirect.com"
        port = 563
        name = "NewsGroupDirect"
        max_connections = 100
        tier = 2
        username = "ehg741689847"
        password = "${config.sops.placeholder."nntp/servers/ngd_pw"}"
        stat_missing = 1
        use_tls = true
        tls_verify_cert = true

        [[servers]]
        host = "super.newsgroupdirect.com"
        port = 563
        name = "Supernews"
        max_connections = 30
        tier = 3
        username = "ehg741689847@newsgroupdirect.com"
        password = "${config.sops.placeholder."nntp/servers/supernews_pw"}"
        stat_missing = 1
        use_tls = true
        tls_verify_cert = true

        [[servers]]
        host = "farm.newsgroupdirect.com"
        port = 563
        name = "UsenetFarm"
        max_connections = 40
        tier = 4
        username = "ehg741689847"
        password = "${config.sops.placeholder."nntp/servers/usenetfarm_pw"}"
        stat_missing = 1
        use_tls = true
        tls_verify_cert = true

        [[servers]]
        host = "viper.newsgroupdirect.com"
        port = 563
        name = "Viper"
        max_connections = 1
        tier = 4
        username = "ehg741689847"
        password = "${config.sops.placeholder."nntp/servers/viper_pw"}"
        stat_missing = 1
        use_tls = true   
        tls_verify_cert = true

        [[servers]]
        host = "news.torbox.app"
        port = 563
        name = "Torbox"
        max_connections = 10
        tier = 5
        username = "d2a19a91-520c-404f-a167-9392aec89e6e"
        password = "${config.sops.placeholder."nntp/servers/torbox_pw"}"
        stat_missing = 1
        use_tls = true
        tls_verify_cert = true
      '';

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
        };
      };

      networking.firewall.allowedTCPPorts = [ 593 ];

      security.acme = {
        acceptTerms = true;
        defaults.email = "greysilly7@greysilly7.xyz";
      };

      # Set up a dummy web host just so ACME can validate the domain
      services.nginx.virtualHosts."news.greysilly7.xyz" = {
        enableACME = true;
        forceSSL = true;
      };

      # 3. Stream the TLS traffic to the local nntp-proxy
      services.nginx = {
        enable = true;
        streamConfig = ''
          server {
            listen 593 ssl;
            proxy_pass 127.0.0.1:8119;
            
            ssl_certificate ${config.security.acme.certs."nntp.yourdomain.com".directory}/fullchain.pem;
            ssl_certificate_key ${config.security.acme.certs."nntp.yourdomain.com".directory}/key.pem;
            
            ssl_protocols TLSv1.2 TLSv1.3;
            ssl_ciphers HIGH:!aNULL:!MD5;
            ssl_session_cache shared:SSL:20m;
            ssl_session_timeout 4h;
          }
        '';
      };
    };
  };
}
