_: {
  den.aspects.media._.silo-server = {
    nixos =
      { pkgs, config, ... }:
      let
        silo-server = pkgs.callPackage ../../../packages/silo-server { };
      in
      {
        users.groups.silo = { };
        users.users.silo = {
          isSystemUser = true;
          group = "silo";
        };

        systemd.tmpfiles.rules = [
          "d /var/lib/silo 0750 silo silo -"
          "d /var/lib/silo/db 0750 root root -"
        ];

        sops.secrets."silo/secret_key" = { };

        sops.templates."silo.env".content = ''
          SECRET_KEY=${config.sops.placeholder."silo/secret_key"}
          DATABASE_URL=postgres://silo:silo@127.0.0.1:5432/silo
          REDIS_URL=redis://127.0.0.1:6379
        '';

        # Postgres 18 + pgvector for Silo — the only piece of this stack that
        # stays containerized, per request. The app itself runs natively.
        virtualisation.oci-containers.containers."silo-db" = {
          image = "pgvector/pgvector:pg18";
          environment = {
            POSTGRES_USER = "silo";
            POSTGRES_PASSWORD = "silo";
            POSTGRES_DB = "silo";
          };
          extraOptions = [ "--network=host" ];
          volumes = [
            "/var/lib/silo/db:/var/lib/postgresql/data"
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
            User = "silo";
            Group = "silo";
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
