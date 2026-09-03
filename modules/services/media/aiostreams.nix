{ inputs, ... }: {
  flake-file.inputs.aiostreams = {
    url = "github:greysilly7/AIOStreams";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.media._.aiostreams = {
    nixos =
      { config, ... }:
      {
        imports = [ inputs.aiostreams.nixosModules.aiostreams ];

        # AIOStreams Addon Manager — built from our own fork (github:greysilly7/AIOStreams)
        # via its own flake, replacing the ghcr.io/viren070/aiostreams:nightly docker image.
        sops.secrets."aiostreams/secret_key" = { };
        sops.secrets."aiostreams/auth" = { };

        sops.templates."aiostreams-secrets.env".content = ''
          SECRET_KEY=${config.sops.placeholder."aiostreams/secret_key"}
          AIOSTREAMS_AUTH=${config.sops.placeholder."aiostreams/auth"}
        '';

        services.aiostreams = {
          enable = true;
          port = 3000;
          baseUrl = "https://aiostreams.greysilly7.xyz";
          # Existing SQLite DB from the old docker bind mount (/var/lib/aiostreams/data)
          # — kept in place so configs/users survive the docker -> native migration.
          databaseUri = "sqlite:///var/lib/aiostreams/data/db.sqlite";
          extraEnv = {
            SEL_SYNC_ACCESS = "all";
            REGEX_FILTER_ACCESS = "all";
            TEMPLATE_URLS = ''["https://git.tamtaro.de/complete.json"]'';
            TEMPLATE_REFRESH_INTERVAL = "3600";
            WHITELISTED_SYNC_REFRESH_INTERVAL = "3600";
          };
        };

        # SECRET_KEY/AIOSTREAMS_AUTH stay out of the Nix store (the module's own
        # `secretKey`/`authUser` options bake plain strings into the unit file) —
        # layer them on via a sops-templated EnvironmentFile instead.
        systemd.services.aiostreams.serviceConfig.EnvironmentFile = [
          config.sops.templates."aiostreams-secrets.env".path
        ];
      };
  };
}
