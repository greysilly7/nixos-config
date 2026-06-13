_: {
  den.aspects.media = {
    nixos =
      { pkgs, config, ... }:
      {
        # Define a common media group for all services to share permissions
        users.groups.media = { };

        # TorBoxarr Service
        sops.secrets."torboxarr/api_token" = {};
        sops.secrets."torboxarr/qbit_passsword" = {};
        sops.secrets."torboxarr/sab_api_key" = {};

        sops.templates."torboxarr.env".content = ''
          TORBOXARR_TORBOX_API_TOKEN=${config.sops.placeholder."torboxarr/api_token"}
          TORBOXARR_QBIT_PASSWORD=${config.sops.placeholder."torboxarr/qbit_passsword"}
          TORBOXARR_SAB_API_KEY=${config.sops.placeholder."torboxarr/sab_api_key"}
        '';

        systemd.services.torboxarr = {
          description = "TorBoxarr Download Backend";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            User = "root"; # Needs root to write to /mnt/pool as media group if necessary, or we can use a dedicated user
            Group = "media";
            StateDirectory = "torboxarr";
            WorkingDirectory = "/var/lib/torboxarr";
            EnvironmentFile = config.sops.templates."torboxarr.env".path;
            Environment = [
              "TORBOXARR_SERVER_BASE_URL=http://localhost:8085"
              "TORBOXARR_DATA_ROOT=/mnt/pool/arr"
              "TORBOXARR_DATABASE_PATH=/var/lib/torboxarr/torboxarr.db"
            ];
            ExecStart = "${pkgs.callPackage ../../packages/torboxarr/default.nix { }}/bin/torboxarr";
            Restart = "on-failure";
          };
        };

        networking.firewall.allowedTCPPorts = [ 8085 7575 ];

        # Sonarr (TV)
        services.sonarr = {
          enable = true;
          group = "media";
          openFirewall = true;
        };

        # Radarr (Movies)
        services.radarr = {
          enable = true;
          group = "media";
          openFirewall = true;
        };

        # Prowlarr (Indexers)
        services.prowlarr = {
          enable = true;
          openFirewall = true;
        };

        # Jellyfin (Media Server)
        services.jellyfin = {
          enable = true;
          group = "media";
          openFirewall = true;
        };

        # Homarr Dashboard
        virtualisation.oci-containers.containers.homarr = {
          image = "ghcr.io/ajnart/homarr:latest";
          ports = [ "7575:7575" ];
          volumes = [
            "/var/lib/homarr/configs:/app/data/configs"
            "/var/lib/homarr/icons:/app/public/icons"
            "/var/lib/homarr/data:/data"
          ];
        };

        # Ensure the media directories exist with the correct group ownership and permissions
        systemd.tmpfiles.rules = [
          "d /var/lib/homarr 0755 root root -"
          "d /var/lib/homarr/configs 0755 root root -"
          "d /var/lib/homarr/icons 0755 root root -"
          "d /var/lib/homarr/data 0755 root root -"
          "d /var/lib/torboxarr 0775 root media -"
          "d /mnt/pool/arr 0775 root media -"
          "d /mnt/pool/arr/downloads 0775 root media -"
          "d /mnt/pool/arr/media 0775 root media -"
          "d /mnt/pool/arr/media/tv 0775 sonarr media -"
          "d /mnt/pool/arr/media/movies 0775 radarr media -"

          # State directories for the Arr apps so we can seed their configs
          "d /var/lib/sonarr/.config/NzbDrone 0700 sonarr media -"
          "d /var/lib/radarr/.config/Radarr 0700 radarr media -"
          "d /var/lib/prowlarr/Prowlarr 0700 prowlarr media -"

          # Seed deterministic API keys
          "f /var/lib/sonarr/.config/NzbDrone/config.xml 0600 sonarr media - <Config><ApiKey>sonarr_api_key_12345</ApiKey><Port>8989</Port><BindAddress>*</BindAddress></Config>"
          "f /var/lib/radarr/.config/Radarr/config.xml 0600 radarr media - <Config><ApiKey>radarr_api_key_12345</ApiKey><Port>7878</Port><BindAddress>*</BindAddress></Config>"
          "f /var/lib/prowlarr/Prowlarr/config.xml 0600 prowlarr media - <Config><ApiKey>prowlarr_api_key_12345</ApiKey><Port>9696</Port><BindAddress>*</BindAddress></Config>"
        ];

      };
  };
}
