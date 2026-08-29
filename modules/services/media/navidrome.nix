_: {
  den.aspects.media._.navidrome = {
    nixos = _: {
      # Navidrome (Music Streaming)
      services.navidrome = {
        enable = true;
        user = "media";
        group = "media";
        openFirewall = false;
        settings = {
          MusicFolder = "/mnt/pool/arr/media/music";
        };
      };
    };
  };
}
