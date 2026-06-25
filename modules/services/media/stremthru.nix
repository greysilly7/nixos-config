_: {
  den.aspects.media._.stremthru = {
    nixos =
      { config, ... }:
      {
        # StremThru proxy streaming service
        sops.secrets."stremthru/proxy_auth" = { };
        sops.secrets."stremthru/store_auth" = { };

        sops.templates."stremthru.env".content = ''
          STREMTHRU_PROXY_AUTH=${config.sops.placeholder."stremthru/proxy_auth"}
          STREMTHRU_STORE_AUTH=${config.sops.placeholder."stremthru/store_auth"}
          STREMTHRU_DATABASE_URI=postgres://stremthru:stremthru@127.0.0.1:5445/stremthru
          STREMTHRU_REDIS_URI=redis://127.0.0.1:6379
        '';

        virtualisation.oci-containers.containers."stremthru-db" = {
          image = "postgres:16-alpine";
          environment = {
            POSTGRES_USER = "stremthru";
            POSTGRES_PASSWORD = "stremthru";
            POSTGRES_DB = "stremthru";
            PGPORT = "5445";
          };
          extraOptions = [ "--network=host" ];
          volumes = [
            "/var/lib/stremthru/db:/var/lib/postgresql/data"
          ];
        };

        virtualisation.oci-containers.containers."stremthru-redis" = {
          image = "redis:7-alpine";
          extraOptions = [ "--network=host" ];
        };

        virtualisation.oci-containers.containers.stremthru = {
          image = "muniftanjim/stremthru:latest";
          extraOptions = [ "--network=host" ];
          environment = {
            STREMTHRU_HTTP_PORT = "8081";
          };
          volumes = [
            "/var/lib/stremthru/data:/app/data"
          ];
          environmentFiles = [ config.sops.templates."stremthru.env".path ];
          dependsOn = [
            "stremthru-db"
            "stremthru-redis"
          ];
        };

        systemd.tmpfiles.rules = [
          "d /var/lib/stremthru 0755 root root -"
          "d /var/lib/stremthru/data 0755 root root -"
          "d /var/lib/stremthru/db 0755 root root -"
        ];
      };
  };
}
