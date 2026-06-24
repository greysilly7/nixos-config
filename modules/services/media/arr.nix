_: {
  den.aspects.media._.arr = {
    nixos = _: {
      # Sonarr (TV)
      services.sonarr = {
        enable = true;
        group = "media";
        openFirewall = false;
      };

      # Radarr (Movies)
      services.radarr = {
        enable = true;
        group = "media";
        openFirewall = false;
      };

      # Lidarr (Music)
      services.lidarr = {
        enable = true;
        group = "media";
        openFirewall = false;
      };

      # Prowlarr (Indexers)
      services.prowlarr = {
        enable = true;
        openFirewall = true;
      };

      # SABnzbd (Download Client)
      services.sabnzbd = {
        enable = true;
        group = "media";
        openFirewall = false;
      };
    };
  };
}
