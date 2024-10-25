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
in {
  services.rabbitmq.enable = true;

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
