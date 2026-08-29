_: {
  den.aspects.media._.silo-server = {
    nixos =
      { pkgs, config, ... }:
      let
        silo-server = pkgs.callPackage ../../../packages/silo-server { };
      in
      {
        systemd.tmpfiles.rules = [
          "d /var/lib/silo 0750 media media -"
          "d /var/lib/silo/db 0750 999 999 -"
        ];

        sops.secrets."silo/secret_key" = { };
        sops.secrets."silo/db_password" = { };

        sops.templates."silo.env".content = ''
          SECRET_KEY=${config.sops.placeholder."silo/secret_key"}
          DATABASE_URL=postgres://silo:${config.sops.placeholder."silo/db_password"}@127.0.0.1:5432/silo
          REDIS_URL=redis://127.0.0.1:6379
          JF_PORT=8196
          PORT=8280
        '';

        sops.templates."silo-db.env".content = ''
          POSTGRES_USER=silo
          POSTGRES_PASSWORD=${config.sops.placeholder."silo/db_password"}
          POSTGRES_DB=silo
        '';

        virtualisation.oci-containers.containers."silo-db" = {
          image = "docker.io/pgvector/pgvector:pg18";
          environmentFiles = [ config.sops.templates."silo-db.env".path ];
          extraOptions = [ "--network=host" ];
          volumes = [
            "/var/lib/silo/db:/var/lib/postgresql"
          ];
        };

        services.redis.servers.silo = {
          enable = true;
          port = 6379;
          bind = "127.0.0.1";
        };

        systemd.services.silo-server = {
          description = "Silo media server";
          after = [
            "network-online.target"
            "podman-silo-db.service"
            "redis-silo.service"
          ];
          wants = [ "network-online.target" ];
          requires = [
            "podman-silo-db.service"
            "redis-silo.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            User = "media";
            Group = "media";
            WorkingDirectory = "/var/lib/silo";
            EnvironmentFile = config.sops.templates."silo.env".path;
            ExecStart = "${silo-server}/bin/silo";
            Restart = "on-failure";
            RestartSec = 5;
            NoNewPrivileges = true;
            ProtectSystem = "strict";
            ReadWritePaths = [ "/var/lib/silo" ];
            PrivateTmp = true;
          };
        };
      };
  };
}
