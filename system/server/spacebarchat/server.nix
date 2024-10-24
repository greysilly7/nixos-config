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

  services.nginx.virtualHosts = {
    "${rootDomain}" = {
      enableACME = true;
      forceSSL = true;
      http2 = true;
      http3 = true;

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
    "api.${rootDomain}" = {
      enableACME = true;
      forceSSL = true;
      http2 = true;
      http3 = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
    };
    "cdn.${rootDomain}" = {
      enableACME = true;
      forceSSL = true;
      http2 = true;
      http3 = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:3003";
      };
    };
    "gateway.${rootDomain}" = {
      enableACME = true;
      forceSSL = true;
      http2 = true;
      http3 = true;

      locations."/" = {
        proxyPass = "http://127.0.0.1:3002";
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
