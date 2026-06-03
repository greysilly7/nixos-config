{ den, ... }:
{
  den.aspects.media = {
    nixos = _: {
      # Define a common media group for all services to share permissions
      users.groups.media = { };

      # Transmission Download Client
      services.transmission = {
        enable = true;
        group = "media";
        openFirewall = true;
        settings = {
          download-dir = "/mnt/pool/downloads/completed";
          incomplete-dir = "/mnt/pool/downloads/incomplete";
          incomplete-dir-enabled = true;
          rpc-bind-address = "0.0.0.0";
          rpc-whitelist-enabled = false;
          rpc-host-whitelist-enabled = false;
          umask = 2; # 002 means files are created with 775/664 permissions
        };
      };

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
        "d /mnt/pool/downloads 0775 transmission media -"
        "d /mnt/pool/downloads/completed 0775 transmission media -"
        "d /mnt/pool/downloads/incomplete 0775 transmission media -"
        "d /mnt/pool/media 0775 root media -"
        "d /mnt/pool/media/tv 0775 sonarr media -"
        "d /mnt/pool/media/movies 0775 radarr media -"
      ];
    };
  };
}
