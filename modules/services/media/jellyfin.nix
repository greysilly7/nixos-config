_: {
  den.aspects.media._.jellyfin = {
    nixos = _: {
      # Jellyfin (Media Server)
      services.jellyfin = {
        enable = true;
        group = "media";
      };

      systemd.services.jellyfin.after = [ "riven.service" ];
    };
  };
}
