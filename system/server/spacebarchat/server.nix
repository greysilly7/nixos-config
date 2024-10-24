{
  pkgs,
  lib,
  inputs,
  ...
}: let
  services = [
    {
      name = "api";
      description = "Spacebar Server API";
    }
    {
      name = "gateway";
      description = "Spacebar Server Gateway";
    }
    {
      name = "cdn";
      description = "Spacebar Server CDN";
    }
  ];
  rootDomain = "spacebar.greysilly7.xyz";
in {
  services.rabbitmq.enable = true;

  /*
  # Define the spacebar user
  users.users.spacebar = {
    isSystemUser = true;
    group = "spacebar";
    extraGroups = ["postgres"];
  };

  # Define the spacebar group
  users.groups.spacebar = {};

  # Define the systemd service for Spacebar
  systemd.services.spacebar = {
    description = "Spacebar Node.js application";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    before = ["nginx.service"];
    preStart = ''
      ${pkgs.coreutils}/bin/mkdir -p /var/lib/spacebar
      ${pkgs.coreutils}/bin/chown spacebar:spacebar /var/lib/spacebar
      ${pkgs.coreutils}/bin/chmod 700 /var/lib/spacebar
    '';
    serviceConfig = {
      ExecStart = "${inputs.spacebarchat.packages.${"x86_64-linux"}.default}/bin/start-bundle";
      Restart = "always";
      User = "spacebar";
      Group = "spacebar";
      AmbientCapabilities = lib.mkForce "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = lib.mkForce "CAP_NET_BIND_SERVICE";
      Environment = [
        "DATABASE=postgres://spacebar@127.0.0.1:5432/spacebar"
        "STORAGE_LOCATION=/var/lib/spacebar"
      ];
    };
  };

  # Nginx virtual host configuration for Spacebar
  services.nginx.virtualHosts = {
    "spacebar.greysilly7.xyz" = {
      forceSSL = true;
      enableACME = true;
      http2 = true;
      http3 = true;

      locations = {
        "/" = {
          proxyPass = "http://127.0.0.1:3001";
          extraConfig = ''
            proxy_no_cache 1;
            proxy_cache_bypass 1;

            proxy_set_header Upgrade $http_upgrade;
            proxy_set_header Connection "upgrade";
          '';
        };
        "/media" = {
          proxyPass = "http://127.0.0.1:8000";
        };
      };
    };
  };

  # OCI container configuration for Imagor
  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      imagor = {
        image = "shumc/imagor";
        environmentFiles = [config.sops.secrets.imagorenv.path];
        ports = [
          "8000:8000"
        ];
      };
    };
  };
  */

  services.nginx.virtualHosts = {
    "${rootDomain}".locations."/" = {
      enableACME = true;
      forceSSL = true;
      http2 = true;
      http3 = true;
      extraConfig = ''
        return 200 '{
          "cdn": "cdn.${rootDomain}",
          "gateway": "gateway.${rootDomain}",
          "api": "api.${rootDomain}"
        }';

      '';
    };
    "api.${rootDomain}" = {
      locations."/" = {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        http3 = true;
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
    "cdn.${rootDomain}" = {
      locations."/" = {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        http3 = true;
        proxyPass = "http://127.0.0.1:3003";
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
    "gateway.${rootDomain}" = {
      locations."/" = {
        enableACME = true;
        forceSSL = true;
        http2 = true;
        http3 = true;
        proxyPass = "http://127.0.0.1:3002";
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

  systemd.services =
    lib.attrsets.genAttrs
    (map (service: "spacebar-server-${service.name}") services)
    (serviceName: {
      description = serviceName;
      wantedBy = ["multi-user.target"];
      requires =
        ["postgresql.service" "rabbitmq.service"]
        ++ (
          if serviceName != "spacebar-server-api"
          then ["spacebar-server-api.service"]
          else []
        );
      serviceConfig = {
        ExecStart = "${inputs.spacebarchat.packages.${pkgs.system}.default}/bin/start-${builtins.substring 16 30 serviceName}";
        WorkingDirectory = "/var/lib/spacebar";
        StateDirectory = "spacebar";
        StateDirectoryMode = "0700";
        ProtectSystem = "strict";
        ProtectHome = true;
        PrivateTmp = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        Restart = "on-failure";
        Environment = [
          "DATABASE=postgres://spacebar@127.0.0.1:5432/spacebar"
          "STORAGE_LOCATION=/var/lib/spacebar"
          # "LOG_REQUESTS='-'"
          #"DB_LOGGING='true'"
        ];
      };
    });
}
