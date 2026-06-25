_: {
  den.aspects.media._.arr = {
    nixos = { pkgs, lib, ... }: {
      # Sonarr (TV)
      services.sonarr = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.sonarr.serviceConfig.ExecStartPre = lib.mkAfter [
        "+${pkgs.coreutils}/bin/chown -R media:media /var/lib/sonarr"
        "+${pkgs.coreutils}/bin/chmod -R u+rwX,g+rwX /var/lib/sonarr"
      ];

      # Radarr (Movies)
      services.radarr = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.radarr.serviceConfig.ExecStartPre = lib.mkAfter [
        "+${pkgs.coreutils}/bin/chown -R media:media /var/lib/radarr"
        "+${pkgs.coreutils}/bin/chmod -R u+rwX,g+rwX /var/lib/radarr"
      ];

      # Lidarr (Music)
      services.lidarr = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.lidarr.serviceConfig.ExecStartPre = lib.mkAfter [
        "+${pkgs.coreutils}/bin/chown -R media:media /var/lib/lidarr"
        "+${pkgs.coreutils}/bin/chmod -R u+rwX,g+rwX /var/lib/lidarr"
      ];

      # Prowlarr (Indexers)
      services.prowlarr = {
        enable = true;
      };

      systemd.services.prowlarr.serviceConfig = {
        User = "media";
        Group = "media";
      };

      systemd.services.prowlarr.serviceConfig.ExecStartPre = lib.mkAfter [
        "+${pkgs.coreutils}/bin/chown -R media:media /var/lib/prowlarr"
        "+${pkgs.coreutils}/bin/chmod -R u+rwX,g+rwX /var/lib/prowlarr"
      ];

      # SABnzbd (Download Client)
      services.sabnzbd = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.sabnzbd.serviceConfig.ExecStartPre = lib.mkAfter [
        "+${pkgs.coreutils}/bin/chown -R media:media /var/lib/sabnzbd"
        "+${pkgs.coreutils}/bin/chmod -R u+rwX,g+rwX /var/lib/sabnzbd"
      ];
    };
  };
}
