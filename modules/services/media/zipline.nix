_:
{
  den.aspects.media._.zipline = {
    nixos =
      { config, ... }:
      {
        # Zipline ShareX Server
        sops.secrets."zipline/core_secret" = { };

        sops.templates."zipline.env".content = ''
          CORE_SECRET=${config.sops.placeholder."zipline/core_secret"}
          CORE_PORT=3001
          DATABASE_URL=postgres://zipline:zipline@127.0.0.1:5432/zipline
        '';

        virtualisation.oci-containers.containers."zipline-db" = {
          image = "postgres:19beta1";
          environment = {
            POSTGRES_USER = "zipline";
            POSTGRES_PASSWORD = "zipline";
            POSTGRES_DB = "zipline";
          };
          ports = [ "127.0.0.1:5432:5432" ];
          volumes = [
            "/var/lib/zipline/db:/var/lib/postgresql/data"
          ];
        };

        virtualisation.oci-containers.containers.zipline = {
          image = "ghcr.io/diced/zipline:latest";
          ports = [ "3001:3001" ];
          volumes = [
            "/var/lib/zipline/uploads:/zipline/uploads"
            "/var/lib/zipline/public:/zipline/public"
          ];
          environmentFiles = [ config.sops.templates."zipline.env".path ];
          dependsOn = [ "zipline-db" ];
        };

        networking.firewall.allowedTCPPorts = [ 3001 ];
      };
  };
}
