_: {
  den.aspects.media = {
    nixos =
      { pkgs, ... }:
      {
        # Define a common media group for all services to share permissions
        users.groups.media = { };

        # Native RDT_Client Service
        systemd.services.rdt-client = {
          description = "Real-Debrid Client";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            Type = "simple";
            User = "root";
            Group = "media";
            StateDirectory = "rdt-client";
            WorkingDirectory = "/var/lib/rdt-client";
            ExecStartPre =
              let
                rdtPkg = pkgs.callPackage ../../packages/rdt-client/default.nix { };
              in
              pkgs.writeScript "rdt-client-setup" ''
                #!${pkgs.bash}/bin/bash
                # Remove old symlinks
                ${pkgs.findutils}/bin/find /var/lib/rdt-client -maxdepth 1 -type l -delete
                # Create symlinks to immutable files
                for f in ${rdtPkg}/share/rdt-client/*; do
                  name=$(${pkgs.coreutils}/bin/basename "$f")
                  if [ ! -e "/var/lib/rdt-client/$name" ]; then
                    ${pkgs.coreutils}/bin/ln -s "$f" "/var/lib/rdt-client/$name"
                  fi
                done
              '';
            ExecStart = "${pkgs.callPackage ../../packages/rdt-client/default.nix { }}/bin/rdt-client";
            Restart = "on-failure";
          };
        };

        networking.firewall.allowedTCPPorts = [ 6500 ];

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

        # Ensure the media directories exist with the correct group ownership and permissions
        systemd.tmpfiles.rules = [
          "d /var/lib/rdt-client 0775 root root -"
          "d /mnt/pool/downloads 0775 root media -"
          "d /mnt/pool/media 0775 root media -"
          "d /mnt/pool/media/tv 0775 sonarr media -"
          "d /mnt/pool/media/movies 0775 radarr media -"

          # State directories for the Arr apps so we can seed their configs
          "d /var/lib/sonarr 0700 sonarr media -"
          "d /var/lib/radarr 0700 radarr media -"
          "d /var/lib/prowlarr 0700 prowlarr media -"

          # Seed deterministic API keys
          "f /var/lib/sonarr/config.xml 0600 sonarr media - <Config><ApiKey>sonarr_api_key_12345</ApiKey><Port>8989</Port><BindAddress>*</BindAddress></Config>"
          "f /var/lib/radarr/config.xml 0600 radarr media - <Config><ApiKey>radarr_api_key_12345</ApiKey><Port>7878</Port><BindAddress>*</BindAddress></Config>"
          "f /var/lib/prowlarr/config.xml 0600 prowlarr media - <Config><ApiKey>prowlarr_api_key_12345</ApiKey><Port>9696</Port><BindAddress>*</BindAddress></Config>"
        ];

      };
  };
}
