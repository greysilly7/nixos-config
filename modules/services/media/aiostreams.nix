_: {
  den.aspects.media._.aiostreams = {
    nixos =
      { config, ... }:
      {
        # AIOStreams Addon Manager
        sops.secrets."aiostreams/secret_key" = { };
        sops.secrets."aiostreams/auth" = { };

        sops.templates."aiostreams.env".content = ''
          BASE_URL=https://aiostreams.greysilly7.xyz
          SECRET_KEY=${config.sops.placeholder."aiostreams/secret_key"}
          DATABASE_URI=sqlite://./data/db.sqlite
          SEL_SYNC_ACCESS=all
          REGEX_FILTER_ACCESS=all
          TEMPLATE_URLS=["https://git.tamtaro.de/complete.json"]
          AIOSTREAMS_AUTH=${config.sops.placeholder."aiostreams/auth"}
          TEMPLATE_REFRESH_INTERVAL=3600
          WHITELISTED_SYNC_REFRESH_INTERVAL=3600
        '';

        virtualisation.oci-containers.containers.aiostreams = {
          image = "ghcr.io/viren070/aiostreams:2026.07.05.2149-nightly";
          ports = [ "3000:3000" ];
          volumes = [
            "/var/lib/aiostreams/data:/app/data"
          ];
          environmentFiles = [ config.sops.templates."aiostreams.env".path ];
        };
      };
  };
}
