_: {
  den.aspects.media._.jellyfin = {
    nixos = _: {
      # Jellyfin (Media Server)
      services.jellyfin = {
        enable = true;
        user = "media";
        group = "media";
      };

      systemd.services.jellyfin.after = [ "riven.service" ];
    };
  };
}
