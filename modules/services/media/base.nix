_: {
  den.aspects.media._.base = {
    nixos = _: {
      # Define a common media user and group for all services to share permissions
      users.groups.media = { };
      users.users.media = {
        isSystemUser = true;
        group = "media";
      };

      # Ensure the media directories exist with the correct group ownership and permissions
      systemd.tmpfiles.rules = [
        "d /var/lib/homarr 0755 root root -"
        "d /var/lib/homarr/configs 0755 root root -"
        "d /var/lib/homarr/icons 0755 root root -"
        "d /var/lib/homarr/data 0755 root root -"
        "d /var/lib/aiostreams 0755 root root -"
        "d /var/lib/aiostreams/data 0755 root root -"
        "d /var/lib/zipline 0755 root root -"
        "d /var/lib/zipline/db 0755 root root -"
        "d /var/lib/zipline/uploads 0755 root root -"
        "d /var/lib/zipline/public 0755 root root -"
        "d /var/lib/torboxarr 0775 media media -"
        "d /mnt/pool/arr 0775 media media -"
        "d /mnt/pool/arr/completed 0775 media media -"
        "d /mnt/pool/arr/completed/lidarr 0775 media media -"
        "d /mnt/pool/arr/completed/sonarr 0775 media media -"
        "d /mnt/pool/arr/completed/radarr 0775 media media -"
        "d /mnt/pool/arr/downloads 0775 media media -"
        "d /mnt/pool/arr/media 0775 media media -"
        "d /mnt/pool/arr/media/tv 0775 media media -"
        "d /mnt/pool/arr/media/movies 0775 media media -"
        "d /mnt/pool/arr/media/music 0775 media media -"
        "Z /mnt/pool/arr - media media -"

        # State directories for the Arr apps so we can seed their configs
        "d /var/lib/sonarr 0755 media media -"
        "d /var/lib/sonarr/.config 0755 media media -"
        "d /var/lib/sonarr/.config/NzbDrone 0700 media media -"
        "Z /var/lib/sonarr - media media -"

        "d /var/lib/radarr 0755 media media -"
        "d /var/lib/radarr/.config 0755 media media -"
        "d /var/lib/radarr/.config/Radarr 0700 media media -"
        "Z /var/lib/radarr - media media -"

        "d /var/lib/lidarr 0755 media media -"
        "d /var/lib/lidarr/.config 0755 media media -"
        "d /var/lib/lidarr/.config/Lidarr 0700 media media -"
        "Z /var/lib/lidarr - media media -"

        "d /var/lib/prowlarr 0755 media media -"
        "Z /var/lib/prowlarr - media media -"

        "d /var/lib/sabnzbd 0755 media media -"
        "Z /var/lib/sabnzbd - media media -"
      ];
    };
  };
}
