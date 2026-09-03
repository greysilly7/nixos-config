_: {
  den.aspects.media._.zipline = {
    nixos =
      { config, ... }:
      {
        # Zipline ShareX Server
        sops.secrets."zipline/core_secret" = { };
        sops.secrets."zipline/db_password" = { };

        sops.templates."zipline.env".content = ''
          CORE_SECRET=${config.sops.placeholder."zipline/core_secret"}
          CORE_PORT=4001
          CORE_HOSTNAME=127.0.0.1
          DATABASE_URL=postgres://zipline:${
            config.sops.placeholder."zipline/db_password"
          }@127.0.0.1:5444/zipline
        '';

        sops.templates."zipline-db.env".content = ''
          POSTGRES_USER=zipline
          POSTGRES_PASSWORD=${config.sops.placeholder."zipline/db_password"}
          POSTGRES_DB=zipline
          PGPORT=5444
        '';

        virtualisation.oci-containers.containers."zipline-db" = {
          image = "postgres:19beta1";
          environmentFiles = [ config.sops.templates."zipline-db.env".path ];
          extraOptions = [ "--network=host" ];
          volumes = [
            "/var/lib/zipline/db:/var/lib/postgresql"
          ];
        };

        virtualisation.oci-containers.containers.zipline = {
          image = "ghcr.io/diced/zipline:latest";
          extraOptions = [ "--network=host" ];
          volumes = [
            "/var/lib/zipline/uploads:/zipline/uploads"
            "/var/lib/zipline/public:/zipline/public"
          ];
          environmentFiles = [ config.sops.templates."zipline.env".path ];
          dependsOn = [ "zipline-db" ];
        };
      };
  };
}
