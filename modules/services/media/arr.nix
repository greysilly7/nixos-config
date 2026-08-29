_: {
  den.aspects.media._.arr = {
    nixos = { pkgs, lib, ... }:
      let
        fixOwnership = import ../../../lib/mkFixOwnership.nix { inherit pkgs lib; };
      in
      {
      # Sonarr (TV)
      services.sonarr = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.sonarr.serviceConfig.ExecStartPre = fixOwnership "/var/lib/sonarr";

      # Radarr (Movies)
      services.radarr = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.radarr.serviceConfig.ExecStartPre = fixOwnership "/var/lib/radarr";

      # Lidarr (Music)
      services.lidarr = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.lidarr.serviceConfig.ExecStartPre = fixOwnership "/var/lib/lidarr";

      # Prowlarr (Indexers)
      services.prowlarr = {
        enable = true;
      };

      systemd.services.prowlarr.serviceConfig = {
        User = "media";
        Group = "media";
      };

      systemd.services.prowlarr.serviceConfig.ExecStartPre = fixOwnership "/var/lib/prowlarr";

      # SABnzbd (Download Client)
      services.sabnzbd = {
        enable = false;
        user = "media";
        group = "media";
        openFirewall = false;
      };

      systemd.services.sabnzbd.serviceConfig.ExecStartPre = fixOwnership "/var/lib/sabnzbd";
    };
  };
}
