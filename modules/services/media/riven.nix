_: {
  den.aspects.media._.riven = {
    nixos =
      { pkgs, config, ... }:
      {
        # Riven Rust Media Tool
        sops.secrets."riven/api_key" = { };
        sops.secrets."riven/frontend_auth_signing_secret" = { };
        sops.secrets."riven/auth_secret" = { };

        sops.templates."riven.env".content = ''
          RIVEN_SETTING__API_KEY=${config.sops.placeholder."riven/api_key"}
          RIVEN_SETTING__FRONTEND_AUTH_SIGNING_SECRET=${
            config.sops.placeholder."riven/frontend_auth_signing_secret"
          }
        '';

        sops.templates."riven-frontend.env".content = ''
          AUTH_SECRET=${config.sops.placeholder."riven/auth_secret"}
          RIVEN_SETTING__FRONTEND_AUTH_SIGNING_SECRET=${
            config.sops.placeholder."riven/frontend_auth_signing_secret"
          }
        '';

        # Enable FUSE user_allow_other for VFS mount
        programs.fuse.userAllowOther = true;

        # Postgres Database Container for Riven
        virtualisation.oci-containers.containers."riven-db" = {
          image = "postgres:18-alpine";
          environment = {
            POSTGRES_USER = "riven";
            POSTGRES_PASSWORD = "riven";
            POSTGRES_DB = "riven";
            PGPORT = "5446";
          };
          extraOptions = [ "--network=host" ];
          volumes = [
            "/var/lib/riven/db:/var/lib/postgresql/data"
          ];
        };

        # Redis Cache Container for Riven
        virtualisation.oci-containers.containers."riven-redis" = {
          image = "redis:8-alpine";
          extraOptions = [ "--network=host" ];
          cmd = [
            "redis-server"
            "--port"
            "6380"
          ];
        };

        # Riven Backend (Native Systemd Service to support FUSE cleanly)
        systemd.services.riven = {
          description = "Riven Backend (Rust)";
          after = [
            "network.target"
            "podman-riven-db.service"
            "podman-riven-redis.service"
          ];
          requires = [
            "podman-riven-db.service"
            "podman-riven-redis.service"
          ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            ExecStart = "${pkgs.callPackage ../../../packages/riven/default.nix { }}/bin/riven";
            Restart = "on-failure";
            User = "root"; # Required for FUSE mounting with user_allow_other
            WorkingDirectory = "/var/lib/riven";
            StateDirectory = "riven";
            EnvironmentFile = config.sops.templates."riven.env".path;
          };
          environment = {
            RIVEN_SETTING__DATABASE_URL = "postgresql://riven:riven@127.0.0.1:5446/riven";
            RIVEN_SETTING__REDIS_URL = "redis://127.0.0.1:6380";
            RIVEN_SETTING__GQL_PORT = "8080";
            RIVEN_SETTING__LOG_DIRECTORY = "/var/lib/riven/logs";
            RIVEN_SETTING__VFS_MOUNT_PATH = "/mnt/pool/arr/media/riven";
            SQLX_OFFLINE = "true";
          };
        };

        # Riven Frontend Container
        virtualisation.oci-containers.containers."riven-frontend" = {
          image = "ghcr.io/rivenmedia/riven-frontend:latest";
          extraOptions = [ "--network=host" ];
          environment = {
            PORT = "3002";
            DATABASE_URL = "/riven/data/riven.db";
            BACKEND_URL = "http://127.0.0.1:8080";
            ORIGIN = "https://riven.greysilly7.xyz";
            PASSKEY_RP_ID = "riven.greysilly7.xyz";
          };
          volumes = [
            "/var/lib/riven/frontend:/riven/data"
          ];
          environmentFiles = [ config.sops.templates."riven-frontend.env".path ];
        };
      };
  };
}
