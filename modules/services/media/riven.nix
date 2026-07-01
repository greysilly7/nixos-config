_: {
  den.aspects.media._.riven = {
    nixos =
      { config, pkgs, ... }:
      {
        # Configure FUSE support on the host
        programs.fuse.userAllowOther = true;

        # Define Riven's sops secrets
        sops.secrets."riven/api_key" = { };
        sops.secrets."riven/auth_secret" = { };
        sops.secrets."riven/signing_secret" = { };

        # Setup env file using sops template
        sops.templates."riven.env".content = ''
          RIVEN_SETTING__API_KEY=${config.sops.placeholder."riven/api_key"}
          RIVEN_SETTING__FRONTEND_AUTH_SIGNING_SECRET=${config.sops.placeholder."riven/signing_secret"}
          BACKEND_API_KEY=${config.sops.placeholder."riven/api_key"}
          BACKEND_AUTH_SIGNING_SECRET=${config.sops.placeholder."riven/signing_secret"}
          AUTH_SECRET=${config.sops.placeholder."riven/auth_secret"}
        '';

        # Local build service for the Rust binary container
        systemd.services.build-riven-rs = {
          description = "Build Riven-rs Podman Image";
          wantedBy = [ "multi-user.target" ];
          before = [ "podman-riven.service" ];
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          path = [ pkgs.podman pkgs.git pkgs.shadow ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "build-riven-rs" ''
              if ! podman image exists riven-rs:latest; then
                echo "Building riven-rs:latest..."
                podman build https://github.com/olivertgwalton/riven-rs.git#main -t riven-rs:latest
              else
                echo "riven-rs:latest already exists, skipping build"
              fi
            '';
            StandardOutput = "journal";
            StandardError = "journal";
          };
        };

        # Prevent container stop/restart hangs by lazy-unmounting FUSE before stopping
        systemd.services.podman-riven = {
          serviceConfig = {
            ExecStopPre = [
              "-${pkgs.fuse3}/bin/fusermount3 -uz /var/lib/riven/mount"
            ];
          };
        };

        # Shared bind mount setup for container VFS mount propagation
        systemd.services.riven-bind-shared = {
          description = "Make Riven data bind mount shared";
          after = [ "local-fs.target" ];
          before = [ "podman.service" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "make-rshared" ''
              mkdir -p /var/lib/riven/mount
              ${pkgs.util-linux}/bin/mount --bind /var/lib/riven/mount /var/lib/riven/mount
              ${pkgs.util-linux}/bin/mount --make-rshared /var/lib/riven/mount
            '';
            RemainAfterExit = true;
          };
        };

        # Create directories with appropriate permissions
        systemd.tmpfiles.rules = [
          "d /var/lib/riven 0755 root root -"
          "d /var/lib/riven/db 0755 root root -"
          "d /var/lib/riven/frontend-data 0755 root root -"
          "d /var/lib/riven/mount 0775 media media -"
          "d /var/lib/riven/logs 0755 root root -"
        ];

        # Database (PostgreSQL) Container
        virtualisation.oci-containers.containers."riven-db" = {
          image = "postgres:16-alpine";
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

        # Queue (Redis) Container
        virtualisation.oci-containers.containers."riven-redis" = {
          image = "redis:7-alpine";
          cmd = [ "redis-server" "--port" "6380" ];
          extraOptions = [ "--network=host" ];
        };

        # Riven Rust Backend Container
        virtualisation.oci-containers.containers.riven = {
          image = "riven-rs:latest";
          extraOptions = [
            "--network=host"
            "--device=/dev/fuse"
            "--cap-add=SYS_ADMIN"
            "--security-opt=apparmor=unconfined"
          ];
          environment = {
            RIVEN_SETTING__DATABASE_URL = "postgresql://riven:riven@127.0.0.1:5446/riven";
            RIVEN_SETTING__REDIS_URL = "redis://127.0.0.1:6380";
            RIVEN_SETTING__GQL_PORT = "8082";
            RIVEN_SETTING__VFS_MOUNT_PATH = "/mnt/riven";
            RIVEN_SECRET_KEY_PATH = "/mnt/riven/.riven-secret-key";
            RIVEN_SETTING__LOG_LEVEL = "info";
            ORIGIN = "https://riven.greysilly7.xyz";
            PASSKEY_RP_ID = "riven.greysilly7.xyz";
          };
          volumes = [
            "/var/lib/riven/mount:/mnt/riven:shared"
            "/var/lib/riven/logs:/app/logs"
          ];
          environmentFiles = [ config.sops.templates."riven.env".path ];
          dependsOn = [
            "riven-db"
            "riven-redis"
          ];
        };

        # Riven Frontend Container
        virtualisation.oci-containers.containers.riven-frontend = {
          image = "ghcr.io/rivenmedia/riven-frontend:latest";
          extraOptions = [ "--network=host" ];
          environment = {
            BACKEND_URL = "http://127.0.0.1:8082";
            DATABASE_URL = "/riven/data/riven.db";
            ORIGIN = "https://riven.greysilly7.xyz";
            PORT = "3003";
          };
          volumes = [
            "/var/lib/riven/frontend-data:/riven/data"
          ];
          environmentFiles = [ config.sops.templates."riven.env".path ];
          dependsOn = [
            "riven"
          ];
        };
      };
  };
}
